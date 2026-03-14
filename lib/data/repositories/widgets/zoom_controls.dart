import 'package:flutter/material.dart';
import 'package:mapui/core/constants/app_colors.dart';
import 'glass_container.dart';

class ZoomControls extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onCenter;

  const ZoomControls({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onCenter,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(8),
      borderRadius: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ControlButton(icon: Icons.add, onTap: onZoomIn),
          const Divider(
            color: AppColors.glassBorder,
            height: 8,
            indent: 4,
            endIndent: 4,
          ),
          _ControlButton(icon: Icons.remove, onTap: onZoomOut),
          const Divider(
            color: AppColors.glassBorder,
            height: 8,
            indent: 4,
            endIndent: 4,
          ),
          _ControlButton(
            icon: Icons.my_location,
            onTap: onCenter,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const _ControlButton({required this.icon, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: color ?? AppColors.onSurface, size: 24),
        ),
      ),
    );
  }
}
