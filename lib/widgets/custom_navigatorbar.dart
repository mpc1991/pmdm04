import 'package:flutter/material.dart';
import 'package:qr_scan/providers/ui_provider.dart';
import 'package:provider/provider.dart';

/*
* Widget que crea una barra de navegación inferior personalizada utilizando BottomNavigationBar. 
* El estado de la opción seleccionada se gestiona a través de un UIProvider (probablemente un ChangeNotifier), 
* lo que permite actualizar el índice seleccionado sin tener que mantener el estado en el widget. 
*/

class CustomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UIProvider>(
        context); // Obtiene el estado del UIProvider a través del context para acceder al estado.
    final currentIndex = uiProvider
        .selectedMenuOpt; // Obtiene el índice de la opción seleccionada del provider.

    return BottomNavigationBar(
        onTap: (int i) => uiProvider.selectedMenuOpt = i,
        elevation: 0, // Elimina la sombra de la barra de navegación inferior.
        currentIndex:
            currentIndex, // Establece el índice de la opción seleccionada en el momento actual.
        items: <BottomNavigationBarItem>[ // Lista de los ítems que aparecerán en la barra de navegación inferior.

          BottomNavigationBarItem( // Primer ítem de la barra, que representa el mapa.
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),


          BottomNavigationBarItem( // Segundo ítem de la barra, que representa direcciones.
            icon: Icon(Icons.compass_calibration),
            label: 'Direccions',
          )
        ]);
  }
}
