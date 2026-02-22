import 'package:app_transporte/widgets/menu_card_item.dart';
import 'package:flutter/material.dart';
// Importamos la tarjeta reutilizable
// Importamos la pantalla a la que iremos
import 'encomiendas_rutas_screen.dart';

class MenuEncomiendasScreen extends StatelessWidget {
  const MenuEncomiendasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Menu Encomiendas',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Opción 1: Enviar Encomienda (Lleva a la lista de rutas)
          MenuCardItem(
            icon: Icons.local_shipping, // Puedes usar Icons.inventory si se parece más
            title: 'Encomiendas',
            subtitle: 'Envío de encomiendas',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EncomiendasRutasScreen(),
                ),
              );
            },
          ),
          
          // Opción 2: Recepción
          MenuCardItem(
            icon: Icons.assignment_return, 
            title: 'Recepción de encomiendas',
            subtitle: 'Control y seguimiento de encomiendas',
            onTap: () {
              // Aquí irá la pantalla de recepción más adelante
              print("Ir a Recepción de Encomiendas");
            },
          ),
          
          // Opción 3: Lista general
          MenuCardItem(
            icon: Icons.list_alt, 
            title: 'Lista de encomiendas',
            subtitle: 'Visualiza y gestiona todas tus encomiendas',
            onTap: () {
              // Aquí irá la pantalla de la lista más adelante
              print("Ir a Lista de Encomiendas");
            },
          ),
        ],
      ),
    );
  }
}