import 'package:flutter/material.dart';
import 'package:qr_scan/widgets/scan_tiles.dart';
/*
* muestra un widget de lista (ScanTiles) que filtra los elementos de escaneo que son URLs (tipus: 'GEO'). 
* 
* La lista que almacena los elementos que se muestran en el widget ScanTiles se encuentra en el 
* provider ScanListProvider. Este provider maneja el estado de los escaneos y almacena la lista de escaneos, 
* que luego se pasa al widget ScanTiles.
*/
class MapasScreen extends StatelessWidget {
  const MapasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScanTiles(tipus: 'geo'); // Llama al widget ScanTiles, pasándole 'geo' como tipo de scan.
  }
}
