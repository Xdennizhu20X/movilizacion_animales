import 'package:flutter/material.dart';
import '../services/auth_service.dart'; // Asegúrate que tenga el método para solicitar el reset

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final Color yellowColor = Color(0xFFFFD100);
  final Color blueColor = Color(0xFF003399);
  final Color redColor = Color(0xFFCE1126);
  bool _isLoading = false;

  Future<void> _sendResetEmail() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showMessage('Ingresa tu correo electrónico');
      return;
    }

    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(email)) {
      _showMessage('Correo electrónico no válido');
      return;
    }

    setState(() => _isLoading = true);

    final result = await AuthService.sendResetEmail(email);

    setState(() => _isLoading = false);

    if (result['success']) {
      _showMessage('Correo enviado. Revisa tu bandeja de entrada.');
      Navigator.pop(context); // Vuelve al login si deseas
    } else {
      _showMessage(result['message'] ?? 'Error al enviar el correo');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: redColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: blueColor,
        title: Text('Recuperar Contraseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ingresa tu correo electrónico y te enviaremos un enlace para restablecer tu contraseña.',
              style: TextStyle(fontSize: 18, color: blueColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(fontSize: 20, color: blueColor),
              decoration: InputDecoration(
                labelText: 'Correo Electrónico',
                labelStyle: TextStyle(color: blueColor),
                prefixIcon: Icon(Icons.email, color: yellowColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _sendResetEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: yellowColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: blueColor)
                    : Text(
                        'Enviar enlace',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: blueColor,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
