import 'package:flutter/material.dart';

import 'weather_icon_mapper.dart';

class AnimatedWeatherIcon extends StatefulWidget {
  final int weatherCode;
  final bool isDay;
  final double size;

  const AnimatedWeatherIcon({
    super.key,
    required this.weatherCode,
    this.isDay = true,
    this.size = 24.0,
  });

  @override
  State<AnimatedWeatherIcon> createState() => _AnimatedWeatherIconState();
}

class _AnimatedWeatherIconState extends State<AnimatedWeatherIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iconData = WeatherIconMapper.getIcon(widget.weatherCode);
    final theme = Theme.of(context);

    // Determine color based on icon type
    Color iconColor;
    if (iconData == Icons.wb_sunny_rounded) {
      iconColor = Colors.orangeAccent;
    } else if (iconData == Icons.wb_cloudy_rounded ||
        iconData == Icons.cloud_rounded) {
      iconColor = theme.colorScheme.outline;
    } else if (iconData == Icons.water_drop_rounded ||
        iconData == Icons.umbrella_rounded) {
      iconColor = theme.colorScheme.tertiary;
    } else {
      iconColor = theme.colorScheme.primary;
    }

    Widget child;

    // Condition-specific animations
    if (widget.weatherCode == 0 && widget.isDay) {
      // Rotating Sun
      child = RotationTransition(
        turns: _controller,
        child: Icon(
          Icons.wb_sunny_rounded,
          size: widget.size,
          color: Colors.orangeAccent,
        ),
      );
    } else if (widget.weatherCode == 0 && !widget.isDay) {
      // Pulsing Moon
      child = ScaleTransition(
        scale: Tween(begin: 0.9, end: 1.1).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        ),
        child: Icon(
          Icons.nightlight_round,
          size: widget.size,
          color: Colors.amber.shade200,
        ),
      );
    } else if (widget.weatherCode >= 1 && widget.weatherCode <= 3) {
      // Swaying Clouds
      child = SlideTransition(
        position:
            Tween<Offset>(
              begin: const Offset(-0.1, 0),
              end: const Offset(0.1, 0),
            ).animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
            ),
        child: Icon(iconData, size: widget.size, color: iconColor),
      );
    } else if (widget.weatherCode >= 51 && widget.weatherCode <= 67 ||
        widget.weatherCode >= 80 && widget.weatherCode <= 82) {
      // Bouncing Rain
      child = SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.1),
          end: const Offset(0, 0.1),
        ).animate(CurvedAnimation(parent: _controller, curve: Curves.bounceIn)),
        child: Icon(iconData, size: widget.size, color: iconColor),
      );
    } else {
      child = Icon(iconData, size: widget.size, color: iconColor);
    }

    return RepaintBoundary(child: child);
  }
}
