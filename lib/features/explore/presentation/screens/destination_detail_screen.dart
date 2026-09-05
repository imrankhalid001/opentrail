import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_favorite_button.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../view_models/destination_detail_view_model.dart';

class DestinationDetailScreen extends ConsumerWidget {
  final String destinationId;

  const DestinationDetailScreen({super.key, required this.destinationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final detailState = ref.watch(
      destinationDetailViewModelProvider(destinationId),
    );

    return Scaffold(
      body: detailState.when(
        data: (destination) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: CircleAvatar(
                      backgroundColor: theme.colorScheme.surface.withValues(
                        alpha: 0.8,
                      ),
                      child: AppFavoriteButton(
                        isFavorite: destination.isFavorite,
                        onToggle: (_) {
                          ref
                              .read(
                                destinationDetailViewModelProvider(
                                  destinationId,
                                ).notifier,
                              )
                              .toggleFavorite();
                        },
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    '${destination.flagEmoji} ${destination.name}',
                    style: const TextStyle(
                      shadows: [Shadow(blurRadius: 8.0, color: Colors.black54)],
                    ),
                  ),
                  background: destination.imageUrl != null &&
                          destination.imageUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: destination.imageUrl!,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Container(
                            color: theme.colorScheme.primaryContainer,
                            child: Center(
                              child: Text(
                                destination.flagEmoji,
                                style: const TextStyle(fontSize: 80),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          color: theme.colorScheme.primaryContainer,
                          child: Center(
                            child: Text(
                              destination.flagEmoji,
                              style: const TextStyle(fontSize: 80),
                            ),
                          ),
                        ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AppBadge(
                            label: destination.region,
                            backgroundColor: theme.colorScheme.primaryContainer,
                            textColor: theme.colorScheme.onPrimaryContainer,
                          ),
                          const SizedBox(width: 8),
                          AppBadge(
                            label: destination.subregion,
                            backgroundColor:
                                theme.colorScheme.secondaryContainer,
                            textColor: theme.colorScheme.onSecondaryContainer,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Destination Overview',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        destination.summary,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Key Statistics & Details',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: AppCard(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.location_city,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Capital',
                                    style: theme.textTheme.labelSmall,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    destination.capital,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppCard(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.people,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Population',
                                    style: theme.textTheme.labelSmall,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${(destination.population / 1000000).toStringAsFixed(1)}M',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.language,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Official Languages',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(destination.languages.join(', ')),
                            const Divider(height: 24),
                            Row(
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Currencies',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(destination.currencies.join(', ')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Scaffold(
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: AppSkeleton(height: 400),
          ),
        ),
        error: (error, _) => Scaffold(
          appBar: AppBar(),
          body: Center(
            child: AppErrorState(
              message: error.toString(),
              onRetry: () {
                ref
                    .read(
                      destinationDetailViewModelProvider(destinationId)
                          .notifier,
                    )
                    .refresh();
              },
            ),
          ),
        ),
      ),
    );
  }
}
