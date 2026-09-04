import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/result/result.dart';
import '../../../explore/data/repositories/explore_repository.dart';
import '../models/place.dart';
import '../services/nominatim_service.dart';

final nominatimServiceProvider = Provider<NominatimService>((ref) {
  final dio = ref.watch(dioProvider);
  return NominatimServiceImpl(dio: dio);
});

final mapRepositoryProvider = Provider<MapRepository>((ref) {
  final service = ref.watch(nominatimServiceProvider);
  return MapRepositoryImpl(service: service);
});

abstract class MapRepository {
  Future<Result<List<Place>, AppException>> searchPOIs(
    String query, {
    double? nearLat,
    double? nearLon,
  });
}

class MapRepositoryImpl implements MapRepository {
  final NominatimService service;

  MapRepositoryImpl({required this.service});

  @override
  Future<Result<List<Place>, AppException>> searchPOIs(
    String query, {
    double? nearLat,
    double? nearLon,
  }) async {
    try {
      final results = await service.searchPlaces(
        query,
        lat: nearLat,
        lon: nearLon,
      );
      return Success(results);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
        UnknownException(message: 'Failed to find places: $e', cause: e),
      );
    }
  }
}
