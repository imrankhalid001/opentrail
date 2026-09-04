import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

/// Standardized Section Header with optional action button.
class AppSectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  const AppSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: theme.textTheme.titleLarge),
          if (actionLabel != null && onActionPressed != null)
            TextButton(onPressed: onActionPressed, child: Text(actionLabel!)),
        ],
      ),
    );
  }
}
