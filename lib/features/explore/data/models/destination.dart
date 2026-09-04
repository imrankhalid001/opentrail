import 'package:flutter/foundation.dart';

@immutable
class Destination {
  final String id;
  final String name;
  final String country;
  final String countryCode;
  final String flagEmoji;
  final String capital;
  final String region;
  final String subregion;
  final int population;
  final double latitude;
  final double longitude;
  final List<String> languages;
  final List<String> currencies;
  final String summary;
  final String? imageUrl;
  final bool isFavorite;

  const Destination({
    required this.id,
    required this.name,
    required this.country,
    required this.countryCode,
    required this.flagEmoji,
    required this.capital,
    required this.region,
    required this.subregion,
    required this.population,
    required this.latitude,
    required this.longitude,
    required this.languages,
    required this.currencies,
    required this.summary,
    this.imageUrl,
    this.isFavorite = false,
  });

  Destination copyWith({
    String? id,
    String? name,
    String? country,
    String? countryCode,
    String? flagEmoji,
    String? capital,
    String? region,
    String? subregion,
    int? population,
    double? latitude,
    double? longitude,
    List<String>? languages,
    List<String>? currencies,
    String? summary,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return Destination(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      countryCode: countryCode ?? this.countryCode,
      flagEmoji: flagEmoji ?? this.flagEmoji,
      capital: capital ?? this.capital,
      region: region ?? this.region,
      subregion: subregion ?? this.subregion,
      population: population ?? this.population,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      languages: languages ?? this.languages,
      currencies: currencies ?? this.currencies,
      summary: summary ?? this.summary,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  static Map<String, dynamic> _toMap(dynamic val) {
    if (val is Map<String, dynamic>) return val;
    if (val is Map) {
      return val.map((k, v) => MapEntry(k.toString(), v));
    }
    return {};
  }

  factory Destination.fromRestCountriesJson(Map<String, dynamic> json) {
    final nameMap = _toMap(json['name']);
    final commonName = nameMap['common'] as String? ?? 'Unknown Destination';
    final cca2 = json['cca2'] as String? ?? 'XX';
    final flag = json['flag'] as String? ?? '🗺️';

    final capitals = json['capital'] as List<dynamic>?;
    final capitalName = capitals != null && capitals.isNotEmpty
        ? capitals.first.toString()
        : 'N/A';

    final reg = json['region'] as String? ?? 'Global';
    final subreg = json['subregion'] as String? ?? 'Global';
    final pop = json['population'] as int? ?? 0;

    final latlng = json['latlng'] as List<dynamic>?;
    final lat = (latlng != null && latlng.length >= 2)
        ? (latlng[0] as num).toDouble()
        : 0.0;
    final lng = (latlng != null && latlng.length >= 2)
        ? (latlng[1] as num).toDouble()
        : 0.0;

    final langMap = _toMap(json['languages']);
    final langList = langMap.isNotEmpty
        ? langMap.values.map((e) => e.toString()).toList()
        : <String>['English'];

    final currMap = _toMap(json['currencies']);
    final currList = <String>[];
    if (currMap.isNotEmpty) {
      for (final entry in currMap.entries) {
        final cVal = _toMap(entry.value);
        if (cVal.containsKey('name')) {
          currList.add('${cVal['name']} (${entry.key})');
        } else {
          currList.add(entry.key);
        }
      }
    }
    if (currList.isEmpty) currList.add('Local Currency');

    final flagsMap = _toMap(json['flags']);
    final img = flagsMap['png'] as String? ?? flagsMap['svg'] as String?;

    return Destination(
      id: cca2.toLowerCase(),
      name: commonName,
      country: commonName,
      countryCode: cca2,
      flagEmoji: flag,
      capital: capitalName,
      region: reg,
      subregion: subreg,
      population: pop,
      latitude: lat,
      longitude: lng,
      languages: langList,
      currencies: currList,
      summary:
          '$commonName is located in $subreg ($reg) with capital $capitalName and a population of ${pop.toString()}.',
      imageUrl: img,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Destination &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          countryCode == other.countryCode &&
          isFavorite == other.isFavorite;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ countryCode.hashCode ^ isFavorite.hashCode;
}
