import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final Color yellowColor = Color(0xFFFFD100);
  final Color blueColor = Color(0xFF003399);
  final Color redColor = Color(0xFFCE1126);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú Principal'),
        backgroundColor: blueColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Bienvenido',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: blueColor,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '¿Qué deseas hacer hoy?',
              style: TextStyle(
                fontSize: 18,
                color: blueColor.withOpacity(0.7),
              ),
            ),
            SizedBox(height: 30),

            _buildMenuCard(
              context,
              icon: Icons.assignment,
              title: 'Solicitar Movilización',
              color: yellowColor,
              onTap: () => Navigator.pushNamed(context, '/request'),
            ),

            SizedBox(height: 20),

            _buildMenuCard(
              context,
              icon: Icons.history,
              title: 'Ver Solicitudes',
              color: redColor,
              onTap: () => Navigator.pushNamed(context, '/viewRequests'),
            ),

            SizedBox(height: 20),

            _buildMenuCard(
              context,
              icon: Icons.settings,
              title: 'Ajustes de Cuenta',
              color: blueColor,
              onTap: () {
                // Navegar a ajustes
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context,
      {required IconData icon,
      required String title,
      required Color color,
      required VoidCallback onTap}) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 110,
          padding: EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.7), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 48, color: Colors.white),
              SizedBox(width: 24),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.white54),
            ],
          ),
        ),
      ),
    );
  }
}
