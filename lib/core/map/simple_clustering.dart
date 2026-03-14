import 'dart:math';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class SimpleClustering {
  static List<ClusterItem> clusterMarkers({
    required List<Marker> markers,
    required double zoom,
    required double clusterRadius,
  }) {
    if (zoom > 15) {
      return markers.map((m) => ClusterItem(marker: m, count: 1)).toList();
    }

    final clusters = <ClusterItem>[];
    final processed = <Marker>{};

    for (final marker in markers) {
      if (processed.contains(marker)) continue;

      final cluster = <Marker>[marker];
      processed.add(marker);

      for (final other in markers) {
        if (processed.contains(other)) continue;

        final distance = _calculateDistance(marker.point, other.point);
        if (distance < clusterRadius) {
          cluster.add(other);
          processed.add(other);
        }
      }

      clusters.add(
        ClusterItem(
          marker: cluster.first,
          count: cluster.length,
          points: cluster.map((m) => m.point).toList(),
        ),
      );
    }

    return clusters;
  }

  static double _calculateDistance(LatLng a, LatLng b) {
    const R = 6371000; // Earth's radius in meters
    final lat1 = a.latitude * pi / 180;
    final lat2 = b.latitude * pi / 180;
    final deltaLat = (b.latitude - a.latitude) * pi / 180;
    final deltaLon = (b.longitude - a.longitude) * pi / 180;

    final a1 =
        sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1) * cos(lat2) * sin(deltaLon / 2) * sin(deltaLon / 2);
    final c = 2 * atan2(sqrt(a1), sqrt(1 - a1));

    return R * c;
  }
}

class ClusterItem {
  final Marker marker;
  final int count;
  final List<LatLng>? points;

  ClusterItem({required this.marker, required this.count, this.points});

  bool get isCluster => count > 1;
}
