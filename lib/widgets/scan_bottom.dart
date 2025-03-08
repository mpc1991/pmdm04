import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:qr_scan/models/scan_models.dart';
import 'package:qr_scan/providers/scan_list_provider.dart';
import 'package:qr_scan/utils/utils.dart';

class ScanButton extends StatelessWidget {
  ScanButton({Key? key}) : super(key: key);
  final MobileScannerController cameraController =
      MobileScannerController(); // Controlador para la camara

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
                  // Apila widgets para permitir superposición (en este caso, el scanner y un botón de cerrar).
                  children: [
                    MobileScanner(
                      // Widget para escanear códigos QR utilizando la cámara del dispositivo
                      controller: cameraController, // Controlador de la cámara.
                      onDetect: (BarcodeCapture capture) {
                        // Callback que se ejecuta cuando se detecta un código QR.
                        // Obté el primer QR detectat.
                        var barcode = capture.barcodes.first;
                        if (barcode.rawValue != null) {
                          // Obtiene el provider para manejar la lista de escaneos.
                          final scanListProvider =
                              Provider.of<ScanListProvider>(context,
                                  listen: false);
                          final String code = barcode.rawValue!;
                          ScanModel nouScan = ScanModel(
                              valor:
                                  code); // Crea un nuevo objeto ScanModel con el valor del código.
                          scanListProvider.nouScan(
                              code); // Añade el nuevo escaneo a la lista de escaneos en el provider.
                          Navigator.pop(context); // Tanca el diàleg
                          launchURL(context,
                              nouScan); // Llama a la función para abrir la URL del código QR escaneado.
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
                      // Posiciona un botón de cerrar en la parte superior derecha del cuadro de diálogo.
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
