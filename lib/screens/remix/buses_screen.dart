import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BusesScreen extends StatefulWidget {
  const BusesScreen({super.key});

  @override
  State<BusesScreen> createState() => _BusesScreenState();
}

class _BusesScreenState extends State<BusesScreen> {
  // Estado simple para alternar vistas
  bool _isFormView = false;
  String _searchQuery = '';
  final _formKey = GlobalKey<FormState>();

  // Datos mockeados
  final List<Map<String, dynamic>> _buses = [
    {'id': '1', 'plate': '1234-ABC', 'type': 'Normal / 1 Piso', 'driver': 'Juan Pérez', 'capacity': 40, 'isLeito': false},
    {'id': '2', 'plate': '5678-XYZ', 'type': 'Leito / 2 Pisos', 'driver': 'Carlos Gómez', 'capacity': 60, 'isLeito': true},
  ];

  void _toggleView() {
    setState(() {
      _isFormView = !_isFormView;
    });
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _toggleView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // gray-50
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: Colors.black),
          onPressed: _isFormView ? _toggleView : () => Navigator.pop(context),
        ),
        title: Text(
          _isFormView ? 'Nuevo Bus' : 'Gestión de Buses',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: _isFormView ? _buildFormView() : _buildListView(),
      floatingActionButton: !_isFormView ? FloatingActionButton(
        onPressed: _toggleView,
        backgroundColor: Colors.blue[600],
        child: const Icon(LucideIcons.plus, color: Colors.white),
      ) : null,
    );
  }

  Widget _buildListView() {
    final filtered = _buses.where((b) => b['plate'].toLowerCase().contains(_searchQuery.toLowerCase()) || b['driver'].toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    return Column(
      children: [
        // Buscador
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Buscar por placa o conductor...',
              prefixIcon: const Icon(LucideIcons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: filtered.isEmpty 
          ? const Center(child: Text('No se encontraron buses', style: TextStyle(color: Colors.grey, fontSize: 16)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final bus = filtered[index];
                return _buildBusCard(bus);
              },
            ),
        ),
      ],
    );
  }

  Widget _buildBusCard(Map<String, dynamic> bus) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bus['plate'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: bus['isLeito'] ? Colors.purple[50] : Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      bus['type'], 
                      style: TextStyle(
                        fontSize: 10, 
                        color: bus['isLeito'] ? Colors.purple[700] : Colors.blue[700],
                        fontWeight: FontWeight.bold
                      )
                    ),
                  )
                ],
              ),
                  IconButton(
                    icon: Icon(LucideIcons.edit2, size: 18, color: Colors.blue[600]), 
                    onPressed: () {
                      // Simular edición: ir a la vista de form
                      setState(() {
                         _isFormView = true;
                      });
                    }
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.trash2, size: 18, color: Colors.red), 
                    onPressed: () {
                      // Simular eliminación
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          title: const Text('Eliminar Bus'),
                          content: Text('¿Estás seguro de que quieres eliminar el bus ${bus['plate']}?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx), 
                              child: const Text('Cancelar', style: TextStyle(color: Colors.grey))
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _buses.removeWhere((b) => b['id'] == bus['id']);
                                });
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Bus eliminado exitosamente'))
                                );
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        )
                      );
                    }
                  ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(LucideIcons.user, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(bus['driver'], style: TextStyle(color: Colors.grey[700], fontSize: 14)),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    const Icon(LucideIcons.armchair, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('${bus['capacity']} Asientos', style: TextStyle(color: Colors.grey[700], fontSize: 14)),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Vista de formulario muy simplificada
  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('PLACA (BOLIVIA)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 8),
                    TextFormField(
                      textCapitalization: TextCapitalization.characters,
                      validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                      decoration: InputDecoration(hintText: 'Ej. 1234-ABC', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))
                    ),
                    
                    const SizedBox(height: 16),
                    const Text('CONDUCTOR ASIGNADO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(LucideIcons.user, size: 16),
                      label: const Text('Seleccionar Conductor'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                      ),
                    ),

                    const SizedBox(height: 16),
                    const Text('TIPO DE BUS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: (){},
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blue[50], border: Border.all(color: Colors.blue[500]!), borderRadius: BorderRadius.circular(12)
                              ),
                              child: const Column(
                                children: [
                                  Icon(LucideIcons.bus, color: Colors.blue),
                                  SizedBox(height: 8),
                                  Text('Normal', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12))
                                ],
                              ),
                            ),
                          )
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: (){},
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white, border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(12)
                              ),
                              child: const Column(
                                children: [
                                  Icon(LucideIcons.bus, color: Colors.grey),
                                  SizedBox(height: 8),
                                  Text('Leito (2 Pisos)', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12))
                                ],
                              ),
                            ),
                          )
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: const Center(
                  child: Text('Configurador de Asientos\n(Omitido por brevedad en la demo)', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                ),
              )
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
                  onPressed: _toggleView,
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: const Text('Atrás', style: TextStyle(color: Colors.black)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _saveForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Registrar Bus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
   );
  }
}
