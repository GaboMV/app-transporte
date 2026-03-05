import 'package:app_transporte/screens/transporte/resumen_asientos_screen.dart';
import 'package:flutter/material.dart';

class MapaAsientosScreen extends StatefulWidget {
  const MapaAsientosScreen({super.key});

  @override
  State<MapaAsientosScreen> createState() => _MapaAsientosScreenState();
}

class _MapaAsientosScreenState extends State<MapaAsientosScreen> {
  bool isPisoInferior = true;
  Set<int> asientosSeleccionados = {}; // Aquí guardamos los asientos que elijas

  // Función para seleccionar/deseleccionar un asiento
  void _toggleAsiento(int numero) {
    setState(() {
      if (asientosSeleccionados.contains(numero)) {
        asientosSeleccionados.remove(numero);
      } else {
        asientosSeleccionados.add(numero);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Transporte Vista',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // --- SELECTOR DE PISOS ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isPisoInferior = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: isPisoInferior ? Colors.blue : Colors.grey.shade300,
                          width: isPisoInferior ? 2 : 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'PISO INFERIOR',
                        style: TextStyle(
                          color: isPisoInferior ? Colors.blue : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isPisoInferior = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: !isPisoInferior ? Colors.blue : Colors.grey.shade300,
                          width: !isPisoInferior ? 2 : 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'PISO SUPERIOR',
                        style: TextStyle(
                          color: !isPisoInferior ? Colors.blue : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // --- CONTENEDOR DEL BUS ---
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text('FRENTE', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 16),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Ventana', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        Text('Pasillo', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        SizedBox(width: 40),
                        Text('Pasillo', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        Text('Ventana', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.verified_user_rounded, size: 50, color: Color(0xFF4A6572)),
                        isPisoInferior 
                            ? Column(
                                children: [
                                  const Text('Baño', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                  Icon(Icons.wc, size: 40, color: Colors.grey.shade600),
                                ],
                              )
                            : Column(
                                children: [
                                  const Text('Entrada', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                  Icon(Icons.stairs, size: 40, color: Colors.grey.shade600),
                                ],
                              ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Generador dinámico de asientos (50 por piso)
                    ..._generarAsientos(isPisoInferior ? 0 : 50),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (asientosSeleccionados.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Seleccione al menos un asiento')),
            );
            return;
          }
          // Navegamos a la siguiente pantalla pasando la cantidad de asientos
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResumenAsientosScreen(
                cantidadAsientos: asientosSeleccionados.length,
                horario: '07/11/24 00:00 - 07/11/24 00:00',
                ruta: 'La Paz - Oruro', // Dato de ejemplo para compilar
              ),
            ),
          );
        },
        backgroundColor: const Color(0xFF0056A3),
        child: const Icon(Icons.save, color: Colors.white),
      ),
    );
  }

  // Lógica para generar las filas de 4 asientos hasta llegar a 50
  List<Widget> _generarAsientos(int offset) {
    List<Widget> filas = [];
    int totalAsientos = 50;
    
    // Generamos filas de 4 (12 filas = 48 asientos, y una última de 2)
    for (int i = 0; i < 13; i++) {
      int base = offset + (i * 4);
      
      int as1 = base + 1;
      int as2 = base + 2;
      int as3 = base + 3;
      int as4 = base + 4;

      if (as1 > offset + totalAsientos) break;

      filas.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (as1 <= offset + totalAsientos) _buildAsientoTappable(as1),
                  const SizedBox(width: 8),
                  if (as2 <= offset + totalAsientos) _buildAsientoTappable(as2),
                ],
              ),
              const SizedBox(width: 30),
              Row(
                children: [
                  if (as3 <= offset + totalAsientos) _buildAsientoTappable(as3),
                  const SizedBox(width: 8),
                  if (as4 <= offset + totalAsientos) _buildAsientoTappable(as4),
                ],
              ),
            ],
          ),
        ),
      );
    }
    return filas;
  }

  // Asiento que reacciona al toque
  Widget _buildAsientoTappable(int numero) {
    bool isSelected = asientosSeleccionados.contains(numero);
    
    // Por ahora simulamos que todos están libres (verde) a menos que los selecciones (naranja)
    Color colorFondo = isSelected ? const Color(0xFFF3A953) : const Color(0xFF5A8F3F);

    return GestureDetector(
      onTap: () => _toggleAsiento(numero),
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: colorFondo,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(8),
            bottom: Radius.circular(4),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          numero.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
