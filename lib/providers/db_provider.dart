import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:qr_scan/models/scan_models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
/*
* DBProvider es solo una capa de acceso a datos (DAO - Data Access Object), 
* pero no almacena nada en memoria ni notifica cambios.
*
* ScanListProvider almacena la lista de scans en List<ScanModel> scans y actualiza la UI cuando cambian los datos.
*/
class DBProvider{
  static Database? _database;

  static final DBProvider db = DBProvider._();

  DBProvider._(){}

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDB();
    }

    return _database!;
  }

  Future<Database> initDB() async {
      // Obtenir es path
      Directory documentsDirectory = await getApplicationCacheDirectory();
      final path = join(documentsDirectory.path, 'Scans.db');
      //await deleteDatabase(path);
      print(path);

      // Creació de la BBDD
      return await openDatabase(
        path, 
        version: 1,
        onOpen:(db) {},
        onCreate: (Database db, int version) async {
          await db.execute('''
          CREATE TABLE Scans(
            id INTEGER PRIMARY KEY,
            tipus TEXT,
            valor TEXT
          )
        ''');
        }
      );
    }

  Future<int> insertRawScan(ScanModel nouScan) async {
    final id = nouScan.id;
    final tipus = nouScan.tipus;
    final valor = nouScan.valor;

    final db = await database;
    final res = await db.rawInsert('''
      INSERT INTO Scans(id, tipus, valor)
        VALUES ($id, $tipus, $valor)
    ''');
    return res;
  }

  Future<int> insertScan(ScanModel nouScan) async {
    final db = await database;
    final res = await db.insert('Scans', nouScan.toMap());
    print(res); // imprime la cantidad de entradas que tiene la BBDD
    return res;
  }

  Future<List<ScanModel>> getAllScans() async{ // Select de toda la tabla
    final db = await database;
    final res = await db.query('Scans');

    return res.isNotEmpty ? res.map((e) => ScanModel.fromMap(e)).toList() : [];
  }

  Future<ScanModel?> getScanById(int id) async {
    final db = await database;
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);

    if (res.isNotEmpty) {
      return ScanModel.fromMap(res.first);
    } else {
      return null;
    }
  }

  Future<List<ScanModel>> getScanByTipus(String tipus) async {
    final db = await database;
    final res = await db.query('Scans', where: 'tipus = ?', whereArgs: [tipus]);

    if (res.isNotEmpty) {
      return res.map((e) => ScanModel.fromMap(e)).toList();
    } else {
      return [];
    }
  }
  
  Future<int> updateScan(ScanModel nouScan) async {
    final db = await database;
    final res = db.update('Scans', nouScan.toMap(), where: 'id = ?', whereArgs: [nouScan.id]);
    
    return res;
  }

  Future<int> deleteAll () async {
    final db = await database;
    final res = await db.rawDelete('''
      DELETE FROM Scans
    ''');

    return res;
  }

  Future<int> deleteScanById(int id) async {
    final db = await database;
    final res = await db.rawDelete('''
    DELETE FROM Scans WHERE ID = $id
    ''');

    return res;
  }
}