import 'dart:collection';

import 'package:flutter/material.dart' hide Chip;
import 'package:portugoose/common/ui/chip.dart';

class Keyboard extends StatefulWidget {
  const Keyboard({
    required this.text,
    required this.onEdit,
    Key? key,
  }) : super(key: key);

  final String text;
  final void Function(String text) onEdit;

  @override
  State<Keyboard> createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {
  static const _keysCount = 22;
  static const _rowTotalWeight = 6;

  late final List<KeyboardItem> items = [];

  final _pressedButtons = Queue<Key>();

  final List<String> result = [];

  @override
  void initState() {
    super.initState();

    setState(() => _populate());
  }

  @override
  void didUpdateWidget(Keyboard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.text != widget.text) {
      setState(() {
        result.clear();
        _pressedButtons.clear();
        _populate();
      });
    }
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

  void _populate() {
    items
      ..clear()
      ..addAll(widget.text.split('').map((e) => LetterKeyboardItem(e)))
      ..addAll(List.generate(_keysCount - items.length, (index) => EmptyKeyboardItem()))
      ..shuffle()
      ..insert(4, BackspaceKeyboardItem());
  }
}

abstract class KeyboardItem {}

class EmptyKeyboardItem implements KeyboardItem {}

class LetterKeyboardItem implements KeyboardItem {
  LetterKeyboardItem(this.letter);

  final String letter;
}

class BackspaceKeyboardItem implements KeyboardItem {}
