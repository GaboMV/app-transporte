import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, dynamic>> menuItems = [
    {'icon': LucideIcons.home, 'label': 'Inicio', 'path': '/'},
    {'icon': LucideIcons.ticket, 'label': 'Venta de Pasajes', 'path': '/sales'},
    {
      'icon': LucideIcons.history,
      'label': 'Pasajes Vendidos',
      'path': '/sales-history',
    },
    {'icon': LucideIcons.map, 'label': 'Rutas', 'path': '/routes'},
    {
      'icon': LucideIcons.bus,
      'label': 'Gestión de Buses',
      'path': '/buses',
    },
    {'icon': LucideIcons.users, 'label': 'Conductores', 'path': '/conductores'},
    {'icon': LucideIcons.package, 'label': 'Encomiendas', 'path': '/parcels'},
    {'icon': LucideIcons.users, 'label': 'Clientes', 'path': '/clients'},
  ];

  final List<Map<String, dynamic>> dashboardCards = [
    {
      'title': 'Venta de Pasajes',
      'desc': 'Venta de boletos y selección de asientos',
      'icon': LucideIcons.ticket,
      'color': Colors.blue,
      'path': '/sales',
    },
    {
      'title': 'Rutas',
      'desc': 'Administración de rutas y horarios',
      'icon': LucideIcons.map,
      'color': Colors.green,
      'path': '/routes',
    },
    {
      'title': 'Gestión de Buses',
      'desc': 'Administración de flota y asientos',
      'icon': LucideIcons.bus,
      'color': Colors.indigo,
      'path': '/buses',
    },
    {
      'title': 'Conductores',
      'desc': 'Gestión de personal y choferes',
      'icon': LucideIcons.users,
      'color': Colors.cyan[600]!,
      'path': '/conductores',
    },
    {
      'title': 'Encomiendas',
      'desc': 'Registro y entrega de paquetes',
      'icon': LucideIcons.package,
      'color': Colors.orange,
      'path': '/parcels',
    },
    {
      'title': 'Clientes',
      'desc': 'Base de datos de pasajeros',
      'icon': LucideIcons.users,
      'color': Colors.purple,
      'path': '/clients',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF5F5F7), // gray-100 ish
      // -- AppBar --
      appBar: AppBar(
        elevation: 4,
        shadowColor: Colors.black26,
        backgroundColor: const Color(0xFF2563EB), // blue-600
        leading: IconButton(
          icon: const Icon(LucideIcons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: const Text(
          'Inicio',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF1D4ED8), // blue-700
              child: const Text(
                'U', // User initial mock
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),

      // -- Drawer --
      drawer: Drawer(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
              decoration: const BoxDecoration(
                color: Color(0xFF1E40AF), // blue-800
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -64,
                    right: -64,
                    child: Container(
                      width: 128,
                      height: 128,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              LucideIcons.bus,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SciBol',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                'Transport',
                                style: TextStyle(
                                  color: Color(0xFFBFDBFE), // blue-200
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Usuario Nombre',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      const Text(
                        'ADMINISTRADOR',
                        style: TextStyle(
                          color: Color(0xFF93C5FD), // blue-300
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Items
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return ListTile(
                    leading: Icon(
                      item['icon'] as IconData,
                      color: const Color(0xFF9CA3AF),
                    ), // gray-400
                    title: Text(
                      item['label'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xFF374151), // gray-700
                      ),
                    ),
                    trailing: const Icon(
                      LucideIcons.chevronRight,
                      color: Color(0xFFD1D5DB),
                      size: 16,
                    ), // gray-300
                    onTap: () {
                      Navigator.pop(context); // close drawer
                      Navigator.pushNamed(context, item['path']);
                    },
                  );
                },
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFF3F4F6)),
                ), // gray-100
              ),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // logout logic -> navigate to login
                      // Navigator.pushReplacementNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFEF2F2), // red-50
                      foregroundColor: const Color(0xFFDC2626), // red-600
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.logOut, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Cerrar Sesión',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Versión 1.0.0 • SciBol 2026',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF9CA3AF), // gray-400
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // -- Main Body --
      body: ListView.builder(
        padding: const EdgeInsets.all(
          16,
        ).copyWith(bottom: 100), // padding for bottom nav
        itemCount: dashboardCards.length,
        itemBuilder: (context, index) {
          final card = dashboardCards[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF3F4F6)), // gray-100
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.pushNamed(context, card['path']);
                },
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: card['color'] as Color,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (card['color'] as Color).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          card['icon'] as IconData,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              card['title'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xFF111827), // gray-900
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              card['desc'] as String,
                              style: const TextStyle(
                                color: Color(0xFF6B7280), // gray-500
                                fontSize: 12,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),

      // -- Bottom Navigation Bar --
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE5E7EB))), // gray-200
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(LucideIcons.home, 'Inicio', true),
                _buildNavItem(LucideIcons.ticket, 'Venta Rápida', false),
                _buildNavItem(LucideIcons.package, 'Encomiendas', false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return InkWell(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color:
                  isActive
                      ? const Color(0xFFEFF6FF)
                      : Colors.transparent, // blue-50
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color:
                  isActive
                      ? const Color(0xFF2563EB)
                      : const Color(0xFF9CA3AF), // blue-600 : gray-400
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color:
                  isActive ? const Color(0xFF2563EB) : const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}
