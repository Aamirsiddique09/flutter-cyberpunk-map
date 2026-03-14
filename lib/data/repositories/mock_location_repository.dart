import '../../domain/models/location_model.dart';
import '../../domain/models/filter_model.dart';

class MockLocationRepository {
  static List<LocationModel> getLocations() {
    return [
      // Restaurants
      LocationModel(
        id: '1',
        name: 'Neon Ramen Lab',
        description: 'Cyberpunk-themed ramen shop with holographic menus',
        address: 'Shibuya Crossing, Tokyo',
        latitude: 35.6595,
        longitude: 139.7004,
        type: LocationType.restaurant,
        rating: 4.8,
        isOpen: true,
        tags: ['ramen', 'cyberpunk', 'holographic'],
      ),
      LocationModel(
        id: '2',
        name: 'Sushi Synth',
        description: 'AI-powered sushi recommendation engine',
        address: 'Ginza, Tokyo',
        latitude: 35.6718,
        longitude: 139.7642,
        type: LocationType.restaurant,
        rating: 4.5,
        isOpen: true,
        tags: ['sushi', 'AI', 'premium'],
      ),

      // Shopping
      LocationModel(
        id: '3',
        name: 'Akihabara Electric Town',
        description: 'Retro-futuristic electronics district',
        address: 'Akihabara, Tokyo',
        latitude: 35.6984,
        longitude: 139.7731,
        type: LocationType.shopping,
        rating: 4.7,
        isOpen: true,
        tags: ['electronics', 'anime', 'retro'],
      ),
      LocationModel(
        id: '4',
        name: 'Shibuya 109',
        description: 'Iconic fashion mall with AR try-on',
        address: 'Shibuya, Tokyo',
        latitude: 35.6595,
        longitude: 139.6987,
        type: LocationType.shopping,
        rating: 4.3,
        isOpen: true,
        tags: ['fashion', 'AR', 'trendy'],
      ),

      // Entertainment
      LocationModel(
        id: '5',
        name: 'TeamLab Planets',
        description: 'Digital art museum with immersive installations',
        address: 'Toyosu, Tokyo',
        latitude: 35.6491,
        longitude: 139.7887,
        type: LocationType.entertainment,
        rating: 4.9,
        isOpen: true,
        tags: ['art', 'digital', 'immersive'],
      ),
      LocationModel(
        id: '6',
        name: 'VR Zone Shinjuku',
        description: 'Virtual reality entertainment center',
        address: 'Shinjuku, Tokyo',
        latitude: 35.6938,
        longitude: 139.7034,
        type: LocationType.entertainment,
        rating: 4.6,
        isOpen: false,
        tags: ['VR', 'gaming', 'future'],
      ),

      // Landmarks
      LocationModel(
        id: '7',
        name: 'Tokyo Skytree',
        description: 'Tallest structure in Japan with observation decks',
        address: 'Sumida, Tokyo',
        latitude: 35.7100,
        longitude: 139.8107,
        type: LocationType.landmark,
        rating: 4.7,
        isOpen: true,
        tags: ['view', 'landmark', 'tall'],
      ),
      LocationModel(
        id: '8',
        name: 'Senso-ji Temple',
        description: 'Ancient Buddhist temple in Asakusa',
        address: 'Asakusa, Tokyo',
        latitude: 35.7148,
        longitude: 139.7967,
        type: LocationType.landmark,
        rating: 4.8,
        isOpen: true,
        tags: ['temple', 'traditional', 'historic'],
      ),

      // Tech Hubs
      LocationModel(
        id: '9',
        name: 'Roppongi Hills',
        description: 'Modern urban development with tech offices',
        address: 'Roppongi, Tokyo',
        latitude: 35.6605,
        longitude: 139.7292,
        type: LocationType.tech,
        rating: 4.5,
        isOpen: true,
        tags: ['tech', 'modern', 'business'],
      ),
      LocationModel(
        id: '10',
        name: 'Tokyo Station',
        description: 'Major railway hub with smart city integration',
        address: 'Chiyoda, Tokyo',
        latitude: 35.6812,
        longitude: 139.7671,
        type: LocationType.tech,
        rating: 4.6,
        isOpen: true,
        tags: ['transport', 'smart city', 'central'],
      ),

      // Nightlife
      LocationModel(
        id: '11',
        name: 'Golden Gai',
        description: 'Narrow alleyways with tiny bars',
        address: 'Shinjuku, Tokyo',
        latitude: 35.6939,
        longitude: 139.7047,
        type: LocationType.nightlife,
        rating: 4.7,
        isOpen: false,
        tags: ['bars', 'nightlife', 'traditional'],
      ),
      LocationModel(
        id: '12',
        name: 'Womb',
        description: 'Famous nightclub with state-of-the-art sound',
        address: 'Shibuya, Tokyo',
        latitude: 35.6614,
        longitude: 139.7013,
        type: LocationType.nightlife,
        rating: 4.6,
        isOpen: false,
        tags: ['club', 'music', 'dance'],
      ),
    ];
  }

  static List<FilterModel> getFilters() {
    return [
      FilterModel(id: 'all', name: 'All', isActive: true),
      FilterModel(
        id: 'restaurant',
        name: 'Food',
        type: LocationType.restaurant,
      ),
      FilterModel(id: 'shopping', name: 'Shop', type: LocationType.shopping),
      FilterModel(
        id: 'entertainment',
        name: 'Fun',
        type: LocationType.entertainment,
      ),
      FilterModel(id: 'landmark', name: 'Sights', type: LocationType.landmark),
      FilterModel(id: 'tech', name: 'Tech', type: LocationType.tech),
      FilterModel(id: 'nightlife', name: 'Night', type: LocationType.nightlife),
    ];
  }
}
