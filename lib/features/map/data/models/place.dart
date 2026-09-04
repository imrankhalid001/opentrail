import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

@immutable
class Place {
  final String id;
  final String name;
  final String type;
  final String category;
  final LatLng location;
  final String displayName;
  final Map<String, dynamic> rawAddress;

  const Place({
    required this.id,
    required this.name,
    required this.type,
    required this.category,
    required this.location,
    required this.displayName,
    this.rawAddress = const {},
  });

  factory Place.fromNominatimJson(Map<String, dynamic> json) {
    return Place(
      id: json['place_id']?.toString() ?? json['osm_id']?.toString() ?? '',
      name:
          (json['name'] as String?) ??
          (json['display_name'] as String?)?.split(',').first ??
          'Unknown Place',
      type: (json['type'] as String?) ?? 'point',
      category:
          (json['category'] as String?) ?? (json['class'] as String?) ?? 'misc',
      location: LatLng(
        double.parse(json['lat'].toString()),
        double.parse(json['lon'].toString()),
      ),
      displayName: (json['display_name'] as String?) ?? '',
      rawAddress: json['address'] as Map<String, dynamic>? ?? {},
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Place &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          location == other.location;

  @override
  int get hashCode => id.hashCode ^ location.hashCode;
}
