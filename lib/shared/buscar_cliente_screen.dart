import 'package:app_transporte/shared/reporte_pdf_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BuscarClienteScreen extends StatefulWidget {
  const BuscarClienteScreen({super.key});

  @override
  State<BuscarClienteScreen> createState() => _BuscarClienteScreenState();
}

class _BuscarClienteScreenState extends State<BuscarClienteScreen> {
  // Estados para controlar la UI
  String modoSeleccionado = 'NORMAL';
  String tipoDocumento = 'CI - CÉDULA DE IDENTIDAD';
  bool mostrarTarjetaCliente = false; // Controla si se muestra la tarjeta de resultado

  // Lista de opciones para el Dropdown (ComboBox)
  final List<String> opcionesDocumento = [
    'CI - CÉDULA DE IDENTIDAD',
    'CI EXTRANJERO',
    'PASAPORTE',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Emisión Factura',
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
            // --- 1. BOTONES SUPERIORES (NORMAL, 99001...) ---
            Row(
              children: [
                _buildModoButton('NORMAL'),
                _buildModoButton('99001'),
                _buildModoButton('99002'),
                _buildModoButton('99003'),
              ],
            ),
            const SizedBox(height: 24),

            // --- 2. COMBOBOX: TIPO DE DOCUMENTO ---
            DropdownButtonFormField<String>(
              value: tipoDocumento,
              decoration: InputDecoration(
                labelText: 'Tipo documento',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
              items: opcionesDocumento.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  tipoDocumento = newValue!;
                  // Al cambiar el tipo, ocultamos la tarjeta por si había una búsqueda anterior
                  mostrarTarjetaCliente = false; 
                });
              },
            ),
            const SizedBox(height: 16),

            // --- 3. INPUT: N° DE DOCUMENTO ---
            TextFormField(
              maxLength: 20, // Limita a 20 caracteres y muestra el contador 0/20 automáticamente
              keyboardType: tipoDocumento == 'CI - CÉDULA DE IDENTIDAD' 
                  ? TextInputType.number 
                  : TextInputType.text,
              inputFormatters: [
                // Si es CI, bloqueamos letras. Si no, permitimos todo.
                if (tipoDocumento == 'CI - CÉDULA DE IDENTIDAD')
                  FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                labelText: 'N° de Documento',
                prefixIcon: const Icon(Icons.badge, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // --- 4. INPUT: COMPLEMENTO ---
            TextFormField(
              maxLength: 2, // Limita a 2 caracteres
              textCapitalization: TextCapitalization.characters, // Lo vuelve mayúscula automático
              decoration: InputDecoration(
                labelText: 'Complemento',
                prefixIcon: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '2 A', 
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- 5. BOTÓN BUSCAR CLIENTE ---
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Simulamos que al presionar se encuentra el cliente
                  setState(() {
                    mostrarTarjetaCliente = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0056A3),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                child: const Text(
                  'BUSCAR CLIENTE',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- 6. TARJETA DE RESULTADO DEL CLIENTE (Condicional) ---
            if (mostrarTarjetaCliente) _buildTarjetaCliente(),
          ],
        ),
      ),
      
      // --- 7. BOTÓN FLOTANTE (FLECHA A LA DERECHA) ---
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // <-- AÑADE LA NAVEGACIÓN AQUÍ
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ReportePdfScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF0056A3),
        child: const Icon(Icons.arrow_forward, color: Colors.white),
      ),
    );
  }

  // --- WIDGET AUXILIAR: BOTONES SUPERIORES ---
  Widget _buildModoButton(String texto) {
    bool isSelected = modoSeleccionado == texto;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => modoSeleccionado = texto),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey.shade300,
              width: 1,
            ),
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

  // --- WIDGET AUXILIAR: TARJETA DEL CLIENTE ---
  Widget _buildTarjetaCliente() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA), // Un gris super claro
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
                // Icono de usuario
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey.shade300,
                  child: const Icon(Icons.person, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                
                // Datos del cliente
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
                
                // Icono de edición
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.black87),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          // Footer de la tarjeta con el celular
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8.0)),
            ),
            alignment: Alignment.center,
            child: Text(
              'Cel: 73225698',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }
}