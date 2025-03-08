import 'package:flutter/material.dart';
import 'package:qr_scan/widgets/scan_tiles.dart';

/*
* muestra un widget de lista (ScanTiles) que filtra los elementos de escaneo que son URLs (tipus: 'http'). 
* 
* La lista que almacena los elementos que se muestran en el widget ScanTiles se encuentra en el 
* provider ScanListProvider. Este provider maneja el estado de los escaneos y almacena la lista de escaneos, 
* que luego se pasa al widget ScanTiles.
*/

class DireccionsScreen extends StatelessWidget {
  const DireccionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScanTiles(
        tipus:
            'http'); // Llama al widget ScanTiles, pasándole 'http' como tipo de scan.
  }
}
