import 'package:dio/dio.dart';

import '../../../../core/errors/app_exception.dart';
import '../models/weather_forecast.dart';

abstract class OpenMeteoService {
  Future<WeatherForecast> fetchForecast(double latitude, double longitude);
}

class OpenMeteoServiceImpl implements OpenMeteoService {
  final Dio dio;

  OpenMeteoServiceImpl({required this.dio});

  @override
  Future<WeatherForecast> fetchForecast(
    double latitude,
    double longitude,
  ) async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        'https://api.open-meteo.com/v1/forecast',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'current_weather': true,
          'hourly': 'temperature_2m,precipitation_probability,weathercode,is_day,relative_humidity_2m',
          'daily':
              'weathercode,temperature_2m_max,temperature_2m_min,uv_index_max',
          'timezone': 'auto',
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return WeatherForecast.fromJson(response.data!);
      }

      throw NetworkException(
        message: 'Failed to load weather: HTTP ${response.statusCode}',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw NetworkException(
        message: 'Network error loading weather: ${e.message}',
        cause: e,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnknownException(
        message: 'Unexpected error loading weather: $e',
        cause: e,
      );
    }
  }
}
