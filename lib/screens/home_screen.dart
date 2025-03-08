import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scan/providers/db_provider.dart';
import 'package:qr_scan/providers/scan_list_provider.dart';
import 'package:qr_scan/providers/ui_provider.dart';
import 'package:qr_scan/screens/screens.dart';
import 'package:qr_scan/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              final esborrar =
                  Provider.of<ScanListProvider>(context, listen: false);
              esborrar.esborraTots();
            },
          )
        ],
      ),
      body: _HomeScreenBody(),
      bottomNavigationBar: CustomNavigationBar(),
      floatingActionButton: ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _HomeScreenBody extends StatelessWidget {
  const _HomeScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UIProvider>(context);
    final scanListProvider =
        Provider.of<ScanListProvider>(context, listen: false);
    // Canviar per a anar canviant entre pantalles
    final currentIndex = uiProvider.selectedMenuOpt;

    // Crear BBDD temp
    DBProvider.db.database;
    // ScanModel nouScan = ScanModel(valor: "https://paucasesnovescifp.cat");
    // DBProvider.db.insertScan(nouScan);

    switch (currentIndex) {
      case 0:
        scanListProvider.carregaScansPerTipus('geo');
        return MapasScreen();

      case 1:
        scanListProvider.carregaScansPerTipus('http');
        return DireccionsScreen();

      default:
        return MapasScreen();
    }
  }
}
