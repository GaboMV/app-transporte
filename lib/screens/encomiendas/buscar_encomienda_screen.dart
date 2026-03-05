import 'package:app_transporte/screens/shared/buscar_cliente_screen.dart';
import 'package:flutter/material.dart';
// Importamos la pantalla compartida de buscar cliente para cuando le demos a EMITIR

class BuscarEncomiendaScreen extends StatefulWidget {
  const BuscarEncomiendaScreen({super.key});

  @override
  State<BuscarEncomiendaScreen> createState() => _BuscarEncomiendaScreenState();
}

class _BuscarEncomiendaScreenState extends State<BuscarEncomiendaScreen> {
  // Controla si se muestra o no la tarjeta de resultado
  bool mostrarResultado = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'BUSCAR ENCOMIENDA',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- 1. INPUT DE BÚSQUEDA ---
            TextFormField(
              initialValue: '2138588500172024',
              decoration: InputDecoration(
                labelText: 'Numero de Guia',
                prefixText: '#  ',
                prefixStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                suffixIcon: const Icon(Icons.cancel, color: Colors.grey), // El ícono de la 'x'
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: const BorderSide(color: Color(0xFF0056A3)), // Borde azul
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: const BorderSide(color: Color(0xFF0056A3)),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                counterText: '16', // El indicador inferior derecho
              ),
            ),
            const SizedBox(height: 16),

            // --- 2. BOTÓN BUSCAR ---
            ElevatedButton.icon(
              onPressed: () {
                // Al presionar, mostramos la tarjeta
                setState(() {
                  mostrarResultado = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0056A3),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
              icon: const Icon(Icons.search, color: Colors.white),
              label: const Text(
                'BUSCAR',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 32),

            // --- 3. TARJETA DE RESULTADO Y BOTÓN EMITIR (Condicionales) ---
            if (mostrarResultado) ...[
              _buildTarjetaResultado(),
              const SizedBox(height: 32),
              
              ElevatedButton.icon(
                onPressed: () {
                  // Navegamos a la pantalla de Buscar Cliente para facturar
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // Pasamos isVoucher: false porque ahora sí se va a pagar (Factura normal)
                      builder: (context) => const BuscarClienteScreen(isVoucher: false),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0056A3),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
                icon: const Icon(Icons.send, color: Colors.white),
                label: const Text(
                  'EMITIR',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  // --- WIDGET AUXILIAR: TARJETA DE DATOS ---
  Widget _buildTarjetaResultado() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5), // Fondo gris claro
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildFilaTexto('Ruta:', 'La Paz - Yacuiba'),
          _buildFilaTexto('Destinatario:', 'ROBERTO PEREZ'),
          
          // Fila combinada para Celular y CI
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                const Text('Celular: ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                Text('77758547', style: TextStyle(color: Colors.grey.shade600)),
                const SizedBox(width: 16),
                const Text('CI: ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                Text('986652', style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          ),
          
          _buildFilaTexto('Monto Total:', '120.0 bs.'),
          _buildFilaTexto('Descripcion Encomienda:', 'CAJA BLANCA'),
          
          // Estado en color rojo
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                const Text('Estado: ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                const Text('No Despachado', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilaTexto(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$etiqueta ', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          Expanded(
            child: Text(valor, style: TextStyle(color: Colors.grey.shade600)),
          ),
        ],
      ),
    );
  }
}
