import 'package:flutter/material.dart';
import 'package:qr_scan/models/scan_models.dart';
import 'package:url_launcher/url_launcher.dart';

void launchURL(BuildContext context, ScanModel scan) async {
  final _url = scan.valor;

  if (scan.tipus == 'http') {
    if (!await launch(_url)) throw 'Could not launch $_url';
  } else {
    Navigator.pushNamed(context, 'mapa',
        arguments: scan); // definida en línea 25 del main
  }
}
