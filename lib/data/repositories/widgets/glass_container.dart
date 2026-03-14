import 'package:flutter/material.dart';
import 'package:mapui/core/constants/app_colors.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double opacity;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Border? border;
  final List<BoxShadow>? boxShadow;

  const GlassContainer({
    super.key,
    required this.child,
    this.opacity = 0.7,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.border,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(opacity),
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ?? Border.all(color: AppColors.glassBorder, width: 1),
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
                blurRadius: 30,
                spreadRadius: -5,
              ),
            ],
      ),
      child: child,
    );
  }
}
