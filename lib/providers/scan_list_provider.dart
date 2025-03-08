import 'package:flutter/material.dart';
import 'package:qr_scan/models/scan_models.dart';
import 'package:qr_scan/providers/db_provider.dart';

/*
* ScanListProvider es el intermediario entre la base de datos (DBProvider) y la UI. 
* Se encarga de almacenar en memoria la lista de escaneos (scans) en una variable 
* de tipo List<ScanModel> y notificar a la UI cuando haya cambios en los datos.
*
* Esta clase usa el patrón de diseño ChangeNotifier para actualizar la interfaz de usuario 
* cuando la lista de escaneos cambia (por ejemplo, al agregar, eliminar o cargar escaneos).
* 
* Mientras que DBProvider maneja el acceso a la base de datos (CRUD), ScanListProvider 
* es responsable de cargar, actualizar y eliminar los datos en memoria y reflejar esos 
* cambios en la UI.
*/

class ScanListProvider extends ChangeNotifier {
  List<ScanModel> scans = [];
  String tipusSeleccionat = 'http';

  // Crea un nuevo escaneo y lo guarda en la base de datos
  Future<ScanModel> nouScan(String valor) async {
    final nouScan = ScanModel(valor: valor);
    final id = await DBProvider.db.insertScan(nouScan);
    nouScan.id = id;

    // Si el tipo de escaneo coincide con el tipo seleccionado, se agrega a la lista
    if (nouScan.tipus == tipusSeleccionat) {
      this.scans.add(nouScan);
      notifyListeners();
    }
    return nouScan;
  }

  // Carga todos los escaneos de la base de datos
  carregaScans() async {
    final scans = await DBProvider.db.getAllScans();
    this.scans = [
      ...scans // se usa para "desempaquetar" una lista y copiar sus elementos en una nueva lista.
    ];
    notifyListeners();
  }

  carregaScansPerTipus(String tipus) async {
    final scans = await DBProvider.db.getScanByTipus(tipus);
    this.scans = [...scans];
    notifyListeners();
  }

  esborraTots() async {
    final scans = await DBProvider.db.deleteAll();
    this.scans = [];
    notifyListeners();
  }

  esborraPerId(int id) async {
    final scans = await DBProvider.db.deleteScanById(id);
    if (scans != null && scans > 0) {
      carregaScans();
      //this.scans.removeWhere((scan) => scan.id == id)
      notifyListeners();
    }
  }
}
