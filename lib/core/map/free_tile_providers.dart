import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';

class FreeTileProviders {
  /// 🌐 CARTO Dark Matter - English labels (Best for cyberpunk)
  static TileLayer get darkMatter => TileLayer(
    urlTemplate:
        'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
    subdomains: const ['a', 'b', 'c', 'd'],
    userAgentPackageName: 'com.neotokyo.map',
    maxZoom: 20,
    // Force English labels via query param if available
    additionalOptions: const {'lang': 'en'},
  );

  /// 🌐 CARTO Voyager - English labels (Clean modern style)
  static TileLayer get voyager => TileLayer(
    urlTemplate:
        'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
    subdomains: const ['a', 'b', 'c', 'd'],
    userAgentPackageName: 'com.neotokyo.map',
    maxZoom: 20,
    additionalOptions: const {'lang': 'en'},
  );

  /// 🌐 CARTO Positron - Light theme with English labels
  static TileLayer get positron => TileLayer(
    urlTemplate:
        'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
    subdomains: const ['a', 'b', 'c', 'd'],
    userAgentPackageName: 'com.neotokyo.map',
    maxZoom: 20,
  );

  /// 🌐 OpenStreetMap DE - German/English (better than default OSM)
  static TileLayer get osmGermany => TileLayer(
    urlTemplate: 'https://tile.openstreetmap.de/{z}/{x}/{y}.png',
    userAgentPackageName: 'com.neotokyo.map',
    maxZoom: 19,
  );

  /// 🌐 Wikimedia Maps - Guaranteed English labels
  static TileLayer get wikimedia => TileLayer(
    urlTemplate: 'https://maps.wikimedia.org/osm-intl/{z}/{x}/{y}.png',
    userAgentPackageName: 'com.neotokyo.map',
    maxZoom: 19,
  );

  /// 🌐 OpenMapTiles (English focused) - Requires no key for basic use
  static TileLayer get openMapTiles => TileLayer(
    urlTemplate: 'https://tiles.openfreemap.org/styles/liberty/{z}/{x}/{y}.png',
    userAgentPackageName: 'com.neotokyo.map',
    maxZoom: 19,
  );

  /// 🌐 Thunderforest Atlas - English (requires free API key for production)
  /// Get free key at: https://www.thunderforest.com/
  static TileLayer thunderforest(String apiKey) => TileLayer(
    urlTemplate:
        'https://{s}.tile.thunderforest.com/atlas/{z}/{x}/{y}.png?apikey=$apiKey',
    subdomains: const ['a', 'b', 'c'],
    userAgentPackageName: 'com.neotokyo.map',
    maxZoom: 22,
  );

  /// 🌐 Stadia Maps - English labels (requires free account)
  /// Get free key at: https://stadiamaps.com/
  static TileLayer stadiaDark(String apiKey) => TileLayer(
    urlTemplate:
        'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}.png?api_key=$apiKey',
    userAgentPackageName: 'com.neotokyo.map',
    maxZoom: 20,
  );

  /// Get attribution widget
  static Widget attribution(String providerName) {
    return RichAttributionWidget(
      attributions: [
        TextSourceAttribution(
          'OpenStreetMap contributors',
          onTap: () async {
            final uri = Uri.parse('https://www.openstreetmap.org/copyright');
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
        ),
        if (providerName.contains('Carto') ||
            providerName.contains('dark') ||
            providerName.contains('voyager') ||
            providerName.contains('positron'))
          TextSourceAttribution(
            'CARTO',
            onTap: () async {
              final uri = Uri.parse('https://carto.com/attributions');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
        if (providerName.contains('wikimedia'))
          TextSourceAttribution(
            'Wikimedia Maps',
            onTap: () async {
              final uri = Uri.parse('https://wikimediafoundation.org');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
      ],
    );
  }
}
