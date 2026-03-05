import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ParcelsScreen extends StatefulWidget {
  const ParcelsScreen({super.key});

  @override
  State<ParcelsScreen> createState() => _ParcelsScreenState();
}

class _ParcelsScreenState extends State<ParcelsScreen> {
  String _searchQuery = '';
  String _statusFilter = 'ALL';

  final List<Map<String, dynamic>> _parcels = [
    {
      'id': '12345678',
      'description': 'Caja de Electrónicos',
      'sender': 'Juan Pérez',
      'receiver': 'Empresa S.A.',
      'origin': 'Santa Cruz',
      'destination': 'La Paz',
      'price': 150.0,
      'isPaid': true,
      'isDelivered': false,
      'isPendingPayment': false,
    },
    {
      'id': '87654321',
      'description': 'Documentos Legales',
      'sender': 'María Gómez',
      'receiver': 'Carlos Zenteno',
      'origin': 'Cochabamba',
      'destination': 'Oruro',
      'price': 30.0,
      'isPaid': false,
      'isDelivered': false,
      'isPendingPayment': true,
    },
    {
      'id': '11223344',
      'description': 'Repuestos de Auto',
      'sender': 'Taller Los Andes',
      'receiver': 'Luis Fernández',
      'origin': 'Tarija',
      'destination': 'Santa Cruz',
      'price': 80.0,
      'isPaid': true,
      'isDelivered': true,
      'isPendingPayment': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered =
        _parcels.where((p) {
          bool matchesSearch =
              p['description'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              p['id'].contains(_searchQuery);
          if (!matchesSearch) return false;

          switch (_statusFilter) {
            case 'PENDING':
              return !p['isDelivered'];
            case 'PAY_ON_DELIVERY':
              return p['isPendingPayment'];
            case 'COMPLETED':
              return p['isDelivered'] && p['isPaid'];
            default:
              return true;
          }
        }).toList();

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
          'Encomiendas',
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
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              children: [
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Buscar por descripción o código...',
                    prefixIcon: const Icon(
                      LucideIcons.search,
                      color: Colors.grey,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('ALL', 'Todos'),
                      const SizedBox(width: 8),
                      _buildFilterChip('PENDING', 'Pendientes'),
                      const SizedBox(width: 8),
                      _buildFilterChip('PAY_ON_DELIVERY', 'Por Pagar'),
                      const SizedBox(width: 8),
                      _buildFilterChip('COMPLETED', 'Completadas'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child:
                filtered.isEmpty
                    ? const Center(
                      child: Text(
                        'No se encontraron encomiendas',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return _buildParcelCard(filtered[index]);
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue[600],
        child: const Icon(LucideIcons.plus, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterChip(String id, String label) {
    final isSelected = _statusFilter == id;
    return GestureDetector(
      onTap: () => setState(() => _statusFilter = id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey[200]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildParcelCard(Map<String, dynamic> parcel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                          parcel['isDelivered']
                              ? Colors.green[100]
                              : Colors.blue[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      LucideIcons.package,
                      color:
                          parcel['isDelivered']
                              ? Colors.green[600]
                              : Colors.blue[600],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        parcel['description'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'ID: ${parcel['id']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      parcel['isPaid'] ? Colors.green[100] : Colors.orange[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  parcel['isPaid'] ? 'PAGADO' : 'POR PAGAR',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color:
                        parcel['isPaid']
                            ? Colors.green[700]
                            : Colors.orange[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[100]!),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'REMITENTE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            parcel['sender'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'DESTINATARIO',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            parcel['receiver'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      parcel['origin'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        LucideIcons.arrowRight,
                        size: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      parcel['destination'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Bs ${parcel['price']}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),
          _buildActionRow(parcel),
        ],
      ),
    );
  }

  Widget _buildActionRow(Map<String, dynamic> parcel) {
    if (parcel['isPaid'] && !parcel['isPendingPayment']) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Factura de Encomienda'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('N° Guía: ${parcel['id']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('De: ${parcel['sender']}'),
                      Text('Para: ${parcel['receiver']}'),
                      Text('Detalle: ${parcel['description']}'),
                      const SizedBox(height: 16),
                      Text('Total Pagado: Bs ${parcel['price']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                    ],
                  ),
                  actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cerrar'))],
                )
              );
            },
            icon: const Icon(
              LucideIcons.fileText,
              size: 16,
              color: Colors.grey,
            ),
            label: const Text(
              'Ver Factura',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          if (!parcel['isDelivered'])
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  parcel['isDelivered'] = true;
                });
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Encomienda marcada como entregada')));
              },
              icon: const Icon(LucideIcons.truck, size: 16),
              label: const Text('Entregar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[50],
                foregroundColor: Colors.blue[600],
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(LucideIcons.checkCircle, size: 14, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    'Entregado',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    }

    if (parcel['isPendingPayment']) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Voucher Pendiente'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('N° Guía: ${parcel['id']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('De: ${parcel['sender']}'),
                      Text('Para: ${parcel['receiver']}'),
                      const SizedBox(height: 16),
                      Text('Monto a Cobrar: Bs ${parcel['price']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                    ],
                  ),
                  actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cerrar'))],
                )
              );
            },
            icon: const Icon(
              LucideIcons.stickyNote,
              size: 16,
              color: Colors.grey,
            ),
            label: const Text(
              'Ver Voucher',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          if (!parcel['isDelivered'])
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  parcel['isPaid'] = true;
                  parcel['isPendingPayment'] = false;
                  parcel['isDelivered'] = true;
                });
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pago registrado y encomienda entregada')));
              },
              icon: const Icon(
                LucideIcons.dollarSign,
                size: 16,
                color: Colors.white,
              ),
              label: const Text(
                'Cobrar y Entregar',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
        ],
      );
    }
    return const SizedBox();
  }
}
