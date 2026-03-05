import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DriversScreen extends StatefulWidget {
  const DriversScreen({super.key});

  @override
  State<DriversScreen> createState() => _DriversScreenState();
}

class _DriversScreenState extends State<DriversScreen> {
  bool _isFormView = false;
  String _searchQuery = '';
  final _formKey = GlobalKey<FormState>();

  // Datos mockeados
  final List<Map<String, dynamic>> _drivers = [
    {'id': '1', 'name': 'Pedro López', 'ci': '9876543', 'phone': '70098765', 'email': 'pedro@example.com'},
    {'id': '2', 'name': 'Mario Gómez', 'ci': '1234432', 'phone': '71122334', 'email': 'mario@example.com'},
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
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: Colors.black),
          onPressed: _isFormView ? _toggleView : () => Navigator.pop(context),
        ),
        title: Text(
          _isFormView ? 'Nuevo Conductor (Driver)' : 'Conductores (Drivers)',
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
    final filtered = _drivers.where((d) => 
      d['name'].toLowerCase().contains(_searchQuery.toLowerCase()) || 
      d['ci'].contains(_searchQuery)
    ).toList();

    return Column(
      children: [
        // Buscador
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Buscar por nombre o CI...',
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
          ? const Center(child: Text('No se encontraron conductores', style: TextStyle(color: Colors.grey, fontSize: 16)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final driver = filtered[index];
                return _buildCard(driver);
              },
            ),
        ),
      ],
    );
  }

  Widget _buildCard(Map<String, dynamic> driver) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(color: Colors.blue[50], shape: BoxShape.circle),
                child: Center(child: Icon(LucideIcons.user, color: Colors.blue[600], size: 24)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(driver['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(LucideIcons.scanLine, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('CI: ${driver['ci']}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(LucideIcons.phone, size: 14, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(driver['phone'], style: TextStyle(color: Colors.grey[800], fontSize: 14)),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    const Icon(LucideIcons.mail, size: 14, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(child: Text(driver['email'], style: TextStyle(color: Colors.grey[800], fontSize: 14), overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(icon: const Icon(LucideIcons.edit2, size: 18, color: Colors.grey), onPressed: (){}),
              IconButton(icon: const Icon(LucideIcons.trash2, size: 18, color: Colors.grey), onPressed: (){}),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFormView() {
    return Container(
      color: Colors.white,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  _buildInput(label: 'Nombre Completo', hint: 'Ej. Juan Pérez', isRequired: true, textCapitalization: TextCapitalization.words),
                  const SizedBox(height: 20),
                  _buildInput(label: 'Cédula de Identidad (CI)', hint: 'Ej. 1234567', isNumber: true, isRequired: true),
                  const SizedBox(height: 20),
                  _buildInput(label: 'Teléfono / Celular', hint: 'Ej. 70012345', isPhone: true, isRequired: true),
                  const SizedBox(height: 20),
                  _buildInput(label: 'Correo Electrónico', hint: 'Ej. conductor@example.com', isEmail: true),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton.icon(
                onPressed: _saveForm,
                icon: const Icon(LucideIcons.checkCircle, color: Colors.white),
                label: const Text('Guardar Conductor', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  minimumSize: const Size(double.infinity, 56),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInput({
    required String label, 
    required String hint, 
    bool isNumber = false, 
    bool isPhone = false, 
    bool isEmail = false, 
    bool isRequired = false,
    TextCapitalization textCapitalization = TextCapitalization.none
  }) {
    TextInputType keyboardType = TextInputType.text;
    if (isNumber) keyboardType = TextInputType.number;
    if (isPhone) keyboardType = TextInputType.phone;
    if (isEmail) keyboardType = TextInputType.emailAddress;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5)),
        const SizedBox(height: 8),
        TextFormField(
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          validator: (value) {
            if (isRequired && (value == null || value.isEmpty)) {
              return 'Este campo es requerido';
            }
            if (isEmail && value != null && value.isNotEmpty && !value.contains('@')) {
              return 'Correo electrónico inválido';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
