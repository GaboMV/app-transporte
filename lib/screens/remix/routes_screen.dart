import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class RoutesScreen extends StatefulWidget {
  const RoutesScreen({super.key});

  @override
  State<RoutesScreen> createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  bool _isFormView = false;
  String _searchQuery = '';

  final List<Map<String, dynamic>> _routes = [
    {
      'id': '1',
      'origin': 'Santa Cruz',
      'destination': 'La Paz',
      'price': 150.0,
      'departureTime': '18:30',
      'arrivalTime': '06:00',
      'busPlate': '1234-ABC',
      'busType': '2 Pisos',
      'isActive': true,
    },
    {
      'id': '2',
      'origin': 'Cochabamba',
      'destination': 'Santa Cruz',
      'price': 80.0,
      'departureTime': '20:00',
      'arrivalTime': '05:30',
      'busPlate': '5678-XYZ',
      'busType': '1 Piso',
      'isActive': false,
    }
  ];

  void _toggleView() {
    setState(() => _isFormView = !_isFormView);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: Colors.black),
          onPressed: _isFormView ? _toggleView : () => Navigator.pop(context),
        ),
        title: Text(
          _isFormView ? 'Crear Nuevo Viaje' : 'Rutas y Viajes',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: _isFormView ? const _RouteForm() : _buildListView(),
      floatingActionButton: !_isFormView 
        ? FloatingActionButton(
            onPressed: _toggleView,
            backgroundColor: Colors.blue[600],
            child: const Icon(LucideIcons.plus, color: Colors.white),
          ) 
        : null,
    );
  }

  Widget _buildListView() {
    final filtered = _routes.where((r) => 
      r['origin'].toLowerCase().contains(_searchQuery.toLowerCase()) || 
      r['destination'].toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();

    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: '¿A dónde viaja el cliente?',
              prefixIcon: const Icon(LucideIcons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ),
        ),
        Expanded(
          child: filtered.isEmpty 
          ? const Center(child: Text('No se encontraron rutas', style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                return _buildRouteCard(filtered[index]);
              },
            ),
        ),
      ],
    );
  }

  Widget _buildRouteCard(Map<String, dynamic> route) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(route['origin'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(LucideIcons.arrowRight, size: 14, color: Colors.grey)),
                  Text(route['destination'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              Text('Bs ${route['price']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue[600])),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(LucideIcons.clock, size: 14, color: Colors.blue[500]),
                    const SizedBox(width: 4),
                    Text('${route['departureTime']} - ${route['arrivalTime']}', style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Icon(LucideIcons.bus, size: 14, color: Colors.blue[500]),
                    const SizedBox(width: 4),
                    Text('${route['busPlate']} (${route['busType']})', style: const TextStyle(fontSize: 12)),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: route['isActive'] ? Colors.green[50] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Row(
                  children: [
                    Icon(route['isActive'] ? LucideIcons.checkCircle : LucideIcons.alertCircle, size: 12, color: route['isActive'] ? Colors.green[600] : Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(route['isActive'] ? 'Activo' : 'Finalizado', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: route['isActive'] ? Colors.green[700] : Colors.grey[600])),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(icon: const Icon(LucideIcons.edit2, size: 16, color: Colors.grey), onPressed: (){}),
                  IconButton(icon: const Icon(LucideIcons.trash2, size: 16, color: Colors.grey), onPressed: (){}),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class _RouteForm extends StatefulWidget {
  const _RouteForm();

  @override
  State<_RouteForm> createState() => _RouteFormState();
}

class _RouteFormState extends State<_RouteForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedBus;
  TimeOfDay? _departureTime;
  TimeOfDay? _arrivalTime;

  void _showBusSelection() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Seleccionar Bus', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)), child: Icon(LucideIcons.bus, color: Colors.blue[600])),
                title: const Text('1234-ABC', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Conductor: Mario López'),
                trailing: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.green[100], borderRadius: BorderRadius.circular(8)), child: const Text('1 Piso', style: TextStyle(fontSize: 10, color: Colors.green))),
                onTap: () {
                  setState(() => _selectedBus = '1234-ABC');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[100]!)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(LucideIcons.mapPin, color: Colors.blue[500], size: 16),
                          const SizedBox(width: 8),
                          const Text('DETALLES DE RUTA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildInput('Origen', 'La Paz', isRequired: true)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildInput('Destino', 'Santa Cruz', isRequired: true)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTimePicker(
                              'Hora Salida', 
                              _departureTime, 
                              (time) => setState(() => _departureTime = time)
                            )
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTimePicker(
                              'Hora Llegada', 
                              _arrivalTime, 
                              (time) => setState(() => _arrivalTime = time)
                            )
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInput('Precio del Pasaje (Bs)', '0.00', isNumber: true, isRequired: true),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[100]!)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(LucideIcons.bus, color: Colors.blue[500], size: 16),
                          const SizedBox(width: 8),
                          const Text('ASIGNACIÓN DE BUS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_selectedBus == null)
                        GestureDetector(
                          onTap: _showBusSelection,
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.blue[200]!, style: BorderStyle.solid)),
                            child: Center(
                              child: Column(
                                children: [
                                  Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.blue[50], shape: BoxShape.circle), child: Icon(LucideIcons.alertCircle, color: Colors.blue[600])),
                                  const SizedBox(height: 12),
                                  const Text('No hay bus asignado', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  const SizedBox(height: 4),
                                  const Text('Toca para seleccionar un bus', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[200]!)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.blue[100], borderRadius: BorderRadius.circular(12)), child: Icon(LucideIcons.bus, color: Colors.blue[600])),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(_selectedBus!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      const Text('Conductor asignado', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                    ],
                                  )
                                ],
                              ),
                              TextButton(onPressed: _showBusSelection, child: const Text('Cambiar'))
                            ],
                          ),
                        )
                    ],
                  ),
                )
              ],
            ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.black12))),
          child: ElevatedButton.icon(
            onPressed: _selectedBus != null ? () {
              if (_formKey.currentState!.validate()) {
                if (_departureTime == null || _arrivalTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor seleccione horarios')));
                  return;
                }
                // Guardar ruta
              }
            } : null,
            icon: const Icon(LucideIcons.checkCircle, color: Colors.white),
            label: const Text('Crear y Guardar Ruta', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              minimumSize: const Size(double.infinity, 56),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePicker(String label, TimeOfDay? time, Function(TimeOfDay) onSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final selected = await showTimePicker(context: context, initialTime: time ?? TimeOfDay.now());
            if (selected != null) onSelected(selected);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(time != null ? time.format(context) : 'Seleccionar', style: TextStyle(color: time != null ? Colors.black : Colors.grey[600])),
                const Icon(LucideIcons.clock, size: 16, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInput(String label, String hint, {bool isNumber = false, bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 8),
        TextFormField(
          keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
          validator: (v) {
            if (isRequired && (v == null || v.isEmpty)) return 'Requerido';
            return null;
          },
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
