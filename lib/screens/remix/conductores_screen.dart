import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ConductoresScreen extends StatefulWidget {
  const ConductoresScreen({super.key});

  @override
  State<ConductoresScreen> createState() => _ConductoresScreenState();
}

class _ConductoresScreenState extends State<ConductoresScreen> {
  bool _isFormView = false;
  String _searchQuery = '';
  final _formKey = GlobalKey<FormState>();

  // Datos mockeados
  final List<Map<String, dynamic>> _conductores = [
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
      backgroundColor: const Color(0xFFF5F5F7), // bg-[#F5F5F7]
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _isFormView ? Colors.blue[600] : const Color(0xFFF5F5F7),
        leading: IconButton(
          icon: Icon(LucideIcons.chevronLeft, color: _isFormView ? Colors.white : Colors.black),
          onPressed: _isFormView ? _toggleView : () => Navigator.pop(context),
        ),
        title: Text(
          _isFormView ? 'Nuevo Conductor' : 'Conductores',
          style: TextStyle(
            color: _isFormView ? Colors.white : Colors.black,
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
    final filtered = _conductores.where((c) => 
      c['name'].toLowerCase().contains(_searchQuery.toLowerCase()) || 
      c['ci'].contains(_searchQuery)
    ).toList();

    return Column(
      children: [
        // Buscador
        Container(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Buscar por nombre o CI...',
              prefixIcon: const Icon(LucideIcons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final conductor = filtered[index];
                return _buildCard(conductor);
              },
            ),
        ),
      ],
    );
  }

  Widget _buildCard(Map<String, dynamic> conductor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(color: Colors.blue[50], shape: BoxShape.circle),
                child: Center(child: Icon(LucideIcons.user, color: Colors.blue[600], size: 28)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(conductor['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(LucideIcons.scanLine, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('CI: ${conductor['ci']}', style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(icon: Icon(LucideIcons.edit2, size: 20, color: Colors.blue[600]), onPressed: (){}),
                  IconButton(icon: const Icon(LucideIcons.trash2, size: 20, color: Colors.red), onPressed: (){}),
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                      child: const Icon(LucideIcons.phone, size: 14, color: Colors.grey),
                    ),
                    const SizedBox(width: 8),
                    Text(conductor['phone'], style: TextStyle(color: Colors.grey[800], fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                      child: const Icon(LucideIcons.mail, size: 14, color: Colors.grey),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(conductor['email'], style: TextStyle(color: Colors.grey[800], fontSize: 14, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
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
                  _buildInput(label: 'NOMBRE COMPLETO', icon: LucideIcons.user, hint: 'Ej. Juan Pérez Mamani', isRequired: true, textCapitalization: TextCapitalization.words),
                  const SizedBox(height: 20),
                  _buildInput(label: 'CÉDULA DE IDENTIDAD (CI)', icon: LucideIcons.scanLine, hint: 'Ej. 1234567', isNumber: true, isRequired: true),
                  const SizedBox(height: 20),
                  _buildInput(label: 'TELÉFONO / CELULAR', icon: LucideIcons.phone, hint: 'Ej. 70012345', isPhone: true, isRequired: true),
                  const SizedBox(height: 20),
                  _buildInput(label: 'CORREO ELECTRÓNICO', icon: LucideIcons.mail, hint: 'Ej. conductor@example.com', isEmail: true),
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
                  elevation: 4,
                  shadowColor: Colors.blue[200]
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
    required IconData icon, 
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
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5)),
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
            prefixIcon: Icon(icon, color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.blue[400]!),
            ),
          ),
        ),
      ],
    );
  }
}
