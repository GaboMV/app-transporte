import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  String _searchQuery = '';
  
  // Datos mockeados
  final List<Map<String, dynamic>> _clients = [
    {'id': '1', 'fullName': 'Juan Pérez', 'docType': 'CI', 'docNum': '1234567', 'phone': '70012345', 'email': 'juan@example.com'},
    {'id': '2', 'fullName': 'Empresa S.A.', 'docType': 'NIT', 'docNum': '1020304050', 'phone': '', 'email': 'contacto@empresa.com'},
  ];

  void _showFormModal({Map<String, dynamic>? client}) {
    showDialog(
      context: context,
      builder: (context) => _ClientFormDialog(client: client),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _clients.where((c) => 
      c['fullName'].toLowerCase().contains(_searchQuery.toLowerCase()) || 
      c['docNum'].contains(_searchQuery)
    ).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Clientes',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o documento...',
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
            ? const Center(child: Text('No se encontraron clientes', style: TextStyle(color: Colors.grey, fontSize: 16)))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final client = filtered[index];
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
                            Row(
                              children: [
                                Container(
                                  width: 40, height: 40,
                                  decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
                                  child: const Icon(LucideIcons.user, color: Colors.grey, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(client['fullName'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    Text('${client['docType']}: ${client['docNum']}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(LucideIcons.edit2, size: 18, color: Colors.grey),
                              onPressed: () => _showFormModal(client: client),
                            )
                          ],
                        ),
                        if (client['phone'].isNotEmpty || client['email'].isNotEmpty) ...[
                          const SizedBox(height: 16),
                          if (client['phone'].isNotEmpty) Row(
                            children: [
                              const Icon(LucideIcons.phone, size: 14, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(client['phone'], style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                            ],
                          ),
                          if (client['email'].isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(LucideIcons.mail, size: 14, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(client['email'], style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                              ],
                            ),
                          ]
                        ]
                      ],
                    ),
                  );
                },
              ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormModal(),
        backgroundColor: Colors.blue[600],
        child: const Icon(LucideIcons.plus, color: Colors.white),
      ),
    );
  }
}

class _ClientFormDialog extends StatefulWidget {
  final Map<String, dynamic>? client;

  const _ClientFormDialog({this.client});

  @override
  State<_ClientFormDialog> createState() => _ClientFormDialogState();
}

class _ClientFormDialogState extends State<_ClientFormDialog> {
  final _formKey = GlobalKey<FormState>();
  
  late String _docType;
  late TextEditingController _docNumCtrl;
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();
    _docType = widget.client?['docType'] ?? 'CI';
    _docNumCtrl = TextEditingController(text: widget.client?['docNum'] ?? '');
    _nameCtrl = TextEditingController(text: widget.client?['fullName'] ?? '');
    _phoneCtrl = TextEditingController(text: widget.client?['phone'] ?? '');
    _emailCtrl = TextEditingController(text: widget.client?['email'] ?? '');
  }

  @override
  void dispose() {
    _docNumCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      // Save logic
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(color: Colors.grey[50], borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.client == null ? 'Nuevo Cliente' : 'Editar Cliente', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  IconButton(
                    icon: const Icon(LucideIcons.x, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Tipo Doc.', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(12)),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: _docType,
                                      items: ['CI', 'NIT', 'PASAPORTE', 'EXTRANJERO', 'OTRO'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                                      onChanged: (v) {
                                        if (v != null) setState(() => _docType = v);
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Número', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                                const SizedBox(height: 4),
                                TextFormField(
                                  controller: _docNumCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(hintText: 'Ej: 1234567', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                                  validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text('Nombre Completo / Razón Social', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _nameCtrl,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(hintText: 'Ej: Juan Pérez', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                        validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                      ),
                      
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Teléfono', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                                const SizedBox(height: 4),
                                TextFormField(
                                  controller: _phoneCtrl,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(hintText: 'Opcional', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Email', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                                const SizedBox(height: 4),
                                TextFormField(
                                  controller: _emailCtrl,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(hintText: 'Opcional', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                                  validator: (v) {
                                    if (v != null && v.isNotEmpty && !v.contains('@')) return 'Email inválido';
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: _saveForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  minimumSize: const Size(double.infinity, 48),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                ),
                child: const Text('Guardar Cliente', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
