import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scan/providers/scan_list_provider.dart';
import 'package:qr_scan/providers/ui_provider.dart';
import 'package:qr_scan/screens/home_screen.dart';
import 'package:qr_scan/screens/mapa_screen.dart';

void main() => runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => UIProvider()),
      ChangeNotifierProvider(
          create: (_) => ScanListProvider()), // llama a scan_list_provider
    ], child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // Desactiva el banner de debug que aparece en la esquina superior derecha en modo desarrollo.
      title: 'QR Reader',
      initialRoute: 'home', // Ruta inicial de la aplicación cuando se lanza.
      routes: {
        'home': (_) =>
            HomeScreen(), // Asocia la ruta 'home' con el widget HomeScreen.
        'mapa': (_) =>
            MapaScreen(), // Asocia la ruta 'mapa' con el widget MapaScreen.
      },
      theme: ThemeData(
        // No es pot emprar colorPrimary des de l'actualització de Flutter
        colorScheme: ColorScheme.light().copyWith(
          primary: Colors.deepPurple,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurple,
        ),
      ),
    );
  }
}
