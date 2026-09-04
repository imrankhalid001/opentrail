import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

enum AppCardVariant { elevated, outlined, filled }

/// Reusable Material 3 Surface Card.
class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AppCardVariant variant;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.margin,
    this.variant = AppCardVariant.elevated,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      side: variant == AppCardVariant.outlined
          ? BorderSide(color: theme.colorScheme.outlineVariant)
          : BorderSide.none,
    );

    final color = switch (variant) {
      AppCardVariant.elevated => theme.colorScheme.surface,
      AppCardVariant.outlined => theme.colorScheme.surface,
      AppCardVariant.filled => theme.colorScheme.surfaceContainer,
    };

    final elevation = variant == AppCardVariant.elevated ? 1.0 : 0.0;

    return Container(
      margin: margin,
      child: Material(
        color: color,
        elevation: elevation,
        shape: cardShape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
        ),
      ),
    );
  }
}
