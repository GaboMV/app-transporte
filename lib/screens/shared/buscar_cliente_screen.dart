import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'reporte_pdf_screen.dart';

class BuscarClienteScreen extends StatefulWidget {
  // Añadimos esta variable para saber si venimos de un "Por pagar"
  final bool isVoucher; 

  const BuscarClienteScreen({
    super.key, 
    this.isVoucher = false, // Por defecto es false (Factura normal)
  });

  @override
  State<BuscarClienteScreen> createState() => _BuscarClienteScreenState();
}

class _BuscarClienteScreenState extends State<BuscarClienteScreen> {
  String modoSeleccionado = 'NORMAL';
  String tipoDocumento = 'CI - CÉDULA DE IDENTIDAD';
  bool mostrarTarjetaCliente = false;

  final TextEditingController _documentoController = TextEditingController();
  final TextEditingController _razonSocialController = TextEditingController();

  final List<String> opcionesDocumento = [
    'CI - CÉDULA DE IDENTIDAD',
    'CI EXTRANJERO',
    'PASAPORTE',
  ];

  @override
  void dispose() {
    _documentoController.dispose();
    _razonSocialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Emisión Factura', // O "Buscar Cliente", según prefieras
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.fingerprint, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _buildModoButton('NORMAL'),
                _buildModoButton('99001'),
                _buildModoButton('99002'),
                _buildModoButton('99003'),
              ],
            ),
            const SizedBox(height: 24),

            DropdownButtonFormField<String>(
              value: tipoDocumento,
              decoration: InputDecoration(
                labelText: 'Tipo documento',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
              items: opcionesDocumento.map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  tipoDocumento = newValue!;
                  mostrarTarjetaCliente = false; 
                });
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _documentoController,
              maxLength: 20,
              keyboardType: tipoDocumento == 'CI - CÉDULA DE IDENTIDAD' ? TextInputType.number : TextInputType.text,
              inputFormatters: [
                if (tipoDocumento == 'CI - CÉDULA DE IDENTIDAD') FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                labelText: 'N° de Documento',
                prefixIcon: const Icon(Icons.badge, color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
              ),
            ),
            const SizedBox(height: 8),

            TextFormField(
              controller: _razonSocialController,
              decoration: InputDecoration(
                labelText: 'Razón Social / Nombre',
                prefixIcon: const Icon(Icons.person, color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              maxLength: 2,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                labelText: 'Complemento',
                prefixIcon: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: Colors.grey.shade600, borderRadius: BorderRadius.circular(4)),
                  child: const Text('2 A', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
              ),
            ),
            const SizedBox(height: 16),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    mostrarTarjetaCliente = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0056A3),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                ),
                child: const Text('BUSCAR CLIENTE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),

            if (mostrarTarjetaCliente) _buildTarjetaCliente(),
          ],
        ),
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              // AQUÍ LE PASAMOS LA VARIABLE A LA PANTALLA DEL PDF
              builder: (context) => ReportePdfScreen(isVoucher: widget.isVoucher),
            ),
          );
        },
        backgroundColor: const Color(0xFF0056A3),
        child: const Icon(Icons.arrow_forward, color: Colors.white),
      ),
    );
  }

  Widget _buildModoButton(String texto) {
    bool isSelected = modoSeleccionado == texto;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            modoSeleccionado = texto;
            if (texto == '99001' || texto == '90001' || texto == '9901') {
              _documentoController.text = texto;
              _razonSocialController.text = 'NOMBRE ENTIDAD EXTRANJERA';
            } else if (texto == '99002' || texto == '90002') {
              _documentoController.text = texto;
              _razonSocialController.text = 'SIN NOMBRE';
            } else if (texto == '99003' || texto == '90003') {
              _documentoController.text = texto;
              _razonSocialController.text = 'VENTAS MENORES';
            } else {
              // Si es 'NORMAL', no borramos lo que el usuario haya escrito
              // Opcionalmente se podría limpiar: 
              // _documentoController.clear();
              // _razonSocialController.clear();
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade300, width: 1),
          ),
          alignment: Alignment.center,
          child: Text(
            texto,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.grey.shade600,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTarjetaCliente() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey.shade300,
                  child: const Icon(Icons.person, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('PRUEBA-', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 4),
                      const Text('555555', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text('prueba@gmail.com', style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                IconButton(icon: const Icon(Icons.edit, color: Colors.black87), onPressed: () {}),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8.0)),
            ),
            alignment: Alignment.center,
            child: Text('Cel: 73225698', style: TextStyle(color: Colors.grey.shade600)),
          ),
        ],
      ),
    );
  }
}
