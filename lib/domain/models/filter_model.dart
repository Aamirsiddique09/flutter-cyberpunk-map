import 'location_model.dart';

class FilterModel {
  final String id;
  final String name;
  final LocationType? type;
  bool isActive;

  FilterModel({
    required this.id,
    required this.name,
    this.type,
    this.isActive = false,
  });
}
