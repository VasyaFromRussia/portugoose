import 'dart:collection';

import 'package:flutter/material.dart';

class SentenceTrainer extends StatefulWidget {
  const SentenceTrainer({Key? key}) : super(key: key);

  @override
  State<SentenceTrainer> createState() => _SentenceTrainerState();
}

class _SentenceTrainerState extends State<SentenceTrainer> {
  String _answer = "";

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 120,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: const Color(0xFFF2F2F7),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Beer",
                  style: _buttonStyle.copyWith(color: Color(0xFF1C1C1E)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: const Color(0xFF7438FF),
                ),
                alignment: Alignment.center,
                child: _answer.isEmpty
                    ? Text(
                        "Translate the word",
                        style: _buttonStyle.copyWith(color: Color(0xFFF2F2F7).withOpacity(0.5)),
                      )
                    : Text(
                        _answer,
                        style: _buttonStyle.copyWith(color: Color(0xFFF2F2F7)),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            WordKeyboard(
              text: "cerveja",
              onEdit: (result) => setState(() => _answer = result),
            ),
            Expanded(child: Container()),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFF7438FF),
              ),
              padding: EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              child: Text(
                "Check",
                style: _buttonStyle.copyWith(color: Color(0xFFF2F2F7)),
              ),
            ),
          ],
        ),
      );
}

class WordKeyboard extends StatefulWidget {
  const WordKeyboard({
    required this.text,
    required this.onEdit,
    Key? key,
  }) : super(key: key);

  final String text;
  final void Function(String text) onEdit;

  @override
  State<WordKeyboard> createState() => _WordKeyboardState();
}

class _WordKeyboardState extends State<WordKeyboard> {
  static const _keysCount = 22;
  static const _rowTotalWeight = 6;

  late final List<KeyboardItem> items = [];

  final _pressedButtons = Queue<Key>();

  final List<String> result = [];

  @override
  void initState() {
    super.initState();

    setState(() {
      items
        ..addAll(widget.text.split('').map((e) => LetterKeyboardItem(e)))
        ..addAll(List.generate(_keysCount - items.length, (index) => EmptyKeyboardItem()))
        ..shuffle()
        ..insert(4, BackspaceKeyboardItem());
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<List<Widget>> rows = [];

    var totalWeight = 0;
    for (var item in items) {
      if (totalWeight == 0) {
        rows.add([]);
      }

      final itemWeight = _getItemWeight(item);
      totalWeight += itemWeight;

      rows.last.add(
        Flexible(
            fit: FlexFit.tight,
            child: Padding(
              padding: EdgeInsets.only(
                left: totalWeight == 1 ? 0 : 6,
                top: 6,
                right: totalWeight == _rowTotalWeight ? 0 : 6,
                bottom: 6,
              ),
              child: _getItemWidget(item),
            ),
            flex: itemWeight),
      );

      if (totalWeight == _rowTotalWeight) {
        totalWeight = 0;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows
          .map(
            (row) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: row.map((item) => item).toList(),
            ),
          )
          .toList(),
    );
  }

  int _getItemWeight(KeyboardItem item) => item is BackspaceKeyboardItem ? 2 : 1;

  Widget _getItemWidget(KeyboardItem item) {
    if (item is BackspaceKeyboardItem) {
      return Chip(
        child: const Icon(
          Icons.backspace_rounded,
          size: 16,
          color: Color(0xFF1C1C1E),
        ),
        onPressed: (_) {
          if (_pressedButtons.isNotEmpty) {
            setState(() {
              _pressedButtons.removeLast();
              result.removeLast();
              widget.onEdit(result.join());
            });
          }
        },
        isSticky: false,
      );
    } else if (item is EmptyKeyboardItem) {
      return Chip(
        child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: SizedBox(
            width: 10,
            height: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF1C1C1E).withAlpha(40),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        isEnabled: false,
      );
    } else if (item is LetterKeyboardItem) {
      final key = ValueKey(item);
      return Chip(
        key: key,
        child: Text(item.letter),
        onPressed: (isPressed) {
          if (isPressed) {
            _pressedButtons.add(key);
            result.add(item.letter);
            widget.onEdit(result.join());
          }
        },
        isPressed: _pressedButtons.contains(key),
        isEnabled: !_pressedButtons.contains(key),
      );
    } else {
      throw "Unknown type";
    }
  }
}

abstract class KeyboardItem {}

class EmptyKeyboardItem implements KeyboardItem {}

class LetterKeyboardItem implements KeyboardItem {
  LetterKeyboardItem(this.letter);

  final String letter;
}

class BackspaceKeyboardItem implements KeyboardItem {}

class Chip extends StatefulWidget {
  Chip({
    required this.child,
    this.onPressed,
    this.isEnabled = true,
    this.isSticky = true,
    this.isPressed = false,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final Function(bool isPressed)? onPressed;
  final bool isEnabled;
  final bool isPressed;
  final bool isSticky;

  @override
  State<Chip> createState() => _ChipState();
}

class _ChipState extends State<Chip> {
  late bool _isPressed = widget.isPressed;

  int get _alpha => widget.isEnabled != false || _isPressed ? 255 : 255 ~/ 2;

  bool _mustAnimateBack = false;

  @override
  void didUpdateWidget(covariant Chip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPressed != widget.isPressed) {
      setState(() => _isPressed = widget.isPressed);
    }
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 38,
        child: GestureDetector(
          onTapDown: widget.isEnabled && widget.onPressed != null
              ? (_) {
                  widget.onPressed?.call(!_isPressed);
                  _mustAnimateBack = !widget.isSticky;
                  setState(() => _isPressed = !_isPressed);
                }
              : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFF2F2F7).withAlpha(_alpha),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD1D1D6).withAlpha(_alpha),
                  offset: _isPressed ? Offset.zero : const Offset(0, 2),
                )
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: AnimatedDefaultTextStyle(
              child: Center(child: widget.child),
              duration: const Duration(milliseconds: 150),
              style: _buttonStyle.copyWith(
                color: const Color(0xFF1C1C1E).withAlpha(_alpha),
              ),
            ),
          ),
          onTapUp: (_) {
            if (_mustAnimateBack) {
              _mustAnimateBack = false;
              setState(() => _isPressed = !_isPressed);
            }
          },
        ),
      );
}

TextStyle _buttonStyle = const TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 18,
  height: 1.2,
);
