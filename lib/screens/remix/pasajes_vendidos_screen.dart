import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PasajesVendidosScreen extends StatefulWidget {
  const PasajesVendidosScreen({super.key});

  @override
  State<PasajesVendidosScreen> createState() => _PasajesVendidosScreenState();
}

class _PasajesVendidosScreenState extends State<PasajesVendidosScreen> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _sales = [
    {
      'id': '1',
      'clientName': 'Juan Pérez',
      'date': '12 de Octubre, 2023 • 15:30',
      'route': 'La Paz → Santa Cruz',
      'amount': 150.0,
      'busPlate': '1234-ABC',
      'busType': '2 Pisos',
      'paymentMethod': 'EFECTIVO',
      'departureTime': '18:00',
      'passengers': [
        {'name': 'Juan Pérez', 'ci': '1234567', 'seat': '12'},
      ],
    },
    {
      'id': '2',
      'clientName': 'Empresa S.A.',
      'date': '15 de Octubre, 2023 • 09:15',
      'route': 'Santa Cruz → Cochabamba',
      'amount': 300.0,
      'busPlate': '5678-XYZ',
      'busType': '1 Piso',
      'paymentMethod': 'TRANSFERENCIA',
      'departureTime': '20:30',
      'passengers': [
        {'name': 'Carlos Gómez', 'ci': '7654321', 'seat': '1'},
        {'name': 'María López', 'ci': '9876543', 'seat': '2'},
      ],
    },
  ];

  void _showSaleDetails(Map<String, dynamic> sale) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SaleDetailsModal(sale: sale),
    );
  }

  void _showPdfViewer() {
    showDialog(
      context: context,
      builder: (context) => const _PdfViewerDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered =
        _sales
            .where(
              (s) =>
                  s['clientName'].toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ||
                  s['route'].toLowerCase().contains(_searchQuery.toLowerCase()),
            )
            .toList();

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
          'Pasajes Vendidos',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
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
                hintText: 'Buscar por pasajero, CI o ruta...',
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
            child:
                filtered.isEmpty
                    ? const Center(
                      child: Text(
                        'No se encontraron ventas',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return _buildSaleCard(filtered[index]);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaleCard(Map<String, dynamic> sale) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sale['clientName'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          LucideIcons.calendar,
                          size: 12,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          sale['date'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Bs. ${sale['amount']}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      LucideIcons.mapPin,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      sale['route'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(LucideIcons.bus, size: 14, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      '${sale['busPlate']} (${sale['busType']})',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _showSaleDetails(sale),
                  icon: const Icon(
                    LucideIcons.eye,
                    size: 16,
                    color: Colors.grey,
                  ),
                  label: const Text(
                    'Ver Detalles',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                TextButton.icon(
                  onPressed: _showPdfViewer,
                  icon: Icon(
                    LucideIcons.receipt,
                    size: 16,
                    color: Colors.blue[600],
                  ),
                  label: Text(
                    'Ver Factura',
                    style: TextStyle(color: Colors.blue[600]),
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

class _SaleDetailsModal extends StatelessWidget {
  final Map<String, dynamic> sale;

  const _SaleDetailsModal({required this.sale});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Detalle de Venta',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'INFORMACIÓN GENERAL',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _infoRow('Fecha de Venta', sale['date']),
                        const SizedBox(height: 8),
                        _infoRow('Método de Pago', sale['paymentMethod']),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Monto Total',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Bs. ${sale['amount']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[600],
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'INFORMACIÓN DE RUTA',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _infoRow('Ruta', sale['route']),
                        const SizedBox(height: 8),
                        _infoRow('Salida', sale['departureTime']),
                        const Divider(height: 16),
                        _infoRow('Bus', sale['busPlate']),
                        const SizedBox(height: 8),
                        _infoRow('Tipo de Bus', sale['busType']),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'PASAJEROS (${sale['passengers'].length})',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...List.generate(sale['passengers'].length, (index) {
                    final p = sale['passengers'][index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'CI: ${p['ci']}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'ASIENTO',
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  p['seat'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }
}

class _PdfViewerDialog extends StatelessWidget {
  const _PdfViewerDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.blue),
            SizedBox(height: 16),
            Text(
              'Renderizando Factura PDF...',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
