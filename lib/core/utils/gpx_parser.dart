import 'package:gpx/gpx.dart';

class GpxPoint {
  final double lat;
  final double lon;
  final double? elevation;
  final DateTime? time;

  GpxPoint({required this.lat, required this.lon, this.elevation, this.time});
}

class GpxParser {
  /// Parses a GPX XML string into a list of points with elevation data.
  static List<GpxPoint> parse(String gpxString) {
    try {
      final gpx = GpxReader().fromString(gpxString);
      final points = <GpxPoint>[];

      for (final trk in gpx.trks) {
        for (final seg in trk.trksegs) {
          for (final pt in seg.trkpts) {
            points.add(
              GpxPoint(
                lat: pt.lat ?? 0.0,
                lon: pt.lon ?? 0.0,
                elevation: pt.ele,
                time: pt.time,
              ),
            );
          }
        }
      }
      return points;
    } catch (e) {
      return [];
    }
  }
}
