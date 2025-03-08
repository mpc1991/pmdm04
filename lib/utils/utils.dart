import 'package:flutter/material.dart';
import 'package:qr_scan/models/scan_models.dart';
import 'package:url_launcher/url_launcher.dart';

// Función para lanzar una URL o navegar a un mapa según el tipo de escaneo.
void launchURL(BuildContext context, ScanModel scan) async {
  final _url = scan.valor; // Obtiene el valor de la URL o datos del escaneo.

  // Verifica si el tipo del escaneo es 'http' (URL).
  if (scan.tipus == 'http') {
    // Intenta lanzar la URL. Si no se puede, lanza un error.
    if (!await launch(_url)) throw 'Could not launch $_url';
  } else {
    // Si el tipo no es 'http', navega a la pantalla del mapa pasando el escaneo como argumento.
    Navigator.pushNamed(context, 'mapa',
        arguments:
            scan); // La ruta 'mapa' está definida en el main, se pasa el escaneo como argumento.
  }
}
