import 'package:flutter/material.dart';

class MenuCardItem extends StatelessWidget {
  final IconData icon; // Por ahora usaremos Iconos de Flutter en vez de imágenes
  final String title;
  final String subtitle;
  final VoidCallback onTap; // La acción al tocar la tarjeta

  const MenuCardItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0), // Espacio entre tarjetas
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey.shade300, width: 0.5),
        ),
        child: Row(
          children: [
            // Icono de la izquierda
            Icon(
              icon,
              size: 40,
              color: const Color(0xFF0056A3), // Azul oscuro similar a tu diseño
            ),
            const SizedBox(width: 16.0), // Separación entre icono y texto
            
            // Textos (Título y Subtítulo)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0056A3), // Azul oscuro
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}