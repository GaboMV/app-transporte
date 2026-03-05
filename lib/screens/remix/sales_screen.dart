import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

// Este archivo es una adaptación del SalesModule (Venta de pasajes).
// Por la complejidad que tiene (4 pasos: Ruta, Asientos, Facturación y Ticket PDF)
// se ha implementado la estructura visual básica. Para el funcionamiento real 
// habría que separar esto en múltiples pantallas o usar un PageView con un 
// manejador de estado más robusto (como Riverpod/Provider).

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  int _currentStep = 1;
  
  // Mocks de selección
  String? _selectedRoute;
  double _routePrice = 0.0;
  List<String> _selectedSeats = [];
  Map<String, dynamic>? _invoiceData;
  int _selectedFloor = 1;

  // Form parameters
  String _paymentMethod = 'EFECTIVO';
  double _amountReceived = 0.0;
  double _discount = 0.0;

  final _creditCardFormatter = MaskTextInputFormatter(
    mask: '#### #### #### ####', 
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy
  );

  void _nextStep() {
    setState(() => _currentStep++);
  }

  void _prevStep() {
    setState(() => _currentStep--);
  }

  void _finish() {
    setState(() {
      _currentStep = 1;
      _selectedRoute = null;
      _selectedSeats = [];
      _invoiceData = null;
    });
    Navigator.pop(context); // Volver al inicio
  }

  @override
  Widget build(BuildContext context) {
    // Si estamos en el paso de Ticket (4), no mostramos AppBar normal
    if (_currentStep == 4) {
      return _buildInvoiceSuccess();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // gray-50
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: Colors.black),
          onPressed: _currentStep > 1 ? _prevStep : () => Navigator.pop(context),
        ),
        title: Text(
          _currentStep == 1 ? 'Seleccionar Viaje' :
          _currentStep == 2 ? 'Seleccionar Asientos' : 'Facturación',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              children: [
                Expanded(child: Container(height: 4, color: _currentStep >= 1 ? Colors.blue : Colors.grey[200])),
                const SizedBox(width: 8),
                Expanded(child: Container(height: 4, color: _currentStep >= 2 ? Colors.blue : Colors.grey[200])),
                const SizedBox(width: 8),
                Expanded(child: Container(height: 4, color: _currentStep >= 3 ? Colors.blue : Colors.grey[200])),
              ],
            ),
          ),
        ),
      ),
      body: _buildStepContent(),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return _buildStep1_SelectRoute();
      case 2:
        return _buildStep2_SelectSeats();
      case 3:
        return _buildStep3_Billing();
      default:
        return Container();
    }
  }

  // --- PASO 1: SELECCIONAR RUTA ---
  Widget _buildStep1_SelectRoute() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: '¿A dónde viaja el cliente?',
              prefixIcon: const Icon(LucideIcons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildRouteItem('La Paz', 'Santa Cruz', '18:00', 'Leito', 150),
              _buildRouteItem('Santa Cruz', 'Cochabamba', '20:30', 'Normal', 80),
              _buildRouteItem('Cochabamba', 'Oruro', '22:00', 'Semi-Cama', 50),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRouteItem(String origin, String dest, String time, String type, double price) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRoute = '$origin - $dest';
          _routePrice = price;
        });
        _nextStep();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(origin, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(LucideIcons.arrowRight, size: 16, color: Colors.grey),
                    ),
                    Text(dest, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(LucideIcons.clock, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(time, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(width: 16),
                    const Icon(LucideIcons.bus, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(type, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Bs $price', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20)),
                const Text('Seleccionar', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            )
          ],
        ),
      ),
    );
  }

  // --- PASO 2: SELECCIONAR ASIENTOS ---
  Widget _buildStep2_SelectSeats() {
    return Column(
      children: [
        // Tab simulado
        Container(
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedFloor = 1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: _selectedFloor == 1 ? Colors.blue : Colors.transparent, width: 2))
                    ),
                    child: Text('PISO INFERIOR', textAlign: TextAlign.center, style: TextStyle(color: _selectedFloor == 1 ? Colors.blue : Colors.grey, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedFloor = 2),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: _selectedFloor == 2 ? Colors.blue : Colors.transparent, width: 2))
                    ),
                    child: Text('PISO SUPERIOR', textAlign: TextAlign.center, style: TextStyle(color: _selectedFloor == 2 ? Colors.blue : Colors.grey, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Leyenda
        Container(
          color: Colors.grey[50],
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(Colors.white, 'Libre', true),
              const SizedBox(width: 16),
              _buildLegendItem(Colors.blue, 'Seleccionado', false),
              const SizedBox(width: 16),
              _buildLegendItem(Colors.grey[300]!, 'Ocupado', false),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  children: [
                    const Text('FRENTE', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 24),
                    // Asientos simulados
                    if (_selectedFloor == 1) ...[
                      _buildSeatRow(['1', '2'], ['3', '4']),
                      _buildSeatRow(['5', 'ocupado'], ['7', '8']),
                      _buildSeatRow(['9', '10'], ['11', '12']),
                      _buildSeatRow(['13', 'ocupado'], ['15', '16']),
                    ] else ...[
                      _buildSeatRow(['17', '18'], ['19', '20']),
                      _buildSeatRow(['21', '22'], ['23', '24']),
                      _buildSeatRow(['25', '26'], ['27', '28']),
                      _buildSeatRow(['29', '30'], ['31', '32']),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  onPressed: _prevStep,
                  child: const Text('Atrás', style: TextStyle(fontSize: 16, color: Colors.black)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (_selectedSeats.isEmpty) {
                      setState(() => _selectedSeats = ['1']); // Seleccionar uno por defecto pa la demo
                    }
                    _nextStep();
                  },
                  child: Text('Continuar (${_selectedSeats.length > 0 ? _selectedSeats.length : "1 default"})', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label, bool border) {
    return Row(
      children: [
        Container(
          width: 12, height: 12,
          decoration: BoxDecoration(
            color: color,
            border: border ? Border.all(color: Colors.grey[400]!) : null,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1)),
      ],
    );
  }

  Widget _buildSeatRow(List<String> left, List<String> right) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSeat(left[0]),
          const SizedBox(width: 8),
          _buildSeat(left[1]),
          const SizedBox(width: 40), // Pasillo
          _buildSeat(right[0]),
          const SizedBox(width: 8),
          _buildSeat(right[1]),
        ],
      ),
    );
  }

  Widget _buildSeat(String id) {
    bool isOcupado = id == 'ocupado';
    bool isSelected = _selectedSeats.contains(id);
    
    return GestureDetector(
      onTap: () {
        if (!isOcupado) {
          setState(() {
            if (isSelected) {
              _selectedSeats.remove(id);
            } else {
              _selectedSeats.add(id);
            }
          });
        }
      },
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: isOcupado ? Colors.grey[300] : (isSelected ? Colors.blue : Colors.white),
          border: Border.all(color: isOcupado ? Colors.transparent : (isSelected ? Colors.blue : Colors.grey[400]!)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Icon(
            LucideIcons.armchair, 
            color: isOcupado ? Colors.grey[500] : (isSelected ? Colors.white : Colors.grey[400]),
            size: 24,
          ),
        ),
      ),
    );
  }

  // --- PASO 3: FACTURACION ---
  Widget _buildStep3_Billing() {
    double subtotal = _selectedSeats.length * _routePrice;
    double total = subtotal - _discount;
    if (total < 0) total = 0;
    double change = _paymentMethod == 'EFECTIVO' ? (_amountReceived - total) : 0;
    if (change < 0) change = 0;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Pasajeros
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Pasajeros (${_selectedSeats.length > 0 ? _selectedSeats.length : 1})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Datos del primer pasajero copiados a factura')));
                          },
                          child: const Text('Copiar 1º a Factura', style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...(_selectedSeats.isEmpty ? ['1'] : _selectedSeats).map((seatId) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ASIENTO $seatId', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                          const SizedBox(height: 8),
                          OutlinedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  title: const Text('Asignar Pasajero'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(decoration: InputDecoration(hintText: 'CI', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
                                      const SizedBox(height: 12),
                                      TextField(decoration: InputDecoration(hintText: 'Nombre y Apellidos', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pasajero asignado al asiento $seatId')));
                                      },
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                      child: const Text('Guardar', style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                )
                              );
                            },
                            icon: const Icon(LucideIcons.search, size: 16),
                            label: const Text('Buscar Pasajero o Crear Nuevo'),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                              foregroundColor: Colors.grey[600],
                            ),
                          )
                        ],
                      ),
                    )).toList()
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Datos Factura
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Datos para la Factura', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    const TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'NIT / CI', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    const TextField(decoration: InputDecoration(labelText: 'Razón Social', border: OutlineInputBorder())),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Formas de pago
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Método de Pago', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildPaymentOption('EFECTIVO', LucideIcons.banknote),
                        const SizedBox(width: 8),
                        _buildPaymentOption('TARJETA', LucideIcons.creditCard),
                        const SizedBox(width: 8),
                        _buildPaymentOption('QR', LucideIcons.qrCode),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_paymentMethod == 'EFECTIVO') ...[
                      TextField(
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Monto Recibido (Bs)', border: OutlineInputBorder()),
                        onChanged: (val) => setState(() => _amountReceived = double.tryParse(val) ?? 0.0),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Cambio:', style: TextStyle(fontSize: 16, color: Colors.grey)),
                          Text('Bs ${change.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                        ]
                      )
                    ] else if (_paymentMethod == 'TARJETA') ...[
                      TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [_creditCardFormatter],
                        decoration: const InputDecoration(labelText: 'Número de Tarjeta', hintText: '0000 0000 0000 0000', border: OutlineInputBorder()),
                      ),
                    ],
                    const SizedBox(height: 16),
                    TextField(
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Descuento (Bs)', border: OutlineInputBorder()),
                      onChanged: (val) => setState(() => _discount = double.tryParse(val) ?? 0.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Resumen
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Subtotal'), Text('Bs ${subtotal.toStringAsFixed(2)}')]),
                    if (_discount > 0)
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Descuento', style: TextStyle(color: Colors.red)), Text('- Bs ${_discount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.red))]),
                    const Divider(),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      const Text('Total a Pagar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), 
                      Text('Bs ${total.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.blue[600]))
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _prevStep,
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: const Text('Atrás', style: TextStyle(fontSize: 16, color: Colors.black)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _nextStep,
                  icon: const Icon(LucideIcons.checkCircle, color: Colors.white),
                  label: const Text('EMITIR FACTURA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption(String method, IconData icon) {
    bool isSelected = _paymentMethod == method;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _paymentMethod = method),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue[50] : Colors.white,
            border: Border.all(color: isSelected ? Colors.blue : Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
              const SizedBox(height: 4),
              Text(method, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? Colors.blue : Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  // --- PASO 4: RECIBO ---
  Widget _buildInvoiceSuccess() {
    double subtotal = (_selectedSeats.isEmpty ? 1 : _selectedSeats.length) * _routePrice;
    double total = subtotal - _discount;
    if (total < 0) total = 0;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        leading: IconButton(icon: const Icon(LucideIcons.chevronLeft, color: Colors.white), onPressed: _finish),
        title: const Text('Reporte PDF', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.download, color: Colors.white), 
            onPressed: () { 
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Descargando Factura PDF...'))); 
            }
          ),
          IconButton(
            icon: const Icon(LucideIcons.mail, color: Colors.white), 
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Factura enviada por correo al cliente'))); 
            }
          ),
          IconButton(
            icon: const Icon(Icons.message, color: Colors.white), // Usando material icon genérico para WhatsApp
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Redirigiendo a WhatsApp...'))); 
            }
          ),
        ],
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          color: Colors.white,
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: Text('FACTURA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
              const Center(child: Text('CON DERECHO A CRÉDITO FISCAL', style: TextStyle(fontWeight: FontWeight.bold))),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              const Text('NIT: 3858850017'),
              const Text('FACTURA N°: 1234'),
              const SizedBox(height: 8),
              Text('RUTA: ${_selectedRoute ?? "Ruta Ejemplo"}'),
              Text('ASIENTO(S): ${_selectedSeats.isEmpty ? "1" : _selectedSeats.join(", ")}'),
              Text('FECHA: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'),
              const SizedBox(height: 32),
              const Center(child: Text('--- DETALLE ---')),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Pagado:', style: TextStyle(fontSize: 16)),
                  Text('Bs ${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue)),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[800],
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: _finish,
           icon: const Text('VOLVER AL INICIO', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          label: const Icon(LucideIcons.arrowRight, color: Colors.white),
        ),
      ),
    );
  }
}
