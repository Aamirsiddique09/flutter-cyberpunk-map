import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapui/data/repositories/widgets/location_card.dart';
import 'package:mapui/data/repositories/widgets/pin_painter.dart';
import 'package:mapui/data/repositories/widgets/search_header.dart';
import 'package:mapui/data/repositories/widgets/tile_button.dart';
import 'package:mapui/data/repositories/widgets/zoom_controls.dart';
import 'package:mapui/data/state/map_state.dart';
import '../../core/constants/app_colors.dart';
import '../../core/map/free_routing_service.dart';
import '../../core/map/free_tile_providers.dart';
import '../../core/memory/object_pool.dart';
import '../../data/repositories/mock_location_repository.dart';
import '../../domain/models/location_model.dart';
import '../../domain/models/filter_model.dart';

class RealMapScreen extends StatefulWidget {
  const RealMapScreen({super.key});

  @override
  State<RealMapScreen> createState() => _RealMapScreenState();
}

class _RealMapScreenState extends State<RealMapScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final MapState _state;
  late final ObjectPool<AnimationController> _animationPool;
  late final MapController _mapController;

  Timer? _debounceTimer;
  final TextEditingController _searchController = TextEditingController();

  TileLayer _currentTileLayer = FreeTileProviders.darkMatter;
  bool _showRoute = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _mapController = MapController();
    _state = MapState();
    _animationPool = ObjectPool<AnimationController>(
      factory: () => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
      initialSize: 3,
      maxSize: 10,
      reset: (controller) => controller.reset(),
    );

    _initializeData();
  }

  Future<void> _initializeData() async {
    _state.isLoading.value = true;

    final locations = MockLocationRepository.getLocations();
    _state.locations.value = locations;
    _state.filters.value = MockLocationRepository.getFilters();

    if (locations.isNotEmpty) {
      _state.selectLocation(locations.first);
    }

    _state.isLoading.value = false;
  }

  void _onMapEvent(MapEvent event) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 150), () {
      final bounds = _mapController.camera.visibleBounds;
      final latLngBounds = LatLngBounds(
        LatLng(bounds.southWest.latitude, bounds.southWest.longitude),
        LatLng(bounds.northEast.latitude, bounds.northEast.longitude),
      );
      _state.updateVisibleMarkers(latLngBounds);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _debounceTimer?.cancel();
    _searchController.dispose();
    _mapController.dispose();
    _animationPool.clear();
    _state.dispose();
    super.dispose();
  }

  void _changeTileProvider(TileLayer newProvider) {
    setState(() {
      _currentTileLayer = newProvider;
    });
  }

  void _getDirections(LocationModel location) async {
    HapticFeedback.mediumImpact();

    final start = const LatLng(35.6762, 139.6503);
    final end = LatLng(location.latitude, location.longitude);

    _state.isLoading.value = true;

    final route = await FreeRoutingService.getRoute(
      start: start,
      end: end,
      profile: 'driving',
    );

    if (route != null) {
      _state.currentRoute.value = route;
      setState(() => _showRoute = true);

      final points = route.points;
      if (points.isNotEmpty) {
        final bounds = LatLngBounds.fromPoints(points);
        _mapController.fitCamera(
          CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(100)),
        );
      }
    }

    _state.isLoading.value = false;
  }

  void _shareLocation(LocationModel location) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${location.name}...'),
        backgroundColor: AppColors.surface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // REAL MAP WITH FREE TILES
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(35.6762, 139.6503),
              initialZoom: 13,
              maxZoom: 19,
              minZoom: 3,
              onMapEvent: _onMapEvent,
              keepAlive: true,
            ),
            children: [
              // FREE TILE LAYER
              _currentTileLayer,

              // ATTRIBUTION (Required)
              FreeTileProviders.attribution('darkMatter'),

              // ROUTE POLYLINE
              if (_showRoute && _state.currentRoute.value != null)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _state.currentRoute.value!.points,
                      strokeWidth: 4,
                      color: AppColors.primary,
                      borderStrokeWidth: 6,
                      borderColor: AppColors.primary.withOpacity(0.3),
                    ),
                  ],
                ),

              // SIMPLE MARKERS - NO CLUSTERING PACKAGE NEEDED
              _buildSimpleMarkers(),
            ],
          ),

          // UI Layer
          SafeArea(
            child: Column(
              children: [
                ValueListenableBuilder<List<FilterModel>>(
                  valueListenable: _state.filters,
                  builder: (context, filters, child) {
                    return SearchHeader(
                      filters: filters,
                      onFilterTap: (id) => _state.setFilterActive(id),
                      searchController: _searchController,
                    );
                  },
                ),

                _buildTileSwitcher(),

                const Spacer(),

                ValueListenableBuilder<LocationModel?>(
                  valueListenable: _state.selectedLocation,
                  builder: (context, selected, child) {
                    if (selected == null) return const SizedBox.shrink();
                    return LocationCard(
                      location: selected,
                      onFavoriteToggle: () =>
                          _state.toggleFavorite(selected.id),
                      onGetDirections: () => _getDirections(selected),
                      onShare: () => _shareLocation(selected),
                    );
                  },
                ),
              ],
            ),
          ),

          // Zoom Controls
          Positioned(
            right: 20,
            top: MediaQuery.of(context).size.height * 0.4,
            child: ZoomControls(
              onZoomIn: () => _mapController.move(
                _mapController.camera.center,
                _mapController.camera.zoom + 1,
              ),
              onZoomOut: () => _mapController.move(
                _mapController.camera.center,
                _mapController.camera.zoom - 1,
              ),
              onCenter: () {
                HapticFeedback.mediumImpact();
                _mapController.move(const LatLng(35.6762, 139.6503), 15);
              },
            ),
          ),

          // Loading Overlay
          ValueListenableBuilder<bool>(
            valueListenable: _state.isLoading,
            builder: (context, isLoading, child) {
              if (!isLoading) return const SizedBox.shrink();
              return Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // SIMPLE MARKERS WITHOUT ANY CLUSTERING PACKAGE
  Widget _buildSimpleMarkers() {
    return ValueListenableBuilder<List<LocationModel>>(
      valueListenable: _state.locations,
      builder: (context, locations, child) {
        return MarkerLayer(
          markers: locations
              .map(
                (loc) => Marker(
                  point: LatLng(loc.latitude, loc.longitude),
                  width: 48,
                  height: 60,
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      _state.selectLocation(loc);
                      _mapController.move(
                        LatLng(loc.latitude, loc.longitude),
                        16,
                      );
                    },
                    child: _buildMarkerWidget(loc),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildMarkerWidget(LocationModel location) {
    return ValueListenableBuilder<LocationModel?>(
      valueListenable: _state.selectedLocation,
      builder: (context, selected, child) {
        final isSelected = selected?.id == location.id;
        return RepaintBoundary(
          child: CustomPaint(
            size: const Size(48, 60),
            painter: PinPainter(
              color: location.type.color,
              isSelected: isSelected,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTileSwitcher() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Dark Matter - English (Default - Best for cyberpunk)
            TileButton(
              label: 'Dark',
              onTap: () => _changeTileProvider(FreeTileProviders.darkMatter),
              isActive: _currentTileLayer == FreeTileProviders.darkMatter,
            ),

            // Voyager - English (Clean style)
            TileButton(
              label: 'Clean',
              onTap: () => _changeTileProvider(FreeTileProviders.voyager),
              isActive: _currentTileLayer == FreeTileProviders.voyager,
            ),

            // Positron - English (Light theme)
            TileButton(
              label: 'Light',
              onTap: () => _changeTileProvider(FreeTileProviders.positron),
              isActive: _currentTileLayer == FreeTileProviders.positron,
            ),

            // Wikimedia - English
            TileButton(
              label: 'Wiki',
              onTap: () => _changeTileProvider(FreeTileProviders.wikimedia),
              isActive: _currentTileLayer == FreeTileProviders.wikimedia,
            ),

            // OSM Germany - Mixed but better than default
            TileButton(
              label: 'OSM',
              onTap: () => _changeTileProvider(FreeTileProviders.osmGermany),
              isActive: _currentTileLayer == FreeTileProviders.osmGermany,
            ),
          ],
        ),
      ),
    );
  }
}
