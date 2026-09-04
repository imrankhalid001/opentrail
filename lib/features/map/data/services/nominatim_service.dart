import 'package:dio/dio.dart';

import '../../../../core/errors/app_exception.dart';
import '../models/place.dart';

abstract class NominatimService {
  Future<List<Place>> searchPlaces(String query, {double? lat, double? lon});
}

class NominatimServiceImpl implements NominatimService {
  final Dio dio;

  NominatimServiceImpl({required this.dio});

  @override
  Future<List<Place>> searchPlaces(
    String query, {
    double? lat,
    double? lon,
  }) async {
    try {
      final queryParams = {
        'q': query,
        'format': 'jsonv2',
        'addressdetails': 1,
        'limit': 10,
      };

      if (lat != null && lon != null) {
        // Boost results near specific location
        queryParams['lat'] = lat.toString();
        queryParams['lon'] = lon.toString();
      }

      final response = await dio.get<dynamic>(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: queryParams,
        options: Options(
          headers: {
            'User-Agent':
                'OpenTrail/1.0.0 (https://github.com/imrankhalid001/opentrail)',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data is List) {
          return data
              .map(
                (item) => Place.fromNominatimJson(item as Map<String, dynamic>),
              )
              .toList();
        }
      }

      throw NetworkException(
        message: 'Failed to search places: HTTP ${response.statusCode}',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        throw const NetworkException(
          message: 'Rate limit exceeded. Please wait a moment.',
        );
      }
      throw NetworkException(
        message: 'Network error searching places: ${e.message}',
        cause: e,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnknownException(
        message: 'Unexpected error searching places: $e',
        cause: e,
      );
    }
  }
}
