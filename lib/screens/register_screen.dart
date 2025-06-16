import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final Color yellowColor = Color(0xFFFFD100);
  final Color blueColor = Color(0xFF003399);
  final Color redColor = Color(0xFFCE1126);

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Registro'),
        backgroundColor: blueColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: ListView(
            children: [
              Icon(Icons.pets, size: 100, color: blueColor),
              SizedBox(height: 20),

              Text(
                'Crea tu cuenta',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: blueColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                'Regístrate para gestionar tus animales fácilmente',
                style: TextStyle(
                  fontSize: 18,
                  color: blueColor.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),

              _buildTextField(
                controller: _nameController,
                label: 'Nombres Completos',
                icon: Icons.person,
              ),

              SizedBox(height: 20),

              _buildTextField(
                controller: _cedulaController,
                label: 'Cédula',
                icon: Icons.perm_identity,
                keyboardType: TextInputType.number,
              ),

              SizedBox(height: 20),

              _buildTextField(
                controller: _emailController,
                label: 'Correo Electrónico',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: 20),

              _buildTextField(
                controller: _passwordController,
                label: 'Contraseña',
                icon: Icons.lock,
                obscureText: true,
              ),

              SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yellowColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: _isLoading 
                      ? CircularProgressIndicator(color: blueColor)
                      : Text(
                          'Registrar',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: blueColor,
                          ),
                        ),
                  onPressed: _isLoading ? null : _handleRegister,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: TextStyle(fontSize: 20, color: blueColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: blueColor, fontSize: 18),
        prefixIcon: Icon(icon, color: yellowColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: blueColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: redColor, width: 3),
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
    );
  }

  Future<void> _handleRegister() async {
    final name = _nameController.text.trim();
    final cedula = _cedulaController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || cedula.isEmpty || email.isEmpty || password.isEmpty) {
      _showError('Por favor completa todos los campos');
      return;
    }

    // Validación de email
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(email)) {
      _showError('Por favor ingresa un correo electrónico válido');
      return;
    }

    // Validación de contraseña
    if (password.length < 6) {
      _showError('La contraseña debe tener al menos 6 caracteres');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/auth/register'), // Reemplaza con tu URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': name,
          'email': email,
          'password': password,
          'cedula': cedula,
        }),
      );

      final responseData = jsonDecode(response.body);

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 201) {
        // Registro exitoso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registro exitoso! Por favor inicia sesión'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Regresar al login
      } else {
        _showError(responseData['message'] ?? 'Error en el registro');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError('Error de conexión: ${e.toString()}');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}