import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../core/sharing/trip_share_service.dart';

class QrScannerView extends StatefulWidget {
  final void Function(Map<String, dynamic>) onTripDecrypted;

  const QrScannerView({super.key, required this.onTripDecrypted});

  @override
  State<QrScannerView> createState() => _QrScannerViewState();
}

class _QrScannerViewState extends State<QrScannerView> {
  bool _isScanned = false;
  final MobileScannerController controller = MobileScannerController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Trip QR')),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (_isScanned) return;

              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                final code = barcode.rawValue;
                if (code != null) {
                  final decrypted = TripShareService.decryptTrip(code);
                  if (decrypted != null) {
                    _isScanned = true;
                    widget.onTripDecrypted(decrypted);
                    if (mounted) Navigator.pop(context);
                    break;
                  }
                }
              }
            },
          ),
          // Overlay to guide the user
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
