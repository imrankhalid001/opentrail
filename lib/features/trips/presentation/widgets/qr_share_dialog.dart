import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/sharing/trip_share_service.dart';

class QrShareDialog extends StatelessWidget {
  final Trip trip;
  final List<ItineraryItem> items;

  const QrShareDialog({
    super.key,
    required this.trip,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    // Encrypt the trip data
    // Limit to 20 items to keep QR size manageable
    final sharingItems = items.take(20).toList();
    final encryptedData = TripShareService.encryptTrip(trip, sharingItems);

    return AlertDialog(
      title: Text('Share ${trip.title}'),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Your friend can scan this code to import your itinerary instantly.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: QrImageView(
                data: encryptedData,
                version: QrVersions.auto,
                size: 250.0,
                gapless: false,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
