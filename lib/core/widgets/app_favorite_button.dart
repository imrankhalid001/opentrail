import 'package:flutter/material.dart';

/// Heart icon toggle button with smooth scale transition.
class AppFavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final ValueChanged<bool> onToggle;
  final double size;

  const AppFavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onToggle,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      iconSize: size,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) =>
            ScaleTransition(scale: animation, child: child),
        child: isFavorite
            ? Icon(
                Icons.favorite_rounded,
                key: const ValueKey('favorite'),
                color: Colors.redAccent,
                size: size,
              )
            : Icon(
                Icons.favorite_outline_rounded,
                key: const ValueKey('not_favorite'),
                color: theme.colorScheme.onSurfaceVariant,
                size: size,
              ),
      ),
      onPressed: () => onToggle(!isFavorite),
    );
  }
}
