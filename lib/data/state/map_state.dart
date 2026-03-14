import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/map/free_routing_service.dart';
import '../../data/repositories/mock_location_repository.dart';
import '../../domain/models/location_model.dart';
import '../../domain/models/filter_model.dart';

class MapState {
  final ValueNotifier<List<LocationModel>> locations = ValueNotifier([]);
  final ValueNotifier<List<FilterModel>> filters = ValueNotifier([]);
  final ValueNotifier<LocationModel?> selectedLocation = ValueNotifier(null);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<List<LocationModel>> visibleMarkers = ValueNotifier([]);
  final ValueNotifier<RouteResult?> currentRoute = ValueNotifier(null);

  void selectLocation(LocationModel? location) {
    selectedLocation.value = location;
  }

  void toggleFavorite(String id) {
    final currentList = locations.value;
    final updatedList = currentList.map((loc) {
      if (loc.id == id) {
        return loc.copyWith(isFavorite: !loc.isFavorite);
      }
      return loc;
    }).toList();
    locations.value = updatedList;

    if (selectedLocation.value?.id == id) {
      selectedLocation.value = updatedList.firstWhere((l) => l.id == id);
    }
  }

  void setFilterActive(String filterId) {
    final currentFilters = filters.value;
    final updatedFilters = currentFilters.map((f) {
      return FilterModel(
        id: f.id,
        name: f.name,
        type: f.type,
        isActive: f.id == filterId,
      );
    }).toList();
    filters.value = updatedFilters;

    _applyFilter();
  }

  void _applyFilter() {
    final activeFilter = filters.value.firstWhere(
      (f) => f.isActive,
      orElse: () => filters.value.first,
    );

    if (activeFilter.id == 'all') {
      locations.value = MockLocationRepository.getLocations();
    } else {
      final allLocations = MockLocationRepository.getLocations();
      locations.value = allLocations
          .where((l) => l.type == activeFilter.type)
          .toList();
    }
  }

  void updateVisibleMarkers(LatLngBounds bounds) {
    final currentLocations = locations.value;
    final visible = currentLocations.where((loc) {
      return bounds.contains(LatLng(loc.latitude, loc.longitude));
    }).toList();
    visibleMarkers.value = visible;
  }

  Future<void> getDirectionsTo(LocationModel destination) async {
    if (selectedLocation.value == null) return;

    isLoading.value = true;

    final start = LatLng(
      selectedLocation.value!.latitude,
      selectedLocation.value!.longitude,
    );
    final end = LatLng(destination.latitude, destination.longitude);

    final route = await FreeRoutingService.getRoute(start: start, end: end);

    currentRoute.value = route;
    isLoading.value = false;
  }

  void clearRoute() {
    currentRoute.value = null;
  }

  void dispose() {
    locations.dispose();
    filters.dispose();
    selectedLocation.dispose();
    isLoading.dispose();
    visibleMarkers.dispose();
    currentRoute.dispose();
  }
}
