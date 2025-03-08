import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

/*
* Clase que representa un escaneo realizado por la aplicación. 
* Almacena un identificador único (id), el tipo de escaneo (tipus) que puede ser 'http' o 'geo', 
* y el valor (valor) que contiene la URL o las coordenadas geográficas. 
* Si el valor contiene 'http', el tipo se asigna automáticamente como 'http', 
* de lo contrario, se considera como coordenada geográfica ('geo').
*
* Proporciona métodos para:
* - Convertir un valor 'geo' en coordenadas geográficas (LatLng).
* - Convertir la clase a un formato JSON para almacenamiento o transmisión.
* - Convertir de JSON o de un mapa de datos a un objeto ScanModel.
*/

class ScanModel {
  int? id;
  String? tipus; // Tipo de escaneo (puede ser 'http' o 'geo')
  String
      valor; // Valor del escaneo, que puede ser una URL o una coordenada geográfica

  // Constructor que inicializa los atributos de la clase.
  // Si el valor contiene 'http', el tipo se asigna a 'http'. Si no, se asigna 'geo'.
  ScanModel({
    this.id,
    this.tipus,
    required this.valor,
  }) {
    if (this.valor.contains('http')) {
      this.tipus = 'http';
    } else {
      this.tipus = 'geo';
    }
  }

  // Método que convierte el valor de la propiedad 'valor' en un objeto LatLng.
  // Se asume que el valor está en formato 'geo:lat,lon' y se extraen las coordenadas.
  LatLng getLatLng() {
    final latLng = this.valor.substring(4).split(',');
    final latitude = double.parse(latLng[0]);
    final longitude = double.parse(latLng[1]);

    return LatLng(latitude, longitude);
  }

  // Convierte un JSON en un objeto ScanModel
  factory ScanModel.fromJson(String str) => ScanModel.fromMap(json.decode(str));

  // Convierte el objeto ScanModel a una cadena JSON
  String toJson() => json.encode(toMap());

  // Convierte un mapa de clave/valor en un objeto ScanModel
  factory ScanModel.fromMap(Map<String, dynamic> json) => ScanModel(
        id: json["id"],
        tipus: json["tipus"],
        valor: json["valor"],
      );

  // Convierte el objeto ScanModel a un mapa de clave/valor
  Map<String, dynamic> toMap() => {
        "id": id,
        "tipus": tipus,
        "valor": valor,
      };
}
