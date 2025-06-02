import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  final _nameController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Color yellowColor = Color(0xFFFFD100); // Amarillo bandera Ecuador
    final Color blueColor = Color(0xFF003399); // Azul bandera Ecuador
    final Color redColor = Color(0xFFCE1126); // Rojo bandera Ecuador

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
                label: 'Nombres',
                icon: Icons.person,
                blueColor: blueColor,
                yellowColor: yellowColor,
                redColor: redColor,
              ),

              SizedBox(height: 20),

              _buildTextField(
                controller: _cedulaController,
                label: 'Cédula',
                icon: Icons.perm_identity,
                keyboardType: TextInputType.number,
                blueColor: blueColor,
                yellowColor: yellowColor,
                redColor: redColor,
              ),

              SizedBox(height: 20),

              _buildTextField(
                controller: _emailController,
                label: 'Correo',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                blueColor: blueColor,
                yellowColor: yellowColor,
                redColor: redColor,
              ),

              SizedBox(height: 20),

              _buildTextField(
                controller: _passwordController,
                label: 'Contraseña',
                icon: Icons.lock,
                obscureText: true,
                blueColor: blueColor,
                yellowColor: yellowColor,
                redColor: redColor,
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
                  child: Text(
                    'Registrar',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: blueColor,
                    ),
                  ),
                  onPressed: () {
                    // Lógica real de registro
                    Navigator.pop(context);
                  },
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
    required Color blueColor,
    required Color yellowColor,
    required Color redColor,
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
}
