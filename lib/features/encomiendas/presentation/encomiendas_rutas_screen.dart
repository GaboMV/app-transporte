import 'package:app_transporte/features/encomiendas/presentation/emision_encomienda_screen.dart';
import 'package:flutter/material.dart';

class EncomiendasRutasScreen extends StatelessWidget {
  const EncomiendasRutasScreen({super.key});

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
          RutaEncomiendaCard(
            origen: 'Tarija',
            destino: 'Pando',
            precio: '25.80',
             fechaSalida: '01/01/2024',
            fechaLegada: '01/02/2024',
            backgroundColor: Colors.white,
          ),
          SizedBox(height: 12),
          RutaEncomiendaCard(
            origen: 'La Paz',
            destino: 'Yacuiba',
            precio: '25.00',
            fechaSalida: '01/01/2024',
            fechaLegada: '01/02/2024',
            backgroundColor: Color(0xFFE0E0E0), // Gris para simular la segunda tarjeta
          ),
        ],
      ),
    );
  }
}

// --- WIDGET REUTILIZABLE PARA LA TARJETA DE ENCOMIENDA ---
class RutaEncomiendaCard extends StatelessWidget {
  final String origen;
  final String destino;
  final String precio;
  final String fechaSalida;
  final String fechaLegada;
  final Color backgroundColor;

  const RutaEncomiendaCard({
    super.key,
    required this.origen,
    required this.destino,
    required this.precio,
    required this.backgroundColor, 
    required this.fechaSalida, 
    required this.fechaLegada,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
     onTap: () {
        // <-- AÑADE LA NAVEGACIÓN AQUÍ
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmisionEncomiendaScreen(
              ruta: '$origen - $destino', // Le pasamos la ruta dinámica
            ),
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
             _buildInfoRow('Fecha salida:',fechaSalida),
              _buildInfoRow('Fecha llegada:', fechaLegada),
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
            width: 80, // Un poco más estrecho porque las palabras son cortas
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