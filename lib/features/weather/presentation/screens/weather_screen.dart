import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_search_bar.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../explore/data/repositories/explore_repository.dart';
import '../view_models/weather_view_model.dart';
import '../widgets/daily_forecast_card.dart';
import '../widgets/hourly_forecast_chart.dart';
import '../widgets/weather_animations.dart';
import '../widgets/weather_icon_mapper.dart';

class WeatherScreen extends ConsumerStatefulWidget {
  const WeatherScreen({super.key});

  @override
  ConsumerState<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen> {
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final weatherState = ref.watch(weatherViewModelProvider);
    final currentLocation = ref.watch(weatherLocationProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.weatherTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () =>
                ref.read(weatherViewModelProvider.notifier).refresh(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: AppSearchBar(
              hint: context.l10n.weatherSearchHint,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                  _isSearching = val.isNotEmpty;
                });
              },
              onClear: () {
                setState(() {
                  _searchQuery = '';
                  _isSearching = false;
                });
              },
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                weatherState.when(
                  data: (weather) {
                    return Stack(
                      children: [
                        // Dynamic Background Layer
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: _getBackgroundColors(
                                  weather.current.weatherCode,
                                  theme,
                                ),
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),

                        // Animation Layer
                        Positioned.fill(
                          child: RepaintBoundary(
                            child: WeatherBackgroundEffect(
                              weatherCode: weather.current.weatherCode,
                            ),
                          ),
                        ),

                        // Content Layer
                        RefreshIndicator(
                          onRefresh: () => ref
                              .read(weatherViewModelProvider.notifier)
                              .refresh(),
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: AppSpacing.md),
                                // Current Weather Section
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md,
                                  ),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text(
                                          currentLocation.name,
                                          style: theme.textTheme.headlineSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(height: AppSpacing.sm),
                                        Icon(
                                          WeatherIconMapper.getIcon(
                                            weather.current.weatherCode,
                                          ),
                                          size: 80,
                                          color: theme.colorScheme.primary,
                                        ),
                                        const SizedBox(height: AppSpacing.sm),
                                        Text(
                                          '${weather.current.temperature.round()}°',
                                          style: theme.textTheme.displayLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    theme.colorScheme.onSurface,
                                              ),
                                        ),
                                        Text(
                                          WeatherIconMapper.getDescription(
                                            weather.current.weatherCode,
                                          ),
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                color: theme
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                        ),
                                        const SizedBox(height: AppSpacing.md),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            _WeatherStat(
                                              icon: Icons.air_rounded,
                                              label: context.l10n.weatherWind,
                                              value:
                                                  '${weather.current.windSpeed} km/h',
                                            ),
                                            const SizedBox(
                                              width: AppSpacing.xl,
                                            ),
                                            _WeatherStat(
                                              icon: Icons.wb_sunny_outlined,
                                              label:
                                                  context.l10n.weatherUVIndex,
                                              value: weather
                                                  .daily
                                                  .uvIndexMax
                                                  .first
                                                  .toString(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                AppSectionHeader(
                                  title: context.l10n.weatherHourlyForecast,
                                ),
                                HourlyForecastChart(
                                  times: weather.hourly.time,
                                  temperatures: weather.hourly.temperature2m,
                                  precipProbs:
                                      weather.hourly.precipitationProbability,
                                  weatherCodes: weather.hourly.weatherCode,
                                  isDays: weather.hourly.isDay,
                                  humidities: weather.hourly.relativeHumidity2m,
                                ),

                                const SizedBox(height: AppSpacing.md),
                                AppSectionHeader(
                                  title: context.l10n.weatherDailyForecast,
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md,
                                  ),
                                  itemCount: weather.daily.time.length,
                                  itemBuilder: (context, index) {
                                    return DailyForecastCard(
                                      date: weather.daily.time[index],
                                      weatherCode:
                                          weather.daily.weatherCode[index],
                                      tempMax:
                                          weather.daily.temperature2mMax[index],
                                      tempMin:
                                          weather.daily.temperature2mMin[index],
                                    );
                                  },
                                ),
                                const SizedBox(height: AppSpacing.xl),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const _WeatherLoadingSkeleton(),
                  error: (error, _) => Center(
                    child: AppErrorState(
                      message: error.toString(),
                      onRetry: () =>
                          ref.read(weatherViewModelProvider.notifier).refresh(),
                    ),
                  ),
                ),
                if (_isSearching)
                  _WeatherSearchOverlay(
                    query: _searchQuery,
                    onSelect: (location) {
                      ref
                          .read(weatherViewModelProvider.notifier)
                          .setLocation(location);
                      setState(() {
                        _isSearching = false;
                        _searchQuery = '';
                      });
                      FocusScope.of(context).unfocus();
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getBackgroundColors(int code, ThemeData theme) {
    if (code == 0) {
      return [
        theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        theme.colorScheme.surface,
      ];
    } else if (code >= 1 && code <= 3) {
      return [
        Colors.blueGrey.withValues(alpha: 0.1),
        theme.colorScheme.surface,
      ];
    } else if (code >= 51 && code <= 67) {
      return [
        Colors.indigoAccent.withValues(alpha: 0.1),
        theme.colorScheme.surface,
      ];
    }
    return [theme.colorScheme.surface, theme.colorScheme.surface];
  }
}

class _WeatherSearchOverlay extends ConsumerWidget {
  final String query;
  final void Function(WeatherLocation) onSelect;

  const _WeatherSearchOverlay({required this.query, required this.onSelect});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final exploreRepo = ref.watch(exploreRepositoryProvider);

    return Container(
      color: theme.colorScheme.surface,
      margin: const EdgeInsets.only(top: 8), // Gap below search area
      child: FutureBuilder(
        future: exploreRepo.getDestinations(query: query),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final result = snapshot.data!;
          return result.fold(
            onSuccess: (destinations) {
              if (destinations.isEmpty) {
                return Center(child: Text(context.l10n.weatherNoResults));
              }
              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: destinations.length,
                itemBuilder: (context, index) {
                  final dest = destinations[index];
                  return ListTile(
                    leading: Text(
                      dest.flagEmoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(dest.name),
                    subtitle: Text(dest.capital),
                    onTap: () {
                      onSelect(
                        WeatherLocation(
                          lat: dest.latitude,
                          lon: dest.longitude,
                          name: '${dest.name}, ${dest.countryCode}',
                        ),
                      );
                    },
                  );
                },
              );
            },
            onFailure: (err) => Center(
              child: Text(context.l10n.weatherSearchError(err.message)),
            ),
          );
        },
      ),
    );
  }
}

class _WeatherStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _WeatherStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.secondary),
        const SizedBox(height: 4),
        Text(label, style: theme.textTheme.labelSmall),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _WeatherLoadingSkeleton extends StatelessWidget {
  const _WeatherLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          const Center(child: AppSkeleton(height: 200, width: 200)),
          const SizedBox(height: AppSpacing.xl),
          const AppSkeleton(height: 140),
          const SizedBox(height: AppSpacing.xl),
          ...List.generate(
            5,
            (_) => const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.sm),
              child: AppSkeleton(height: 80),
            ),
          ),
        ],
      ),
    );
  }
}
