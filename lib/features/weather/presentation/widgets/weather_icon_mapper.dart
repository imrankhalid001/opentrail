import 'package:flutter/material.dart';

class WeatherIconMapper {
  static IconData getIcon(int code) {
    switch (code) {
      case 0:
        return Icons.wb_sunny_rounded; // Clear sky
      case 1:
      case 2:
      case 3:
        return Icons
            .wb_cloudy_rounded; // Mainly clear, partly cloudy, and overcast
      case 45:
      case 48:
        return Icons.foggy; // Fog and depositing rime fog
      case 51:
      case 53:
      case 55:
        return Icons
            .grain_rounded; // Drizzle: Light, moderate, and dense intensity
      case 56:
      case 57:
        return Icons
            .ac_unit_rounded; // Freezing Drizzle: Light and dense intensity
      case 61:
      case 63:
      case 65:
        return Icons
            .umbrella_rounded; // Rain: Slight, moderate and heavy intensity
      case 66:
      case 67:
        return Icons
            .ac_unit_rounded; // Freezing Rain: Light and heavy intensity
      case 71:
      case 73:
      case 75:
        return Icons.ac_unit_rounded; // Snow fall: Slight, moderate, and heavy intensity
      case 77:
        return Icons.ac_unit_rounded; // Snow grains
      case 80:
      case 81:
      case 82:
        return Icons.beach_access_rounded; // Rain showers: Slight, moderate, and violent
      case 85:
      case 86:
        return Icons.ac_unit_rounded; // Snow showers slight and heavy
      case 95:
        return Icons.thunderstorm_rounded; // Thunderstorm: Slight or moderate
      case 96:
      case 99:
        return Icons
            .thunderstorm_rounded; // Thunderstorm with slight and heavy hail
      default:
        return Icons.help_outline_rounded;
    }
  }

  static String getDescription(int code) {
    switch (code) {
      case 0:
        return 'Clear sky';
      case 1:
        return 'Mainly clear';
      case 2:
        return 'Partly cloudy';
      case 3:
        return 'Overcast';
      case 45:
        return 'Fog';
      case 48:
        return 'Depositing rime fog';
      case 51:
        return 'Light drizzle';
      case 53:
        return 'Moderate drizzle';
      case 55:
        return 'Dense drizzle';
      case 61:
        return 'Slight rain';
      case 63:
        return 'Moderate rain';
      case 65:
        return 'Heavy rain';
      case 95:
        return 'Thunderstorm';
      default:
        return 'Unknown';
    }
  }
}
