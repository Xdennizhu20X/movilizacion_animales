import 'package:flutter/material.dart';
import 'package:movilizacion_animales/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color primaryPurple = Color(0xFF6e328a);
  final Color whiteColor = Colors.white;
  final Color secondaryText = Color(0xFF4A4A4A);
  String? userNombre;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    String? name = await AuthService.getUserName();
    setState(() {
      userNombre = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text(
          'Menú Principal',
          style: TextStyle(color: whiteColor),
        ),
        centerTitle: true,
        backgroundColor: primaryPurple,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenido${userNombre != null ? ', $userNombre' : ''}',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: primaryPurple,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '¿Qué deseas hacer hoy?',
              style: TextStyle(
                fontSize: 18,
                color: secondaryText,
              ),
            ),
            SizedBox(height: 30),

            _buildMenuCard(
              context,
              icon: Icons.assignment_outlined,
              title: 'Solicitar Movilización',
              onTap: () => Navigator.pushNamed(context, '/request'),
            ),

            SizedBox(height: 20),

            _buildMenuCard(
              context,
              icon: Icons.history,
              title: 'Ver Solicitudes',
              onTap: () => Navigator.pushNamed(context, '/viewRequests'),
            ),

            SizedBox(height: 20),

            _buildMenuCard(
              context,
              icon: Icons.settings,
              title: 'Ajustes de Cuenta',
              onTap: () => Navigator.pushNamed(context, '/profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final Color primaryPurple = Color(0xFF6e328a);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      shadowColor: primaryPurple.withOpacity(0.2),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          height: 100,
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                primaryPurple.withOpacity(0.85),
                primaryPurple,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.white),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }
}
