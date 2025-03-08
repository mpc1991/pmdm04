import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scan/providers/db_provider.dart';
import 'package:qr_scan/providers/scan_list_provider.dart';
import 'package:qr_scan/providers/ui_provider.dart';
import 'package:qr_scan/screens/screens.dart';
import 'package:qr_scan/widgets/widgets.dart';

/* 
* HomeScreen es la pantalla principal de la aplicación. contiene la barra de navegación, 
* el botón flotante y un cuerpo central que cambia según el índice seleccionado en el menú de navegación inferior.
*
* Inicializa la BBDD si no lo está ya
* 
* _HomeScreenBody: controla qué pantalla mostrar en función de la opción seleccionada en el menú inferior.
* * uiProvider se usa para obtener el estado de la interfaz de usuario (el índice de la opción seleccionada en el menú).
* * scanListProvider es utilizado para cargar los escaneos de diferentes tipos (en este caso, 'geo' o 'http').
*
* Dependiendo del tipo de escaneo seleccionado, muestra diferentes pantallas (Mapa o Direcciones) 
* y carga los escaneos correspondientes.
*/

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial'),
        actions: [
          IconButton( // Botón para eliminar todos los escaneos
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              // Obtiene el provider ScanListProvider sin escuchar cambios para eliminar todos los escaneos.
              final esborrar =
                  Provider.of<ScanListProvider>(context, listen: false);
              esborrar.esborraTots(); // Elimina todos los escaneos.
            },
          )
        ],
      ),
      body: _HomeScreenBody(),
      bottomNavigationBar: CustomNavigationBar(), // Barra de navegación inferior personalizada en /lib/widgets
      floatingActionButton: ScanButton(), // Botón flotante para iniciar el escaneo en /lib/widgets.
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, // Ubicación del botón flotante.
    );
  }
}

class _HomeScreenBody extends StatelessWidget {
  const _HomeScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UIProvider>(context); // Obtiene el estado de la interfaz de usuario.
    final scanListProvider =
        Provider.of<ScanListProvider>(context, listen: false); // Obtiene el provider de escaneos sin escuchar cambios.
    // Canviar per a anar canviant entre pantalles
    final currentIndex = uiProvider.selectedMenuOpt; // Obtiene la opción seleccionada en el menú inferior.

    DBProvider.db.database; // Llama a la base de datos para asegurarse de que esté inicializada.

    // Dependiendo de la opción seleccionada en el menú, cargará un tipo específico de escaneos y cambiará la pantalla.
    switch (currentIndex) {
      case 0:
        scanListProvider.carregaScansPerTipus('geo'); // Carga los escaneos de tipo 'geo' (geolocalización).
        return MapasScreen(); // Devuelve la pantalla del mapa.

      case 1:
        scanListProvider.carregaScansPerTipus('http'); // Carga los escaneos de tipo 'http' (URLs).
        return DireccionsScreen(); // Devuelve la pantalla de direcciones.

      default:
        return MapasScreen(); // Si no hay opción válida, se muestra el mapa por defecto.
    }
  }
}
