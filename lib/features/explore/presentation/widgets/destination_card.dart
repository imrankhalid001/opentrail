import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_favorite_button.dart';
import '../../data/models/destination.dart';

class DestinationCard extends StatelessWidget {
  final Destination destination;
  final VoidCallback onTap;
  final ValueChanged<bool>? onFavoriteToggle;

  const DestinationCard({
    super.key,
    required this.destination,
    required this.onTap,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Container with Gradient & Badges
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12.0),
                ),
                child: Container(
                  height: 110,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primaryContainer,
                        theme.colorScheme.tertiaryContainer,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: destination.imageUrl != null &&
                          destination.imageUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: destination.imageUrl!,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) {
                            return Center(
                              child: Text(
                                destination.flagEmoji,
                                style: const TextStyle(fontSize: 48),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            destination.flagEmoji,
                            style: const TextStyle(fontSize: 48),
                          ),
                        ),
                ),
              ),
              // Gradient Overlay for Title Legibility
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.1),
                          Colors.black.withValues(alpha: 0.4),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ),
              // Top-Left Flag Pill Badge
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    destination.flagEmoji,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              // Top-Right Favorite Toggle
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  backgroundColor: theme.colorScheme.surface.withValues(
                    alpha: 0.85,
                  ),
                  radius: 18,
                  child: AppFavoriteButton(
                    isFavorite: destination.isFavorite,
                    onToggle: (val) => onFavoriteToggle?.call(val),
                    size: 20,
                  ),
                ),
              ),
              // Bottom-Left Region Badge
              Positioned(
                bottom: 8,
                left: 8,
                child: AppBadge(
                  label: destination.region,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  textColor: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),

          // Content Details Body
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    destination.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_city,
                        size: 14,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          destination.capital,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 14,
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${(destination.population / 1000000).toStringAsFixed(1)}M residents',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
