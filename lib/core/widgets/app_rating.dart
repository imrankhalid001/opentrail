import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

/// Star rating display or interactive selector.
class AppRating extends StatelessWidget {
  final double rating;
  final int maxRating;
  final double size;
  final Color? color;
  final ValueChanged<double>? onRatingChanged;

  const AppRating({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 18.0,
    this.color,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? Colors.amber;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        final starValue = index + 1.0;
        final icon = rating >= starValue
            ? Icons.star_rounded
            : rating >= starValue - 0.5
            ? Icons.star_half_rounded
            : Icons.star_outline_rounded;

        return GestureDetector(
          onTap: onRatingChanged != null
              ? () => onRatingChanged!(starValue)
              : null,
          child: Padding(
            padding: const EdgeInsets.only(right: AppSpacing.xxs),
            child: Icon(icon, size: size, color: activeColor),
          ),
        );
      }),
    );
  }
}
