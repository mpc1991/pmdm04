import 'package:flutter/material.dart';
import 'package:qr_scan/models/scan_models.dart';
import 'package:qr_scan/providers/db_provider.dart';
/*
* Interficie intermediaria entre la BBDD y los Widgets
*
* DBProvider es solo una capa de acceso a datos (DAO - Data Access Object), 
* pero no almacena nada en memoria ni notifica cambios.
*
* ScanListProvider almacena la lista de scans en List<ScanModel> scans y actualiza la UI cuando cambian los datos.
*/

class ScanListProvider extends ChangeNotifier {
  List<ScanModel> scans = [];
  String tipusSeleccionat = 'http';

  Future<ScanModel> nouScan(String valor) async {
    final nouScan = ScanModel(valor: valor);
    final id = await DBProvider.db.insertScan(nouScan);
    nouScan.id = id;

    if (nouScan.tipus == tipusSeleccionat) {
      this.scans.add(nouScan);
      notifyListeners();
    }
    return nouScan;
  }

  carregaScans() async {
    final scans = await DBProvider.db.getAllScans();
    this.scans = [
      ...scans
    ]; // se usa para "desempaquetar" una lista y copiar sus elementos en una nueva lista.
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
