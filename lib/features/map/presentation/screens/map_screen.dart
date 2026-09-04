import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../data/models/place.dart';
import '../view_models/map_view_model.dart';
import '../widgets/map_search_bar.dart';
import '../widgets/place_detail_sheet.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController _mapController = MapController();

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _showPlaceDetails(BuildContext context, WidgetRef ref, Place place) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => PlaceDetailSheet(
        place: place,
        onFavoritePressed: () {
          // TODO: Toggle favorite
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final mapState = ref.watch(mapViewModelProvider);

    // Listen for state changes to move the map
    ref.listen(mapViewModelProvider, (previous, next) {
      if (next.center != previous?.center) {
        _mapController.move(next.center, next.zoom);
      }
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.mapSearchError(next.errorMessage!)),
          ),
        );
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: mapState.center,
              initialZoom: mapState.zoom,
              onPositionChanged: (pos, hasGesture) {
                if (hasGesture) {
                  ref
                      .read(mapViewModelProvider.notifier)
                      .updatePosition(pos.center, pos.zoom);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.opentrail',
              ),
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () => launchUrl(
                      Uri.parse('https://openstreetmap.org/copyright'),
                    ),
                  ),
                ],
              ),
              MarkerLayer(
                markers: mapState.markers.map((place) {
                  return Marker(
                    point: place.location,
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () {
                        ref
                            .read(mapViewModelProvider.notifier)
                            .selectPlace(place);
                        _showPlaceDetails(context, ref, place);
                      },
                      child: Icon(
                        Icons.location_on_rounded,
                        size: 40,
                        color: mapState.selectedPlace == place
                            ? theme.colorScheme.primary
                            : theme.colorScheme.secondary,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // Overlay Search Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: MapSearchBar(
                isLoading: mapState.isSearching,
                onSearch: (query) =>
                    ref.read(mapViewModelProvider.notifier).search(query),
                onClear: () =>
                    ref.read(mapViewModelProvider.notifier).clearMarkers(),
              ),
            ),
          ),

          // Current Location FAB
          Positioned(
            bottom: AppSpacing.xl + 80, // Above nav bar
            right: AppSpacing.md,
            child: FloatingActionButton(
              mini: true,
              onPressed: () {
                // TODO: GPS Integration
              },
              child: const Icon(Icons.my_location_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
