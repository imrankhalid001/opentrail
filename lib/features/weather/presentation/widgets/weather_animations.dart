import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A widget that renders a background effect based on weather condition.
class WeatherBackgroundEffect extends StatelessWidget {
  final int weatherCode;

  const WeatherBackgroundEffect({super.key, required this.weatherCode});

  @override
  Widget build(BuildContext context) {
    // Basic mapping of codes to effects
    // 0: Clear, 1-3: Cloudy, 45-48: Fog
    // 51-67: Rain/Drizzle, 71-77: Snow, 80-82: Rain showers, 85-86: Snow showers, 95-99: Thunderstorm

    if (weatherCode >= 51 && weatherCode <= 67 ||
        (weatherCode >= 80 && weatherCode <= 82) ||
        weatherCode >= 95) {
      return const RainEffect();
    } else if (weatherCode >= 71 && weatherCode <= 77 ||
        (weatherCode >= 85 && weatherCode <= 86)) {
      return const SnowEffect();
    } else if (weatherCode >= 1 && weatherCode <= 3) {
      return const CloudEffect();
    }

    return const SizedBox.shrink();
  }
}

class RainEffect extends StatefulWidget {
  const RainEffect({super.key});

  @override
  State<RainEffect> createState() => _RainEffectState();
}

class _RainEffectState extends State<RainEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = List.generate(40, (_) => _Particle());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ParticlePainter(
            particles: _particles,
            color: Colors.blue.withValues(alpha: 0.3),
            isRain: true,
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class SnowEffect extends StatefulWidget {
  const SnowEffect({super.key});

  @override
  State<SnowEffect> createState() => _SnowEffectState();
}

class _SnowEffectState extends State<SnowEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = List.generate(30, (_) => _Particle());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ParticlePainter(
            particles: _particles,
            color: Colors.white.withValues(alpha: 0.6),
            isRain: false,
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class CloudEffect extends StatefulWidget {
  const CloudEffect({super.key});

  @override
  State<CloudEffect> createState() => _CloudEffectState();
}

class _CloudEffectState extends State<CloudEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            _buildCloud(0.1, 0.2, 100),
            _buildCloud(0.5, 0.1, 150),
            _buildCloud(0.8, 0.3, 120),
          ],
        );
      },
    );
  }

  Widget _buildCloud(double top, double startOffset, double size) {
    double x = ((_controller.value + startOffset) % 1.0) * 1.5 - 0.25;
    return Positioned(
      top: MediaQuery.of(context).size.height * top,
      left: MediaQuery.of(context).size.width * x,
      child: Opacity(
        opacity: 0.2,
        child: Icon(Icons.cloud_rounded, size: size, color: Colors.grey),
      ),
    );
  }
}

class _Particle {
  double x = math.Random().nextDouble();
  double y = math.Random().nextDouble();
  double speed = 0.01 + math.Random().nextDouble() * 0.02;
  double size = 2 + math.Random().nextDouble() * 3;

  void update() {
    y += speed;
    if (y > 1.0) {
      y = -0.1;
      x = math.Random().nextDouble();
    }
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final Color color;
  final bool isRain;

  _ParticlePainter({
    required this.particles,
    required this.color,
    required this.isRain,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (var p in particles) {
      p.update();
      final pos = Offset(p.x * size.width, p.y * size.height);
      if (isRain) {
        canvas.drawLine(pos, pos + const Offset(0, 15), paint);
      } else {
        canvas.drawCircle(pos, p.size, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
