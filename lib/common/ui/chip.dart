import 'package:flutter/material.dart';
import 'package:portugoose/common/ui/text_theme.dart';

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
              style: buttonStyle.copyWith(
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
