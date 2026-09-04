import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/weather_forecast.dart';
import '../../data/repositories/weather_repository.dart';

class WeatherLocation {
  final double lat;
  final double lon;
  final String name;

  const WeatherLocation({
    required this.lat,
    required this.lon,
    required this.name,
  });
}

final weatherLocationProvider = StateProvider<WeatherLocation>((ref) {
  return const WeatherLocation(lat: 35.6762, lon: 139.6503, name: 'Tokyo, JP');
});

final weatherViewModelProvider =
    AsyncNotifierProvider<WeatherViewModel, WeatherForecast>(() {
      return WeatherViewModel();
    });

class WeatherViewModel extends AsyncNotifier<WeatherForecast> {
  @override
  Future<WeatherForecast> build() async {
    final location = ref.watch(weatherLocationProvider);
    return _fetchWeather(location.lat, location.lon);
  }

  Future<WeatherForecast> _fetchWeather(double lat, double lon) async {
    final repository = ref.read(weatherRepositoryProvider);
    final result = await repository.getWeatherForecast(lat, lon);

    return result.fold(
      onSuccess: (forecast) => forecast,
      onFailure: (exception) => throw exception,
    );
  }

  void setLocation(WeatherLocation location) {
    ref.read(weatherLocationProvider.notifier).state = location;
  }

  Future<void> refresh() async {
    final location = ref.read(weatherLocationProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _fetchWeather(location.lat, location.lon),
    );
  }
}
