import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_scan/models/scan_models.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

/*
* MapaScreen es una pantalla que muestra un mapa interactivo usando Google Maps.
* Se obtiene la ubicación actual del usuario y se dibuja una ruta entre su ubicación y un destino, 
* que es proporcionado a través de un `ScanModel`.
*
* El mapa permite cambiar entre diferentes tipos de mapa (normal y híbrido), y ofrece funciones como 
* el seguimiento de la ubicación del usuario y la capacidad de volver al punto inicial del mapa.
*/

class MapaScreen extends StatefulWidget {
  const MapaScreen({Key? key}) : super(key: key);

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  final Completer<GoogleMapController> _controller = Completer<
      GoogleMapController>(); // Controlador del mapa para interactuar con él
  MapType _mapType = MapType.normal; // Control del tipo de mapa
  Set<Polyline> _polylines =
      {}; // Conjunto de rutas (polilíneas) a dibujar en el mapa
  LatLng _miUbicacion = LatLng(
      0, 0); // Ubicación inicial del usuario (será actualizada más tarde)

  @override
  void initState() {
    super.initState();
    _detectarUbicacion(); // // Detecta la ubicación inicial del usuario al cargar la pantalla
  }

  /// Detecta la ubicación actual
  void _detectarUbicacion() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _miUbicacion = LatLng(position.latitude,
          position.longitude); // Actualiza la ubicación del usuario
    });
  }

  /// Dibuja la polilínea entre mi ubicación y el destino
  void _dibujarRuta() {
    final ScanModel scan = ModalRoute.of(context)!.settings.arguments
        as ScanModel; // Obtiene el ScanModel desde la navegación
    LatLng _destino = scan
        .getLatLng(); // Obtiene las coordenadas del destino desde el ScanModel

    // Crea una polilínea entre la ubicación del usuario y el destino
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
    // Obtiene el ScanModel desde la navegación para usar su destino en el mapa
    final ScanModel scan =
        ModalRoute.of(context)!.settings.arguments as ScanModel;
    LatLng _destino = scan.getLatLng(); // Obtiene el destino del ScanModel

    final CameraPosition _puntInicial = CameraPosition(
      target: scan.getLatLng(), // Centra el mapa en el destino
      zoom: 17,
      tilt: 50,
    );

    Set<Marker> markers =
        new Set<Marker>(); // Conjunto de marcadores para mostrar en el mapa
    markers.add(new Marker(
        markerId: MarkerId('id1'),
        position: scan.getLatLng())); // Añade el marcador del destino

    return Scaffold(
      appBar: AppBar(
        // añadir, appbar
        title: Text('Maps'),
        leading: IconButton(
          // icon to display before the toolbar's [title].
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () =>
              Navigator.pop(context), // Regresa a la pantalla anterior
        ),
        actions: [
          // Botón para volver al punto destino en el mapa
          IconButton(
            icon: Icon(Icons.location_pin),
            onPressed: () async {
              final GoogleMapController controller = await _controller.future;
              controller.animateCamera(CameraUpdate.newCameraPosition(
                  _puntInicial)); // Centra el mapa en el destino
            },
          ),

          // Botón para detectar la ubicación actual del usuario
          IconButton(
              icon: Icon(Icons.person_pin_circle),
              onPressed: () async {
                _detectarUbicacion(); // Actualiza la ubicación del usuario
                if (_polylines != null) {
                  _polylines == null;
                } else {
                  _dibujarRuta(); // Dibuja la ruta entre el usuario y el destino
                }
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          // botón para modificar el tipo de mapa
          child: const Icon(Icons.layers),
          onPressed: () {
            setState(() {
              _mapType = _mapType == MapType.normal
                  ? MapType.hybrid
                  : MapType.normal; // Cambia el tipo de mapa
            });
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .startFloat, // posición del floating button
      body: GoogleMap(
        myLocationEnabled: true, // Muestra la ubicación del usuario en el mapa
        myLocationButtonEnabled:
            true, // Habilita el botón de ubicación en el mapa
        mapType: _mapType,
        markers: markers, // Muestra los marcadores en el mapa
        polylines: _polylines, // mostrar rutas en el mapa
        initialCameraPosition: _puntInicial, // Posición inicial del mapa
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller); // Completa el controlador del mapa
        },
      ),
    );
  }
}
