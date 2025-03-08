import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_scan/models/scan_models.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({Key? key}) : super(key: key);

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  MapType _mapType = MapType.normal; // Control del tipo de mapa
  Set<Polyline> _polylines = {};
  LatLng _miUbicacion = LatLng(0, 0); // Se actualizará con la ubicación real

  @override
  void initState() {
    super.initState();
    _detectarUbicacion(); // mi ubicación
  }

  /// Detecta la ubicación actual
  void _detectarUbicacion() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _miUbicacion = LatLng(position.latitude, position.longitude);
    });
  }

  /// Dibuja la polilínea entre mi ubicación y el destino
  void _dibujarRuta() {
    final ScanModel scan =
        ModalRoute.of(context)!.settings.arguments as ScanModel;
    LatLng _destino = scan.getLatLng(); // Obtiene el destino del ScanModel

    Polyline polyline = Polyline(
      polylineId: PolylineId("ruta1"),
      color: Colors.blue,
      width: 5,
      points: [_miUbicacion, _destino], // Une mi ubicación con el marcador
    );

    setState(() {
      _polylines.add(polyline); // Añadimos la polilínea al mapa
    });
  }

  @override
  Widget build(BuildContext context) {
    final ScanModel scan =
        ModalRoute.of(context)!.settings.arguments as ScanModel;
    LatLng _destino = scan.getLatLng(); // Obtiene el destino del ScanModel

    final CameraPosition _puntInicial = CameraPosition(
      target: scan.getLatLng(),
      zoom: 17,
      tilt: 50,
    );

    Set<Marker> markers = new Set<Marker>();
    markers
        .add(new Marker(markerId: MarkerId('id1'), position: scan.getLatLng()));

    return Scaffold(
      appBar: AppBar(
        // añadir, appbar
        title: Text('Maps'),
        leading: IconButton(
          // icon to display before the toolbar's [title].
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Volver al punto inicial
          IconButton(
            icon: Icon(Icons.location_pin),
            onPressed: () async {
              final GoogleMapController controller = await _controller.future;
              controller
                  .animateCamera(CameraUpdate.newCameraPosition(_puntInicial));
            },
          ),
          IconButton(
              icon: Icon(Icons.person_pin_circle),
              onPressed: () async {
                _detectarUbicacion();
                if (_polylines != null) {
                  _polylines == null;
                } else {
                  _dibujarRuta();
                }
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          // botón para modificar el tipo de mapa
          child: const Icon(Icons.layers),
          onPressed: () {
            setState(() {
              _mapType =
                  _mapType == MapType.normal ? MapType.hybrid : MapType.normal;
            });
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .startFloat, // posición del floating button
      body: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: _mapType,
        markers: markers,
        polylines: _polylines, // mostrar rutas
        initialCameraPosition: _puntInicial,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
