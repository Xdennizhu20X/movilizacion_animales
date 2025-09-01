import 'package:flutter/material.dart';
import 'package:movilizacion_animales/services/user_service.dart';
import 'app_widgets.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final response = await UserService.getProfile();
    if (response['success']) {
      setState(() {
        userData = response['data'];
        isLoading = false;
      });
    } else {
      // Manejar el error, por ejemplo, mostrando un snackbar
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryPurple = Color(0xFF6e328a);
    final Color whiteColor = Colors.white;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Perfil de Usuario'),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userData == null
              ? Center(child: Text('No se pudieron cargar los datos del usuario.'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const LogoHeader(),
                      _buildProfileHeader(),
                      SizedBox(height: 30),
                      _buildProfileDetailCard(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFF6e328a),
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          SizedBox(height: 15),
          Text(
            userData!['nombre'] ?? 'Nombre no disponible',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6e328a),
            ),
          ),
          SizedBox(height: 5),
          Text(
            userData!['email'] ?? 'Email no disponible',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetailCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildDetailRow(Icons.badge, 'Cédula', userData!['ci'] ?? 'No disponible'),
            Divider(),
            _buildDetailRow(Icons.phone, 'Teléfono', userData!['telefono'] ?? 'No disponible'),
            Divider(),
            _buildDetailRow(Icons.work, 'Rol', userData!['rol'] ?? 'No disponible'),
            Divider(),
            _buildDetailRow(Icons.date_range, 'Miembro desde', userData!['fecha_registro'] != null ? userData!['fecha_registro'].substring(0, 10) : 'No disponible'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF6e328a)),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 2),
              Text(value, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            ],
          ),
        ],
      ),
    );
  }
}
