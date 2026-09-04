import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../data/models/place.dart';
import '../../data/repositories/map_repository.dart';

@immutable
class MapState {
  final LatLng center;
  final double zoom;
  final List<Place> markers;
  final Place? selectedPlace;
  final bool isSearching;
  final String? errorMessage;

  const MapState({
    required this.center,
    required this.zoom,
    this.markers = const [],
    this.selectedPlace,
    this.isSearching = false,
    this.errorMessage,
  });

  MapState copyWith({
    LatLng? center,
    double? zoom,
    List<Place>? markers,
    Place? selectedPlace,
    bool? isSearching,
    String? errorMessage,
    bool clearSelectedPlace = false,
    bool clearError = false,
  }) {
    return MapState(
      center: center ?? this.center,
      zoom: zoom ?? this.zoom,
      markers: markers ?? this.markers,
      selectedPlace: clearSelectedPlace
          ? null
          : (selectedPlace ?? this.selectedPlace),
      isSearching: isSearching ?? this.isSearching,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class MapNotifier extends Notifier<MapState> {
  @override
  MapState build() {
    return const MapState(
      center: LatLng(35.6762, 139.6503), // Default Tokyo
      zoom: 13.0,
    );
  }

  void updatePosition(LatLng center, double zoom) {
    state = state.copyWith(center: center, zoom: zoom);
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;

    state = state.copyWith(isSearching: true, clearError: true);

    final repo = ref.read(mapRepositoryProvider);
    final result = await repo.searchPOIs(
      query,
      nearLat: state.center.latitude,
      nearLon: state.center.longitude,
    );

    result.fold(
      onSuccess: (places) {
        state = state.copyWith(
          isSearching: false,
          markers: places,
          center: places.isNotEmpty ? places.first.location : null,
          zoom: places.isNotEmpty ? 14.0 : null,
        );
      },
      onFailure: (err) {
        state = state.copyWith(isSearching: false, errorMessage: err.message);
      },
    );
  }

  void selectPlace(Place? place) {
    state = state.copyWith(
      selectedPlace: place,
      clearSelectedPlace: place == null,
      center: place?.location,
      zoom: place != null ? 15.0 : null,
    );
  }

  void clearMarkers() {
    state = state.copyWith(markers: [], clearSelectedPlace: true);
  }
}

final mapViewModelProvider = NotifierProvider<MapNotifier, MapState>(
  MapNotifier.new,
);
