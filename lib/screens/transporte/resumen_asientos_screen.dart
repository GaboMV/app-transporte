import 'package:app_transporte/screens/shared/buscar_cliente_screen.dart';
import 'package:flutter/material.dart';

class ResumenAsientosScreen extends StatefulWidget {
  final int cantidadAsientos;
  final String ruta;
  final String horario;

  const ResumenAsientosScreen({
    super.key,
    required this.cantidadAsientos,
    required this.ruta,
    required this.horario,
  });

  @override
  State<ResumenAsientosScreen> createState() => _ResumenAsientosScreenState();
}

class _ResumenAsientosScreenState extends State<ResumenAsientosScreen> {
  final TextEditingController _descuentoController = TextEditingController();
  final double precioPorAsiento = 10.0; // Lo que me pediste, 10 bs por asiento
  double descuento = 0.0;

  @override
  void initState() {
    super.initState();
    // Escuchamos los cambios en el input para actualizar el total en vivo
    _descuentoController.addListener(() {
      setState(() {
        descuento = double.tryParse(_descuentoController.text) ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _descuentoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double subtotal = widget.cantidadAsientos * precioPorAsiento;
    double totalFinal = subtotal - descuento;
    if (totalFinal < 0) totalFinal = 0; // Evitar totales negativos

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SECCIÓN DE DATOS DE LA RUTA ---
            _buildTextRow('Ruta:', widget.ruta),
            const SizedBox(height: 12),
            _buildTextRow('Horario:', widget.horario),
            const SizedBox(height: 12),
            _buildTextRow('Cantidad de Asientos:', widget.cantidadAsientos.toString()),
            const SizedBox(height: 12),
            _buildTextRow('Precio:', precioPorAsiento.toStringAsFixed(2)),
            
            const SizedBox(height: 40),

            // --- INPUT DE DESCUENTO ---
            TextField(
              controller: _descuentoController,
              keyboardType: TextInputType.number, // Solo números
              decoration: InputDecoration(
                prefixText: 'Bs  ',
                prefixStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                labelText: 'Descuento Adicional',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                counterText: '0/17', // Detalle visual del documento
              ),
            ),

            const SizedBox(height: 30),

            // --- BOTÓN BUSCAR CLIENTE ---
            Center(
              child: ElevatedButton.icon(
               onPressed: () {
                  // <-- AÑADE ESTA NAVEGACIÓN
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BuscarClienteScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0056A3), // Azul oscuro
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0), // Bordes bien redondeados
                  ),
                ),
                label: const Text(
                  'BUSCAR CLIENTE',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ),

            const Spacer(),

            // --- CAJA DE RESUMEN FINAL ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5), // Gris claro
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Descuento Adicional',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        descuento.toStringAsFixed(2),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        totalFinal.toStringAsFixed(0), // Lo dejamos sin decimales si es entero, como en la foto ("150")
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Función de ayuda para los textos superiores
  Widget _buildTextRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 160,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 15),
          ),
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ],
    );
  }
}
