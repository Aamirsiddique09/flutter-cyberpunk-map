import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

enum LocationType {
  restaurant('Restaurant', AppColors.restaurant, Icons.restaurant),
  shopping('Shopping', AppColors.shopping, Icons.shopping_bag),
  entertainment('Entertainment', AppColors.entertainment, Icons.movie),
  landmark('Landmark', AppColors.landmark, Icons.account_balance),
  tech('Tech Hub', AppColors.tech, Icons.computer),
  nightlife('Nightlife', AppColors.nightlife, Icons.nightlife);

  final String label;
  final Color color;
  final IconData icon;

  const LocationType(this.label, this.color, this.icon);
}

class LocationModel {
  final String id;
  final String name;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final LocationType type;
  final double rating;
  final bool isOpen;
  final List<String> tags;
  final String? imageUrl;
  bool isFavorite;

  LocationModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.type,
    this.rating = 0.0,
    this.isOpen = true,
    this.tags = const [],
    this.imageUrl,
    this.isFavorite = false,
  });

  LocationModel copyWith({bool? isFavorite}) {
    return LocationModel(
      id: id,
      name: name,
      description: description,
      address: address,
      latitude: latitude,
      longitude: longitude,
      type: type,
      rating: rating,
      isOpen: isOpen,
      tags: tags,
      imageUrl: imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
