import 'package:app_transporte/features/trasnsporte/presentation/menu_transporte.dart';
import 'package:flutter/material.dart';
// Asegúrate de importar la pantalla que crearemos en el paso 3


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transporte App',
      debugShowCheckedModeBanner: false, // Oculta la etiqueta de "DEBUG"
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Un gris muy clarito para el fondo
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 1, // Sombra sutil debajo del AppBar
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black, 
            fontSize: 18, 
            fontWeight: FontWeight.w500
          ),
        ),
      ),
      home: const MenuTransporteScreen(), // Establece la pantalla de menú como la pantalla de inicio
    );
  }
}