import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portugoose/utils/ui_utils.dart';
import 'package:portugoose/verb/verb_provider.dart';

class BingoWidget extends ConsumerWidget {
  BingoWidget({Key? key}) : super(key: key);

  static const _cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(16)),
    boxShadow: [
      BoxShadow(
        color: Color(0x20000000),
        blurRadius: 8,
        offset: Offset(0, 5),
      ),
    ],
  );

  static const _iconCorrect = Icon(
    Icons.check,
    color: Color(0xFF70CDAE),
  );

  static const _iconWrong = Icon(
    Icons.close,
    color: Color(0xFFD66D4B),
  );

  final _buttonStyle = ElevatedButton.styleFrom(
    primary: const Color(0xFFF5DB71),
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  final _textEditingControllers = <VerbForm, TextEditingController>{};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(verbProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Trinte e sete'),
            SizedBox(height: 36),
            Container(
              decoration: _cardDecoration,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: List.generate(
                    4,
                    (index) => TableRow(
                      children: List.generate(
                        5,
                        (index) => Text(index.toString()),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: _cardDecoration,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: List.generate(
                    4,
                    (index) => TableRow(
                      children: List.generate(
                        5,
                        (index) => Text(index.toString()),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
