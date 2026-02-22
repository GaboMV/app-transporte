import 'package:app_transporte/features/encomiendas/presentation/encomiendas_rutas_screen.dart';
import 'package:app_transporte/features/encomiendas/presentation/menu_encomiendas_screen.dart';
import 'package:app_transporte/features/trasnsporte/presentation/emision_factura_screen.dart';
import 'package:app_transporte/widgets/menu_card_item.dart';
import 'package:flutter/material.dart';
// Importamos nuestro widget personalizado


class MenuTransporteScreen extends StatelessWidget {
  const MenuTransporteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Lógica para volver atrás si es necesario
          },
        ),
        title: const Text('Menu Transporte'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          MenuCardItem(
            icon: Icons.person_add_alt_1, 
            title: 'Suscripción de Usuarios',
            subtitle: 'Administración de datos de usuarios vendedores y/o Despachantes u Ambos',
            onTap: () {
              print('Navegar a Suscripción');
            },
          ),
          MenuCardItem(
            icon: Icons.directions_bus, 
            title: 'Administración de Buses',
            subtitle: 'Registro, eliminación y listado de buses',
            onTap: () {},
          ),
          MenuCardItem(
            icon: Icons.map_outlined, 
            title: 'Administración de rutas',
            subtitle: 'Registro, eliminación y listado de rutas',
            onTap: () {},
          ),
         MenuCardItem(
            icon: Icons.receipt_long, 
            title: 'Emisión de Facturas',
            subtitle: 'Emisión de facturas',
            onTap: () {
              // 2. Aquí agregamos la navegación a la nueva pantalla
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EmisionFacturasScreen(), // Asegúrate de que esta pantalla esté creada y configurada
                ),
              );
            },
          ),
          MenuCardItem(
            icon: Icons.local_shipping, 
            title: 'Gestion de Encomiendas',
            subtitle: 'Menu de encomiendas',
            onTap: () {
              // <-- AGREGA ESTA NAVEGACIÓN
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MenuEncomiendasScreen(),
                ),
              );
            },
          ),
          MenuCardItem(
            icon: Icons.inventory_2, 
            title: 'Envio de Paquetes',
            subtitle: 'Envío y monitoreo de paquetes',
            onTap: () {},
          ),
          MenuCardItem(
            icon: Icons.send_to_mobile, 
            title: 'Facturas emitidas',
            subtitle: 'Envío y monitoreo de facturas emitidas',
            onTap: () {},
          ),
          MenuCardItem(
            icon: Icons.list_alt, 
            title: 'Generación de Planillas',
            subtitle: 'Generación de planilla de pasajeros',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}