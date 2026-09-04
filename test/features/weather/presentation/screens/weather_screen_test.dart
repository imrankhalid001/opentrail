import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_projects/core/errors/app_exception.dart';
import 'package:flutter_projects/core/result/result.dart';
import 'package:flutter_projects/features/weather/data/models/weather_forecast.dart';
import 'package:flutter_projects/features/weather/data/repositories/weather_repository.dart';
import 'package:flutter_projects/features/weather/presentation/screens/weather_screen.dart';
import 'package:flutter_projects/l10n/app_localizations.dart';

class MockWeatherRepository implements WeatherRepository {
  final WeatherForecast mockForecast;

  MockWeatherRepository(this.mockForecast);

  @override
  Future<Result<WeatherForecast, AppException>> getWeatherForecast(
    double latitude,
    double longitude,
  ) async {
    return Success(mockForecast);
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

  testWidgets('WeatherScreen renders forecast data', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          weatherRepositoryProvider.overrideWithValue(
            MockWeatherRepository(sampleForecast),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: WeatherScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Weather Intelligence'), findsOneWidget);
    expect(find.text('25°'), findsWidgets);
    expect(find.text('7-Day Forecast'), findsOneWidget);
    expect(find.text('Tokyo, JP'), findsOneWidget);
  });
}
