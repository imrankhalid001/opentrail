import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../view_models/journey_view_model.dart';

class JourneyScreen extends ConsumerWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(journeyViewModelProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Travel Journey')),
      body: state.when(
        data: (journey) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStats(theme, journey),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Achievements',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildAchievements(theme, journey),
            ],
          ),
        ),
        loading: () => const _LoadingSkeleton(),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildStats(ThemeData theme, JourneyState journey) {
    return Row(
      children: [
        Expanded(
          child: AppCard(
            child: Column(
              children: [
                Text(
                  journey.visitedCountriesCount.toString(),
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Countries', style: theme.textTheme.labelMedium),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: AppCard(
            child: Column(
              children: [
                Text(
                  journey.trips.length.toString(),
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Total Trips', style: theme.textTheme.labelMedium),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAchievements(ThemeData theme, JourneyState journey) {
    if (journey.achievements.isEmpty) {
      return const Center(
        child: Text('Start traveling to unlock achievements!'),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 1,
      ),
      itemCount: journey.achievements.length,
      itemBuilder: (context, index) {
        final ach = journey.achievements[index];
        final isUnlocked = ach.isUnlocked;

        return AppCard(
          child: Opacity(
            opacity: isUnlocked ? 1.0 : 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isUnlocked ? Icons.stars_rounded : Icons.lock_outline_rounded,
                  size: 48,
                  color: isUnlocked ? Colors.amber : theme.colorScheme.outline,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  ach.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(ach.category, style: theme.textTheme.labelSmall),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: AppSkeleton(height: 100)),
              SizedBox(width: 16),
              Expanded(child: AppSkeleton(height: 100)),
            ],
          ),
          SizedBox(height: 32),
          AppSkeleton(height: 200),
        ],
      ),
    );
  }
}
