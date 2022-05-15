import 'package:flutter/material.dart';
import 'package:portugoose/common/ui/card.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    required this.text,
    required this.onPressed,
    required this.color,
    required this.isEnabled,
    this.disabledColor,
    this.textStyle,
    Key? key,
  }) : super(key: key);

  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final Color? disabledColor;
  final TextStyle? textStyle;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onPressed,
        child: CardContainer(
          height: 50,
          color: isEnabled ? color : (disabledColor ?? color),
          child: Text(
            text,
            style: textStyle,
          ),
        ),
      );
}
