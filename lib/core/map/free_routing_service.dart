import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class FreeRoutingService {
  static const String _baseUrl = 'https://router.project-osrm.org/route/v1';

  static Future<RouteResult?> getRoute({
    required LatLng start,
    required LatLng end,
    String profile = 'driving',
  }) async {
    try {
      final coordinates =
          '${start.longitude},${start.latitude};${end.longitude},${end.latitude}';
      final url =
          '$_baseUrl/$profile/$coordinates?overview=full&geometries=geojson';

      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['code'] == 'Ok') {
          final route = data['routes'][0];
          final geometry = route['geometry'];
          final coordinates = geometry['coordinates'] as List;

          final points = coordinates.map((coord) {
            return LatLng(coord[1] as double, coord[0] as double);
          }).toList();

          return RouteResult(
            points: points,
            distance: (route['distance'] as num).toDouble(),
            duration: (route['duration'] as num).toDouble(),
          );
        }
      }
      return null;
    } catch (e) {
      debugPrint('Routing error: $e');
      return null;
    }
  }

  static double getStraightLineDistance(LatLng a, LatLng b) {
    const Distance distance = Distance();
    return distance.as(LengthUnit.Meter, a, b);
  }
}

class RouteResult {
  final List<LatLng> points;
  final double distance;
  final double duration;

  RouteResult({
    required this.points,
    required this.distance,
    required this.duration,
  });

  String get formattedDistance => '${(distance / 1000).toStringAsFixed(1)} km';
  String get formattedDuration {
    final minutes = (duration / 60).round();
    if (minutes < 60) return '$minutes min';
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return '$hours h $remainingMinutes min';
  }
}
