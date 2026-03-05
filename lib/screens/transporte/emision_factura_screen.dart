import 'package:flutter/material.dart';
import 'mapa_asientos_screen.dart';

class EmisionFacturasScreen extends StatelessWidget {
  const EmisionFacturasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const TextField(
          decoration: InputDecoration(
            hintText: 'Filtrar por destino o origen o precio',
            hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 8),
          ),
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          RutaCard(
            origen: 'Tarija',
            destino: 'Pando',
            precio: '25.80',
            fechaSalida: '2024-11-06 07:05:00',
            fechaLlegada: '2024-11-07 18:11:29',
            backgroundColor: Colors.white,
          ),
          SizedBox(height: 12),
          RutaCard(
            origen: 'La Paz',
            destino: 'Yacuiba',
            precio: '25.00',
            fechaSalida: '2024-11-07 06:52:00',
            fechaLlegada: '2024-11-07 18:11:29',
            backgroundColor: Color(0xFFE0E0E0),
          ),
        ],
      ),
    );
  }
}

class RutaCard extends StatelessWidget {
  final String origen;
  final String destino;
  final String precio;
  final String fechaSalida;
  final String fechaLlegada;
  final Color backgroundColor;

  const RutaCard({
    super.key,
    required this.origen,
    required this.destino,
    required this.precio,
    required this.fechaSalida,
    required this.fechaLlegada,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navegación hacia el mapa de asientos
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MapaAsientosScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey.shade300, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildInfoRow('Origen:', origen),
            _buildInfoRow('Destino:', destino),
            _buildInfoRow('Precio:', precio, isBoldValue: true),
            _buildInfoRow('Fecha Salida:', fechaSalida),
            _buildInfoRow('Fecha Llegada:', fechaLlegada),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBoldValue = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isBoldValue ? FontWeight.bold : FontWeight.normal,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
