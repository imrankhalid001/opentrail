import 'package:flutter/foundation.dart';

@immutable
class WeatherForecast {
  final CurrentWeather current;
  final HourlyForecast hourly;
  final DailyForecast daily;
  final double latitude;
  final double longitude;
  final String timezone;

  const WeatherForecast({
    required this.current,
    required this.hourly,
    required this.daily,
    required this.latitude,
    required this.longitude,
    required this.timezone,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      current: CurrentWeather.fromJson(
        json['current_weather'] as Map<String, dynamic>,
      ),
      hourly: HourlyForecast.fromJson(json['hourly'] as Map<String, dynamic>),
      daily: DailyForecast.fromJson(json['daily'] as Map<String, dynamic>),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timezone: json['timezone'] as String,
    );
  }
}

@immutable
class CurrentWeather {
  final double temperature;
  final double windSpeed;
  final int weatherCode;
  final String time;

  const CurrentWeather({
    required this.temperature,
    required this.windSpeed,
    required this.weatherCode,
    required this.time,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: (json['temperature'] as num).toDouble(),
      windSpeed: (json['windspeed'] as num).toDouble(),
      weatherCode: json['weathercode'] as int,
      time: json['time'] as String,
    );
  }
}

@immutable
class HourlyForecast {
  final List<String> time;
  final List<double> temperature2m;
  final List<int> precipitationProbability;
  final List<int> weatherCode;
  final List<int> isDay;
  final List<int> relativeHumidity2m;

  const HourlyForecast({
    required this.time,
    required this.temperature2m,
    required this.precipitationProbability,
    required this.weatherCode,
    required this.isDay,
    required this.relativeHumidity2m,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time: List<String>.from(json['time'] as List),
      temperature2m: (json['temperature_2m'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      precipitationProbability: List<int>.from(
        json['precipitation_probability'] as List,
      ),
      weatherCode: List<int>.from(json['weathercode'] as List),
      isDay: List<int>.from(json['is_day'] as List),
      relativeHumidity2m: List<int>.from(json['relative_humidity_2m'] as List),
    );
  }
}

@immutable
class DailyForecast {
  final List<String> time;
  final List<int> weatherCode;
  final List<double> temperature2mMax;
  final List<double> temperature2mMin;
  final List<double> uvIndexMax;

  const DailyForecast({
    required this.time,
    required this.weatherCode,
    required this.temperature2mMax,
    required this.temperature2mMin,
    required this.uvIndexMax,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      time: List<String>.from(json['time'] as List),
      weatherCode: List<int>.from(json['weathercode'] as List),
      temperature2mMax: (json['temperature_2m_max'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      temperature2mMin: (json['temperature_2m_min'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      uvIndexMax: (json['uv_index_max'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
    );
  }
}
