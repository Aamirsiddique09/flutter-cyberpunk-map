import 'package:flutter/material.dart';
import 'package:mapui/core/constants/app_colors.dart';
import 'package:mapui/domain/models/filter_model.dart';

class FilterChip extends StatelessWidget {
  final FilterModel filter;
  final VoidCallback onTap;

  const FilterChip({super.key, required this.filter, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isActive = filter.isActive;
    final color = filter.type?.color ?? AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? color.withOpacity(0.2)
              : AppColors.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? color : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (filter.type != null) ...[
              Icon(
                filter.type!.icon,
                size: 16,
                color: isActive ? color : AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              filter.name,
              style: TextStyle(
                color: isActive ? color : AppColors.onSurfaceVariant,
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
