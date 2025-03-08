/*
* Va a pintar y lo llamaremos desde el direccions_screen.dart
*
* Este widget crea una lista de elementos (escaneos de códigos QR) 
* con la capacidad de ser eliminados mediante un gesto de deslizamiento (swipe). 
* Cada elemento tiene un icono que depende del tipo de QR (si es una URL o un mapa), 
* y al hacer clic en un elemento, se lanza la URL asociada al escaneo.
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scan/providers/scan_list_provider.dart';
import 'package:qr_scan/utils/utils.dart';

class ScanTiles extends StatelessWidget {
  final tipus; // Variable que determina si el QR es una URL o una ubicación.

  const ScanTiles({
    Key? key,
    required this.tipus, // Constructor que recibe el tipo de scan (URL o mapa).
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtiene el provider que maneja la lista de escaneos.
    final scanListProvider = Provider.of<ScanListProvider>(context);
    final scans =
        scanListProvider.scans; // Obtiene la lista de escaneos del provider.

    return ListView.builder(
      // Crea una lista de elementos
      itemCount: scans
          .length, // Establece la cantidad de elementos en la lista según la longitud de la lista de escaneos.
      itemBuilder: (_, index) => Dismissible(
        // Crea un elemento de lista que puede ser deslizado para ser eliminado.
        key: UniqueKey(), // identifica cada línea con una key única
        background: Container(
          // Diseño del fondo cuando el elemento es deslizado.
          color: Colors
              .red, // Establece el color de fondo a rojo cuando el elemento se desliza.
          child: Align(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons
                  .delete_forever_outlined), // Icono de eliminación que aparece al deslizar.
            ),
            alignment: Alignment.centerRight,
          ),
        ),
        onDismissed: (DismissDirection direccio) {
          // Acción que ocurre cuando el elemento es deslizado.
          final borrar = Provider.of<ScanListProvider>(context,
              listen: false); // Obtiene el provider sin escuchar cambios.
          borrar.esborraPerId(
              scans[index].id!); // Elimina el escaneo de la lista por su ID.
        },
        child: ListTile(
          // cada elemento de la lista
          leading: Icon(
            // Define el icono según el tipo de scan (URL o mapa).
            this.tipus == 'http' ? Icons.home_outlined : Icons.map_outlined,
          ),
          title:
              Text(scans[index].valor), // Muestra el valor del QR en el título
          subtitle: Text(scans[index]
              .id
              .toString()), // Muestra el ID del QR en el subtítulo.
          trailing: Icon(Icons.keyboard_arrow_right,
              color: Colors
                  .grey), //Un icono que indica que se puede hacer clic en el elemento.
          onTap: () {
            launchURL(
                context, scans[index]); // Llama a la función para abrir la URL.
          },
        ),
      ),
    );
  }
}
