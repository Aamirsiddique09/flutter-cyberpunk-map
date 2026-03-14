import 'package:flutter/material.dart';
import 'package:mapui/core/constants/app_colors.dart';
import 'package:mapui/domain/models/filter_model.dart';
import 'filter_chip.dart' as custom;
import 'glass_container.dart';

class SearchHeader extends StatelessWidget {
  final List<FilterModel> filters;
  final Function(String) onFilterTap;
  final TextEditingController searchController;

  const SearchHeader({
    super.key,
    required this.filters,
    required this.onFilterTap,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Search Bar
          GlassContainer(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.search, color: AppColors.onSurfaceVariant, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search Neo-Tokyo...',
                      hintStyle: TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                Icon(Icons.mic, color: AppColors.primary, size: 20),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filters.map((filter) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: custom.FilterChip(
                    filter: filter,
                    onTap: () => onFilterTap(filter.id),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
