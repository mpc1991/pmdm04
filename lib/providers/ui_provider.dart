import 'package:flutter/material.dart';

/*
* UIProvider gestiona el estado de la opción seleccionada en el menú de navegación.
* 
* La clase extiende ChangeNotifier, por lo que puede notificar a los widgets
* que están escuchando a los cambios en el estado. Cuando el valor de 
* _selectedMenuOpt cambia, se llama a notifyListeners() para que los widgets 
* actualicen la UI en función de la opción seleccionada.
*/

class UIProvider extends ChangeNotifier {
  int _selectedMenuOpt =
      1; // Almacena el índice de la opción seleccionada en el menú

  // Getter para obtener la opción seleccionada
  int get selectedMenuOpt {
    return this._selectedMenuOpt;
  }

  // Setter para modificar la opción seleccionada y notificar los cambios a los listeners
  set selectedMenuOpt(int index) {
    this._selectedMenuOpt = index;
    notifyListeners();
  }
}
