import 'package:flutter/material.dart';

class ReportePdfScreen extends StatefulWidget {
  const ReportePdfScreen({super.key});

  @override
  State<ReportePdfScreen> createState() => _ReportePdfScreenState();
}

class _ReportePdfScreenState extends State<ReportePdfScreen> {
  bool isXmlSelected = false;
  bool isPdfSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0056A3), // Fondo azul oscuro
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Reporte PDF',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: [
          // Checkbox XML
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: isXmlSelected,
              activeColor: Colors.white,
              checkColor: const Color(0xFF0056A3),
              onChanged: (value) => setState(() => isXmlSelected = value!),
            ),
          ),
          const Text('XML', style: TextStyle(color: Colors.white)),
          
          // Checkbox PDF
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: isPdfSelected,
              activeColor: Colors.white,
              checkColor: const Color(0xFF0056A3),
              onChanged: (value) => setState(() => isPdfSelected = value!),
            ),
          ),
          const Text('PDF', style: TextStyle(color: Colors.white)),
          
          // Icono Compartir
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- ENCABEZADO DE LA FACTURA ---
            const Text('FACTURA', style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('CON DERECHO A CRÉDITO FISCAL', style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('ORDOÑEZ CUELLAR DANNER', style: TextStyle(color: Colors.grey)),
            const Text('Casa Matriz', style: TextStyle(color: Colors.grey)),
            const Text('No. Punto de Venta 0', style: TextStyle(color: Colors.grey)),
            const Text('CALLE NINA DE FUENTES ZONA/BARRIO: RESIDENCIAL NORTE', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            const Text('PAILON', style: TextStyle(color: Colors.grey)),
            const Text('PAILON', style: TextStyle(color: Colors.grey)),
            
            _buildLineaPunteada(),

            // --- DATOS DE AUTORIZACIÓN ---
            const Text('NIT', style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('3858850017', style: TextStyle(color: Colors.grey)),
            const Text('FACTURA N°', style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('438', style: TextStyle(color: Colors.grey)),
            const Text('CÓD. AUTORIZACIÓN', style: TextStyle(fontWeight: FontWeight.bold)),
            const Text(
              'BQcKhQnknLkRBNzUZBQjAwRTA3QTc=Q0FddIRMSExZV\nUFC4N0UxN0NFRDRDN',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            
            _buildLineaPunteada(),

            // --- DATOS DEL CLIENTE ---
            _buildFilaCliente('NOMBRE/RAZÓN SOCIAL:', 'PRUEBA-'),
            _buildFilaCliente('NIT/CI/CEX:', '555555'),
            _buildFilaCliente('COD. CLIENTE:', '555555'),
            _buildFilaCliente('FECHA DE EMISIÓN:', '06/11/2024 05:59 PM'),

            _buildLineaPunteada(),

            // --- DETALLE ---
            const Text('DETALLE', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            // Descripción del pasaje
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Ruta: La Paz - Yacuiba Planta Inferior, número asiento: 4',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Unidad de Medida: 68', style: TextStyle(color: Colors.grey.shade600)),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('1.00000 X 9.0000 - 0.00000', style: TextStyle(color: Colors.grey.shade600)),
            ),
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerRight,
              child: Text('100.00', style: TextStyle(fontWeight: FontWeight.bold)),
            ),

            _buildLineaPunteada(),

            // --- TOTALES ---
            _buildFilaTotal('SUBTOTAL Bs.', '100.00'),
            _buildFilaTotal('DESCUENTO Bs.', '0.00'),
            _buildFilaTotal('TOTAL Bs.', '100.00'),
            _buildFilaTotal('MONTO GIFT CARD Bs.', '0.0'),
            _buildFilaTotal('MONTO A PAGAR Bs', '100.00', isBold: true),
            _buildFilaTotal('IMPORTE BASE CRÉDITO FISCAL', '100.00', isBold: true),
            
            const SizedBox(height: 80), // Espacio para que los botones flotantes no tapen el texto
          ],
        ),
      ),

      // --- BOTONES FLOTANTES (EMAIL Y WHATSAPP) ---
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'email_btn', // Necesario cuando hay múltiples FABs
            onPressed: () {},
            backgroundColor: const Color(0xFFE95B54), // Rojo para el correo
            child: const Icon(Icons.mail_outline, color: Colors.white),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'whatsapp_btn',
            onPressed: () {},
            backgroundColor: const Color(0xFF10C172), // Verde para WhatsApp
            child: const Icon(Icons.chat, color: Colors.white), // Usamos 'chat' por defecto, o puedes usar FontAwesome
          ),
        ],
      ),
    );
  }

  // --- WIDGETS AUXILIARES PARA MANTENER EL CÓDIGO LIMPIO ---

  Widget _buildLineaPunteada() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        '- ' * 40,
        maxLines: 1,
        style: const TextStyle(color: Colors.grey, overflow: TextOverflow.clip),
      ),
    );
  }

  Widget _buildFilaCliente(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(etiqueta, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(width: 8),
          Text(valor, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildFilaTotal(String etiqueta, String valor, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              etiqueta,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: isBold ? Colors.black : Colors.grey.shade700,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: Text(
              valor,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: isBold ? Colors.black : Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}