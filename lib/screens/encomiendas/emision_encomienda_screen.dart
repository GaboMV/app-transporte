import 'package:app_transporte/screens/shared/buscar_cliente_screen.dart';
import 'package:flutter/material.dart';

class EmisionEncomiendaScreen extends StatefulWidget {
  final String ruta; // Recibimos la ruta desde la pantalla anterior

  const EmisionEncomiendaScreen({super.key, required this.ruta});

  @override
  State<EmisionEncomiendaScreen> createState() => _EmisionEncomiendaScreenState();
}

class _EmisionEncomiendaScreenState extends State<EmisionEncomiendaScreen> {
  // Estado para el Radio Button (true = Pagado, false = Por pagar)
  bool isPagado = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Emisión Encomienda',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- 1. NÚMERO DE GUÍA (Prellenado) ---
            _buildTextField(
              label: 'Numero de Guia',
              prefixText: '#  ',
              initialValue: '1838588500172024',
              maxLength: 16,
            ),
            const SizedBox(height: 12),

            // --- 2. RUTA (Prellenado desde la tarjeta) ---
            _buildTextField(
              label: 'Ruta',
              prefixIcon: Icons.directions_car,
              initialValue: widget.ruta,
              maxLength: 17,
              readOnly: true, // No queremos que editen la ruta aquí
            ),
            const SizedBox(height: 12),

            // --- 3. DESTINATARIO ---
            _buildTextField(
              label: 'Destinatario',
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: 12),

            // --- 4. CI Y CELULAR (Misma fila) ---
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'CI',
                    prefixIcon: Icons.badge,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    label: 'Celular',
                    prefixIcon: Icons.phone_android,
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // --- 5. DESCRIPCIÓN ---
            _buildTextField(
              label: 'Descripción Encomienda',
              prefixIcon: Icons.inventory_2,
            ),
            const SizedBox(height: 12),

            // --- 6. PRECIO Y DESCUENTO (Misma fila) ---
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'Precio Unitario',
                    prefixText: 'Bs  ',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    label: 'Descuento',
                    prefixText: 'Bs  ',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // --- 7. MONTO TOTAL ---
            _buildTextField(
              label: 'Monto Total',
              prefixText: 'Bs  ',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),

            // --- 8. RADIO BUTTONS (Pagado / Por pagar) ---
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Pagado', style: TextStyle(fontSize: 14)),
                    value: true,
                    groupValue: isPagado,
                    activeColor: const Color(0xFFF3A953), // Naranja del diseño
                    contentPadding: EdgeInsets.zero,
                    onChanged: (value) {
                      setState(() {
                        isPagado = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Por pagar', style: TextStyle(fontSize: 14)),
                    value: false,
                    groupValue: isPagado,
                    activeColor: const Color(0xFFF3A953),
                    contentPadding: EdgeInsets.zero,
                    onChanged: (value) {
                      setState(() {
                        isPagado = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- 9. BOTÓN DE EMISIÓN ---
            ElevatedButton.icon(
              onPressed: () {
                // Ahora SIEMPRE vamos a Buscar Cliente, 
                // pero le avisamos si NO está pagado (!isPagado) para que sea Voucher
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BuscarClienteScreen(
                      isVoucher: !isPagado, // Si isPagado es falso, isVoucher es true
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0056A3),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
              label: const Text(
                'EMITIR FACTURA Y DESPACHO',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              icon: const Icon(Icons.send, color: Colors.white),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // --- WIDGET AUXILIAR PARA GENERAR LOS INPUTS ---
  // Esto nos ahorra escribir cientos de líneas repetidas
  Widget _buildTextField({
    required String label,
    IconData? prefixIcon,
    String? prefixText,
    String? initialValue,
    int? maxLength,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      initialValue: initialValue,
      readOnly: readOnly,
      maxLength: maxLength,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600),
        // Si mandamos un ícono, lo dibuja. Si no, revisa si mandamos un texto (como "#" o "Bs")
        prefixIcon: prefixIcon != null 
            ? Icon(prefixIcon, color: Colors.grey.shade600) 
            : (prefixText != null 
                ? Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 14.0, right: 8.0),
                    child: Text(prefixText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ) 
                : null),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        counterText: '', // Ocultamos el contador por defecto de Flutter para replicar el diseño limpio
      ),
    );
  }
}
