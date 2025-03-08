import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:qr_scan/models/scan_models.dart';
import 'package:qr_scan/providers/scan_list_provider.dart';
import 'package:qr_scan/utils/utils.dart';

class ScanButton extends StatelessWidget {
  ScanButton({Key? key}) : super(key: key);
  final MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      child: Icon(
        Icons.filter_center_focus,
      ),
      onPressed: () async {
         showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: SizedBox(
                width: double.maxFinite,
                height: 300,
                child: Stack(
                  children: [
                    MobileScanner(
                      controller: cameraController,
                      onDetect: (BarcodeCapture capture) {
                        // Obté el primer QR detectat.
                        var barcode = capture.barcodes.first;
                        if (barcode.rawValue != null) {
                        final scanListProvider = Provider.of<ScanListProvider>(context, listen: false);
                          final String code = barcode.rawValue!;
                          ScanModel nouScan = ScanModel(valor: code);
                          // TODO: Afegir scan al provider i fer el launch url per exemple
                          scanListProvider.nouScan(code);
                          Navigator.pop(context); // Tanca el diàleg
                          launchURL(context, nouScan);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('No s\'ha pogut llegir el QR.'),
                            ),
                          );
                        }
                      },
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
