import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/result/result.dart';
import '../../../explore/data/repositories/explore_repository.dart';
import '../models/weather_forecast.dart';
import '../services/open_meteo_service.dart';

final weatherServiceProvider = Provider<OpenMeteoService>((ref) {
  final dio = ref.watch(dioProvider);
  return OpenMeteoServiceImpl(dio: dio);
});

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  final service = ref.watch(weatherServiceProvider);
  return WeatherRepositoryImpl(service: service);
});

abstract class WeatherRepository {
  Future<Result<WeatherForecast, AppException>> getWeatherForecast(
    double latitude,
    double longitude,
  );
}

class WeatherRepositoryImpl implements WeatherRepository {
  final OpenMeteoService service;

  WeatherRepositoryImpl({required this.service});

  @override
  Future<Result<WeatherForecast, AppException>> getWeatherForecast(
    double latitude,
    double longitude,
  ) async {
    try {
      final forecast = await service.fetchForecast(latitude, longitude);
      return Success(forecast);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
        UnknownException(message: 'Failed to fetch weather: $e', cause: e),
      );
    }
  }
}
