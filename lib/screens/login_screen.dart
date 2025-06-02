import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final _cedulaController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Color yellowColor = Color(0xFFFFD100); // Amarillo bandera Ecuador
    final Color blueColor = Color(0xFF003399); // Azul bandera Ecuador
    final Color redColor = Color(0xFFCE1126); // Rojo bandera Ecuador

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícono o imagen relacionada con animales (ejemplo: un dibujo simple)
              // Icon(Icons.pets, size: 100, color: blueColor),
              // SizedBox(height: 20),
              Image.asset(
                'assets/images/logo.png',
                width: 400,
                height: 100,
                fit: BoxFit.contain,
              ),
              

              Text(
                'Bienvenido',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: blueColor,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Por favor inicia sesión para continuar',
                style: TextStyle(
                  fontSize: 18,
                  color: blueColor.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),

              TextField(
                controller: _cedulaController,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 20, color: blueColor),
                decoration: InputDecoration(
                  labelText: 'Cédula',
                  labelStyle: TextStyle(color: blueColor, fontSize: 18),
                  prefixIcon: Icon(Icons.perm_identity, color: yellowColor),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: blueColor, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: redColor, width: 3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                ),
              ),

              SizedBox(height: 20),

              TextField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(fontSize: 20, color: blueColor),
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(color: blueColor, fontSize: 18),
                  prefixIcon: Icon(Icons.lock, color: yellowColor),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: blueColor, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: redColor, width: 3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                ),
              ),

              SizedBox(height: 32),

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
                    'Iniciar Sesión',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: blueColor,
                    ),
                  ),
                  onPressed: () {
                    // Lógica de autenticación
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                ),
              ),

              SizedBox(height: 16),

              TextButton(
                child: Text(
                  '¿No tienes cuenta? Regístrate',
                  style: TextStyle(
                    fontSize: 18,
                    color: redColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
