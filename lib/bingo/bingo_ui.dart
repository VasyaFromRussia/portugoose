import 'package:flutter/material.dart' hide Chip;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portugoose/common/ui/card.dart';
import 'package:portugoose/common/ui/chip.dart';
import 'package:portugoose/common/ui/keyboard.dart';
import 'package:portugoose/common/ui/palette.dart';
import 'package:portugoose/common/ui/text_theme.dart';

class BingoScreen extends StatelessWidget {
  const BingoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const CardContainer(
                  height: 256,
                  color: Palette.grey100,
                  child: const _Question(),
                ),
                const SizedBox(height: 16),
                Keyboard.bingo(
                  numbers: const [1, 4, 11, 17, 23, 22, 32, 55],
                  onEdit: (_) {},
                ),
              ],
            ),
          ),
        ),
      );
}

class _Question extends StatelessWidget {
  const _Question({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Select the correct number',
                  style: Theme.of(context).textTheme.caption?.copyWith(color: Palette.grey500),
                ),
                const SizedBox(height: 8),
                Text(
                  'Vinte e oito',
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Palette.grey900),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 48,
                  child: Chip(
                    child: Text(
                      '28',
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Palette.grey900),
                    ),
                    isEnabled: false,
                    isPressed: true,
                    color: Palette.grey300,
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            right: 16,
            top: 16,
            child: TimeIndicator(
              duration: Duration(seconds: 5),
            ),
          ),
        ],
      );
}

class BingoKeyboard extends StatelessWidget {
  const BingoKeyboard({
    required this.items,
    Key? key,
  }) : super(key: key);

  final List<int> items;

  @override
  Widget build(BuildContext context) => Keyboard.bingo(
        numbers: items,
        onEdit: (_) {},
      );
}

class TimeIndicator extends StatefulWidget {
  const TimeIndicator({
    required this.duration,
    Key? key,
  }) : super(key: key);

  final Duration duration;

  @override
  State<TimeIndicator> createState() => _TimeIndicatorState();
}

class _TimeIndicatorState extends State<TimeIndicator> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: widget.duration)
    ..addListener(() => setState(() {}))
    ..forward();

  @override
  Widget build(BuildContext context) => SizedBox.square(
        dimension: 24,
        child: Stack(
          children: [
            Positioned.fill(
              child: CircularProgressIndicator(
                value: _controller.value,
                backgroundColor: Palette.deepPurpleLite,
                strokeWidth: 2,
                valueColor: const AlwaysStoppedAnimation(Palette.deepPurple),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Text(
                  "$_secondsLeft",
                  style: Theme.of(context).textTheme.caption?.copyWith(color: Palette.deepPurple),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      );

  int get _secondsLeft => (widget.duration.inSeconds * (1 - _controller.value)).toInt() + 1;
}

class _CorrectIndicator extends StatelessWidget {
  const _CorrectIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox.square(
        dimension: 24,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            shape: CircleBorder(),
            color: Palette.green,
          ),
          child: Icon(
            Icons.check,
            color: Palette.grey100,
            size: 16,
          ),
        ),
      );
}

class _ErrorIndicator extends StatelessWidget {
  const _ErrorIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox.square(
        dimension: 24,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            shape: CircleBorder(),
            color: Palette.red,
          ),
          child: Icon(
            Icons.close,
            color: Palette.grey100,
            size: 16,
          ),
        ),
      );
}
