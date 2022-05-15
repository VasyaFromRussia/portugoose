import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  const CardContainer({
    required this.color,
    required this.child,
    this.radius = 24,
    this.height,
    this.shadowColor,
    this.shadowOffset,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final double radius;
  final Color color;
  final Color? shadowColor;
  final Offset? shadowOffset;
  final double? height;

  @override
  Widget build(BuildContext context) => height != null
      ? SizedBox(
          height: height,
          child: _buildContent(),
        )
      : _buildContent();

  Widget _buildContent() => IntrinsicHeight(
    child: Stack(
          children: [
            if (shadowColor != null)
              Positioned(
                child: Padding(
                  padding: const EdgeInsets.all(0.1),
                  child: _buildCard(color: shadowColor!),
                ),
              ),
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: shadowColor == null ? 0 : shadowOffset?.dy ?? 0,
              child: _buildCard(
                child: child,
                color: color,
              ),
            ),
          ],
        ),
  );

  Widget _buildCard({
    required Color color,
    Widget? child,
  }) =>
      ClipSmoothRect(
        radius: SmoothBorderRadius(
          cornerRadius: radius,
          cornerSmoothing: 1,
        ),
        child: Container(
          color: color,
          alignment: Alignment.center,
          child: child,
        ),
      );
}
