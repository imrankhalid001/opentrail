import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import 'animated_weather_icon.dart';

class HourlyForecastChart extends StatelessWidget {
  final List<String> times;
  final List<double> temperatures;
  final List<int> precipProbs;
  final List<int> weatherCodes;
  final List<int> isDays;
  final List<int> humidities;

  const HourlyForecastChart({
    super.key,
    required this.times,
    required this.temperatures,
    required this.precipProbs,
    required this.weatherCodes,
    required this.isDays,
    required this.humidities,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Filter for 2-hour gaps
    final List<int> filteredIndices = [];
    for (int i = 0; i < times.length && i < 24; i += 2) {
      filteredIndices.add(i);
    }

    return SizedBox(
      height: 175, // Increased further to fit everything comfortably
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        itemCount: filteredIndices.length,
        separatorBuilder: (ctx, idx) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final actualIndex = filteredIndices[index];
          final time = DateTime.parse(times[actualIndex]);

          String timeLabel;
          if (time.hour == 0) {
            timeLabel = DateFormat('dd/MM').format(time);
          } else {
            timeLabel = DateFormat('HH:mm').format(time);
          }

          final temp = temperatures[actualIndex].round();
          final precip = precipProbs[actualIndex];
          final humidity = humidities[actualIndex];
          final wCode = weatherCodes[actualIndex];
          final isDay = isDays[actualIndex] == 1;

          return AppCard(
            padding: const EdgeInsets.all(AppSpacing.sm),
            margin: EdgeInsets.zero,
            child: SizedBox(
              width: 75, // Slightly wider for icon
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    timeLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: time.hour == 0 ? FontWeight.bold : null,
                      color: time.hour == 0 ? theme.colorScheme.primary : null,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  AnimatedWeatherIcon(
                    weatherCode: wCode,
                    isDay: isDay,
                    size: 28,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '$temp°',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  if (precip > 0)
                    _MetricRow(
                      icon: Icons.water_drop_rounded,
                      value: '$precip%',
                      color: theme.colorScheme.tertiary,
                    )
                  else
                    _MetricRow(
                      icon: Icons.opacity_rounded,
                      value: '$humidity%',
                      color: theme.colorScheme.outline,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;

  const _MetricRow({
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 10, color: color),
        const SizedBox(width: 2),
        Text(value, style: theme.textTheme.labelSmall?.copyWith(color: color)),
      ],
    );
  }
}
