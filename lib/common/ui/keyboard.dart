import 'dart:collection';

import 'package:flutter/material.dart' hide Chip;
import 'package:portugoose/common/ui/chip.dart';
import 'package:collection/collection.dart';

class Keyboard extends StatefulWidget {
  static const _keysCount = 22;

  factory Keyboard.text({
    required String text,
    required void Function(String) onEdit,
  }) =>
      Keyboard._(
        items: _generateItemsForText(text, _keysCount),
        onEdit: onEdit,
      );

  factory Keyboard.bingo({
    required List<int> numbers,
    required void Function(String) onEdit,
  }) =>
      Keyboard._(
        items: _generateItemsForBingo(numbers, 24),
        onEdit: onEdit,
      );

  const Keyboard._({
    required this.items,
    required this.onEdit,
    Key? key,
  }) : super(key: key);

  final List<KeyboardItem> items;
  final void Function(String text) onEdit;

  @override
  State<Keyboard> createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {
  static const _rowTotalWeight = 6;

  final _pressedButtons = Queue<Key>();

  final List<String> result = [];

  @override
  void didUpdateWidget(Keyboard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!const ListEquality().equals(oldWidget.items, widget.items)) {
      setState(() {
        result.clear();
        _pressedButtons.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<List<Widget>> rows = [];

    var totalWeight = 0;
    for (var item in widget.items) {
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
    } else if (item is SymbolKeyboardItem) {
      final key = ValueKey(item);
      return Chip(
        key: key,
        child: Text(item.symbol),
        onPressed: (isPressed) {
          if (isPressed) {
            _pressedButtons.add(key);
            result.add(item.symbol);
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

class SymbolKeyboardItem implements KeyboardItem {
  SymbolKeyboardItem(
    this.symbol, [
    this.appearance = SymbolKeyboardItemAppearance.regular,
  ]);

  final String symbol;
  final SymbolKeyboardItemAppearance appearance;
}

class BackspaceKeyboardItem implements KeyboardItem {}

enum SymbolKeyboardItemAppearance {
  regular,
  correct,
  error,
}

List<KeyboardItem> _generateItemsForText(String text, int keysCount) {
  final items = <KeyboardItem>[];
  items
    ..addAll(text.split('').map((e) => SymbolKeyboardItem(e)).toList())
    ..addAll(List.generate(keysCount - items.length, (index) => EmptyKeyboardItem()))
    ..shuffle()
    ..insert(4, BackspaceKeyboardItem());

  return items;
}

List<KeyboardItem> _generateItemsForBingo(List<int> numbers, int keysCount) {
  final items = <KeyboardItem>[];

  items
    ..addAll(numbers.map((e) => SymbolKeyboardItem("$e")).toList())
    ..addAll(List<KeyboardItem>.generate(keysCount - items.length, (index) => EmptyKeyboardItem()))
    ..shuffle();

  return items;
}

class Number {
  Number({
    required this.value,
    this.isCorrect,
  });

  final int value;
  bool? isCorrect;
}
