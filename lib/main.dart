import 'package:app_transporte/screens/transporte/menu_transporte_screen.dart';
import 'package:flutter/material.dart';
// Asegúrate de importar la pantalla que crearemos en el paso 3


import 'package:app_transporte/screens/remix/login_screen.dart';
import 'package:app_transporte/screens/remix/dashboard_screen.dart';
import 'package:app_transporte/screens/remix/sales_screen.dart';
import 'package:app_transporte/screens/remix/buses_screen.dart';
import 'package:app_transporte/screens/remix/clients_screen.dart';
import 'package:app_transporte/screens/remix/conductores_screen.dart';
import 'package:app_transporte/screens/remix/drivers_screen.dart';
import 'package:app_transporte/screens/remix/parcels_screen.dart';
import 'package:app_transporte/screens/remix/pasajes_vendidos_screen.dart';
import 'package:app_transporte/screens/remix/register_package_screen.dart';
import 'package:app_transporte/screens/remix/routes_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transporte App',
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), 
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 1, 
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black, 
            fontSize: 18, 
            fontWeight: FontWeight.w500
          ),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/sales': (context) => const SalesScreen(),
        '/buses': (context) => const BusesScreen(),
        '/clients': (context) => const ClientsScreen(),
        '/conductores': (context) => const ConductoresScreen(),
        '/drivers': (context) => const DriversScreen(),
        '/parcels': (context) => const ParcelsScreen(),
        '/parcels/new': (context) => const RegisterPackageScreen(),
        '/sales/history': (context) => const PasajesVendidosScreen(),
        '/routes': (context) => const RoutesScreen(),
      },
    );
  }
}
