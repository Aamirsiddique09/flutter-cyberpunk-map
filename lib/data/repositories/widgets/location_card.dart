import 'package:flutter/material.dart';
import 'package:mapui/core/constants/app_colors.dart';
import 'package:mapui/domain/models/location_model.dart';
import 'action_button.dart';
import 'glass_container.dart';
import 'grid_pattern_painter.dart';

class LocationCard extends StatelessWidget {
  final LocationModel location;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onGetDirections;
  final VoidCallback onShare;

  const LocationCard({
    super.key,
    required this.location,
    required this.onFavoriteToggle,
    required this.onGetDirections,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GlassContainer(
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image Header
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    location.type.color.withOpacity(0.8),
                    location.type.color.withOpacity(0.4),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Pattern overlay
                  Positioned.fill(
                    child: CustomPaint(
                      painter: GridPatternPainter(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  // Type Icon
                  Center(
                    child: Icon(
                      location.type.icon,
                      size: 48,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  // Status Badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: location.isOpen
                            ? AppColors.success.withOpacity(0.2)
                            : AppColors.error.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: location.isOpen
                              ? AppColors.success
                              : AppColors.error,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        location.isOpen ? 'OPEN' : 'CLOSED',
                        style: TextStyle(
                          color: location.isOpen
                              ? AppColors.success
                              : AppColors.error,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: location.type.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          location.type.label.toUpperCase(),
                          style: TextStyle(
                            color: location.type.color,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(Icons.star, size: 16, color: AppColors.warning),
                          const SizedBox(width: 4),
                          Text(
                            location.rating.toString(),
                            style: const TextStyle(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    location.name,
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location.description,
                    style: const TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppColors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location.address,
                          style: const TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Tags
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: location.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '#$tag',
                          style: const TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),
                  const Divider(color: AppColors.glassBorder),
                  const SizedBox(height: 12),

                  // Action Buttons
                  Row(
                    children: [
                      ActionButton(
                        icon: location.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        label: location.isFavorite ? 'Saved' : 'Save',
                        color: location.isFavorite ? AppColors.secondary : null,
                        onTap: onFavoriteToggle,
                      ),
                      const SizedBox(width: 8),
                      ActionButton(
                        icon: Icons.directions,
                        label: 'Route',
                        color: AppColors.primary,
                        onTap: onGetDirections,
                      ),
                      const SizedBox(width: 8),
                      ActionButton(
                        icon: Icons.share,
                        label: 'Share',
                        onTap: onShare,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
