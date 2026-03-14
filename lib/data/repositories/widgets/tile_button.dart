import 'package:flutter/material.dart';
import 'package:mapui/core/constants/app_colors.dart';
import 'glass_container.dart';

class TileButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const TileButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: GlassContainer(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          borderRadius: 16,
          opacity: isActive ? 0.9 : 0.6,
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? AppColors.primary : AppColors.onSurface,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
