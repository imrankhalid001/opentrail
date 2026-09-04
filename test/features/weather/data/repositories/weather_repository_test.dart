import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_projects/features/weather/data/models/weather_forecast.dart';
import 'package:flutter_projects/features/weather/data/repositories/weather_repository.dart';
import 'package:flutter_projects/features/weather/data/services/open_meteo_service.dart';

class MockOpenMeteoService implements OpenMeteoService {
  final WeatherForecast? mockForecast;
  final Exception? error;

  MockOpenMeteoService({this.mockForecast, this.error});

  @override
  Future<WeatherForecast> fetchForecast(
    double latitude,
    double longitude,
  ) async {
    if (error != null) throw error!;
    return mockForecast!;
  }
}

void main() {
  const sampleForecast = WeatherForecast(
    latitude: 35.6,
    longitude: 139.7,
    timezone: 'Asia/Tokyo',
    current: CurrentWeather(
      temperature: 25.0,
      windSpeed: 10.0,
      weatherCode: 0,
      time: '2024-01-01T12:00',
    ),
    hourly: HourlyForecast(
      time: ['2024-01-01T12:00'],
      temperature2m: [25.0],
      precipitationProbability: [0],
      weatherCode: [0],
      isDay: [1],
      relativeHumidity2m: [50],
    ),
    daily: DailyForecast(
      time: ['2024-01-01'],
      weatherCode: [0],
      temperature2mMax: [28.0],
      temperature2mMin: [20.0],
      uvIndexMax: [5.0],
    ),
  );

  test('getWeatherForecast returns success when service succeeds', () async {
    final repository = WeatherRepositoryImpl(
      service: MockOpenMeteoService(mockForecast: sampleForecast),
    );

    final result = await repository.getWeatherForecast(35.6, 139.7);

    expect(result.isSuccess, true);
    result.fold(
      onSuccess: (forecast) => expect(forecast.latitude, 35.6),
      onFailure: (_) => fail('Should succeed'),
    );
  });
}
