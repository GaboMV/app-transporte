import 'package:flutter/material.dart';

class ReportePdfScreen extends StatefulWidget {
  // Esta es la clave: un parámetro que nos dirá qué diseño mostrar
  final bool isVoucher;

  const ReportePdfScreen({
    super.key,
    this.isVoucher = false, // Por defecto mostrará la factura normal
  });

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
      // El AppBar cambia de color dependiendo si es Voucher o Factura
      appBar: widget.isVoucher ? _buildVoucherAppBar() : _buildFacturaAppBar(),
      // El cuerpo también cambia dependiendo de la variable
      body: widget.isVoucher ? _buildVoucherBody() : _buildFacturaBody(),
      // Los botones de WhatsApp y Correo son iguales para ambos, así que los reciclamos
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'email_btn',
            onPressed: () {},
            backgroundColor: const Color(0xFFE95B54),
            child: const Icon(Icons.mail_outline, color: Colors.white),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'whatsapp_btn',
            onPressed: () {},
            backgroundColor: const Color(0xFF10C172),
            child: const Icon(Icons.chat, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // 1. DISEÑO: FACTURA (PAGADO)
  // ==========================================================
  
  PreferredSizeWidget _buildFacturaAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0056A3),
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      title: const Text('Reporte PDF', style: TextStyle(color: Colors.white, fontSize: 18)),
      actions: [
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
        IconButton(icon: const Icon(Icons.share, color: Colors.white), onPressed: () {}),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildFacturaBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('FACTURA', style: TextStyle(fontWeight: FontWeight.bold)),
          const Text('CON DERECHO A CRÉDITO FISCAL', style: TextStyle(fontWeight: FontWeight.bold)),
          const Text('ORDOÑEZ CUELLAR DANNER', style: TextStyle(color: Colors.grey)),
          const Text('Casa Matriz', style: TextStyle(color: Colors.grey)),
          const Text('No. Punto de Venta 0', style: TextStyle(color: Colors.grey)),
          const Text('CALLE NINA DE FUENTES ZONA/BARRIO: RESIDENCIAL NORTE', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
          const Text('PAILON', style: TextStyle(color: Colors.grey)),
          
          _buildLineaPunteada(),

          const Text('NIT', style: TextStyle(fontWeight: FontWeight.bold)),
          const Text('3858850017', style: TextStyle(color: Colors.grey)),
          const Text('FACTURA N°', style: TextStyle(fontWeight: FontWeight.bold)),
          const Text('438', style: TextStyle(color: Colors.grey)),
          const Text('CÓD. AUTORIZACIÓN', style: TextStyle(fontWeight: FontWeight.bold)),
          const Text(
            'BQcKhQnknLkRBNzUZBQjAwRTA3QTc=Q0FddIRMSExZVUFC4N0UxN0NFRDRDN',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          
          _buildLineaPunteada(),

          _buildFilaTexto('NOMBRE/RAZÓN SOCIAL:', 'PRUEBA-', alignRight: true),
          _buildFilaTexto('NIT/CI/CEX:', '555555', alignRight: true),
          _buildFilaTexto('COD. CLIENTE:', '555555', alignRight: true),
          _buildFilaTexto('FECHA DE EMISIÓN:', '06/11/2024 05:59 PM', alignRight: true),

          _buildLineaPunteada(),

          const Text('DETALLE', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Ruta: La Paz - Yacuiba Planta Inferior, número asiento: 4', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 4),
          Align(alignment: Alignment.centerLeft, child: Text('Unidad de Medida: 68', style: TextStyle(color: Colors.grey.shade600))),
          Align(alignment: Alignment.centerLeft, child: Text('1.00000 X 9.0000 - 0.00000', style: TextStyle(color: Colors.grey.shade600))),
          const SizedBox(height: 8),
          const Align(alignment: Alignment.centerRight, child: Text('100.00', style: TextStyle(fontWeight: FontWeight.bold))),

          _buildLineaPunteada(),

          _buildFilaTexto('SUBTOTAL Bs.', '100.00', isTotal: true),
          _buildFilaTexto('DESCUENTO Bs.', '0.00', isTotal: true),
          _buildFilaTexto('TOTAL Bs.', '100.00', isTotal: true),
          _buildFilaTexto('MONTO GIFT CARD Bs.', '0.0', isTotal: true),
          _buildFilaTexto('MONTO A PAGAR Bs', '100.00', isTotal: true, isBold: true),
          _buildFilaTexto('IMPORTE BASE CRÉDITO FISCAL', '100.00', isTotal: true, isBold: true),
          
          const SizedBox(height: 24),
          _buildBotonFinalizar(context),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // ==========================================================
  // 2. DISEÑO: VOUCHER (POR PAGAR)
  // ==========================================================

  PreferredSizeWidget _buildVoucherAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
    );
  }

  Widget _buildVoucherBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('VOUCHER', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          const Text('COMPROBANTE DE ENCOMIENDA', style: TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 16),

          _buildLineaPunteada(),

          _buildFilaTexto('NUMERO GUIA:', '2138588500172024', alignRight: true),
          _buildFilaTexto('RUTA:', 'La Paz - Yacuiba', alignRight: true),
          _buildFilaTexto('DESTINATARIO:', 'ROBERTO PEREZ', alignRight: true),
          _buildFilaTexto('NUMERO DOCUMENTO:', '986652', alignRight: true),
          _buildFilaTexto('CELULAR:', '77758547', alignRight: true),
          _buildFilaTexto('FECHA DE EMISIÓN:', '07/11/2024 12:46 PM', alignRight: true),
          _buildFilaTexto('DESCRIPCIÓN:', 'CAJA BLANCA', alignRight: true),
          _buildFilaTexto('TOTAL:', '120', alignRight: true),

          const SizedBox(height: 16),
          
          Row(
            children: [
              const SizedBox(width: 8),
              const Text('Son:', style: TextStyle(color: Colors.grey)),
              const SizedBox(width: 16),
              Text('Ciento Veinte /100 Bolivianos', style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),

          const SizedBox(height: 16),
          _buildLineaPunteada(),
          const SizedBox(height: 16),

          const Text(
            'ESTAMOS COMPROMETIDOS A ENTREGARLE SU\nENCOMIENDA DE FORMA SEGURA Y EFICIENTE.',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, height: 1.5),
          ),
          const SizedBox(height: 12),
          const Text(
            'Gracias por confiar en nuestro servicio de encomiendas.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          
          const SizedBox(height: 24),
          _buildBotonFinalizar(context),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // ==========================================================
  // WIDGETS AUXILIARES PARA EVITAR REPETIR CÓDIGO
  // ==========================================================

  Widget _buildBotonFinalizar(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0056A3),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        child: const Text('FINALIZAR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }

  Widget _buildLineaPunteada() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text('- ' * 40, maxLines: 1, style: const TextStyle(color: Colors.grey, overflow: TextOverflow.clip)),
    );
  }

  Widget _buildFilaTexto(String etiqueta, String valor, {bool alignRight = false, bool isTotal = false, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: isTotal ? MainAxisAlignment.center : MainAxisAlignment.end,
        children: [
          Expanded(
            flex: alignRight ? 5 : 2,
            child: Text(
              etiqueta,
              textAlign: alignRight ? TextAlign.right : TextAlign.center,
              style: TextStyle(fontWeight: isBold || alignRight ? FontWeight.bold : FontWeight.normal, fontSize: 13, color: isBold ? Colors.black : Colors.grey.shade700),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: alignRight ? 6 : 1,
            child: Text(
              valor,
              textAlign: alignRight ? TextAlign.left : TextAlign.center,
              style: TextStyle(color: isBold ? Colors.black : Colors.grey.shade600, fontSize: 13, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}