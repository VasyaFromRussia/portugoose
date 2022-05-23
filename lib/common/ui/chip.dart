import 'package:flutter/material.dart';
import 'package:portugoose/common/ui/card.dart';
import 'package:portugoose/common/ui/palette.dart';
import 'package:portugoose/common/ui/text_theme.dart';

class Chip extends StatefulWidget {
  Chip({
    required this.child,
    this.onPressed,
    this.isEnabled = true,
    this.isSticky = true,
    this.isPressed = false,
    this.color = Palette.grey100,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final Function(bool isPressed)? onPressed;
  final bool isEnabled;
  final bool isPressed;
  final bool isSticky;
  final Color color;

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
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: widget.isEnabled && widget.onPressed != null
            ? (_) {
                widget.onPressed?.call(!_isPressed);
                _mustAnimateBack = !widget.isSticky;
                setState(() => _isPressed = !_isPressed);
              }
            : null,
        onTapUp: (_) {
          if (_mustAnimateBack) {
            _mustAnimateBack = false;
            setState(() => _isPressed = !_isPressed);
          }
        },
        child: CardContainer(
          height: 38,
          radius: 12,
          color: widget.color,
          shadowOffset: const Offset(0, 2),
          shadowColor: _isPressed ? null : Palette.grey500,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Center(child: widget.child),
          ),
        ),
      );
}
