import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _cedulaFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final Color primaryColor = Color(0xFF6E328A);
  final Color whiteColor = Colors.white;
  final Color borderColor = Color(0xFF6E328A).withOpacity(0.5);
  final Color errorColor = Colors.redAccent;

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _cedulaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameFocus.dispose();
    _cedulaFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text(
          'Registro',
          style: TextStyle(
            color: Colors.white, // Aquí defines el color del texto
            fontWeight: FontWeight.normal, // Opcional
            fontSize: 20, // Opcional
          ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
            child: ListView(
              children: [
                SizedBox(height: 20),
                Image.asset(
                  'assets/images/nuevologo.png',
                  width: 420,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 24),

                Text(
                  'Crea tu cuenta',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Regístrate para gestionar tus animales fácilmente',
                  style: TextStyle(
                    fontSize: 16,
                    color: primaryColor.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 36),

                _buildTextField(
                  controller: _nameController,
                  focusNode: _nameFocus,
                  nextFocus: _cedulaFocus,
                  label: 'Nombres Completos',
                  icon: Icons.person_outlined,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor ingresa tu nombre completo';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),

                _buildTextField(
                  controller: _cedulaController,
                  focusNode: _cedulaFocus,
                  nextFocus: _emailFocus,
                  label: 'Cédula',
                  icon: Icons.credit_card_outlined,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor ingresa tu número de cédula';
                    }
                    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
                    if (cleaned.length != 10) {
                      return 'Cédula debe tener 10 dígitos';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),

                _buildTextField(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  nextFocus: _passwordFocus,
                  label: 'Correo Electrónico',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor ingresa tu correo electrónico';
                    }
                    if (!RegExp(
                      r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                    ).hasMatch(value)) {
                      return 'Ingresa un correo electrónico válido';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),

                _buildTextField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  label: 'Contraseña',
                  icon: Icons.lock_outlined,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: primaryColor.withOpacity(0.6),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa una contraseña';
                    }
                    if (value.length < 6) {
                      return 'La contraseña debe tener al menos 6 caracteres';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: whiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                    onPressed: _isLoading ? null : _handleRegister,
                    child:
                        _isLoading
                            ? CircularProgressIndicator(color: whiteColor)
                            : Text(
                              'Registrar',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    '¿Ya tienes cuenta? Inicia sesión',
                    style: TextStyle(
                      fontSize: 16,
                      color: primaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    FocusNode? focusNode,
    FocusNode? nextFocus,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: TextStyle(fontSize: 18, color: primaryColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: primaryColor, fontSize: 16),
        prefixIcon: Icon(icon, color: primaryColor),
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: errorColor, width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: errorColor, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        errorStyle: TextStyle(color: errorColor),
      ),
      validator: validator,
      textInputAction:
          nextFocus != null ? TextInputAction.next : TextInputAction.done,
      onFieldSubmitted: (_) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        }
      },
    );
  }

  Future<void> _handleRegister() async {
    // 1. Forzar validación visual de todos los campos
    _formKey.currentState?.save();

    // 2. Verificar si el formulario es válido
    if (_formKey.currentState?.validate() ?? false) {
      // Solo continuar si la validación es exitosa
      setState(() => _isLoading = true);

      debugPrint('\n=== DATOS A ENVIAR ===');
      debugPrint('Nombre: ${_nameController.text.trim()}');
      debugPrint('Cédula: ${_cedulaController.text.trim()}');
      debugPrint('Email: ${_emailController.text.trim()}');
      debugPrint(
        'Password: ${_passwordController.text.isNotEmpty ? "******" : "VACÍO"}',
      );

      try {
        final response = await http
            .post(
              Uri.parse('https://back-abg.onrender.com/api/auth/register'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                'nombre': _nameController.text.trim(),
                'email': _emailController.text.trim(),
                'password': _passwordController.text,
                'ci': _cedulaController.text.trim(),
              }),
            )
            .timeout(Duration(seconds: 10));

        final responseData = jsonDecode(response.body);

        if (response.statusCode == 201) {
          _showSuccess('Registro exitoso!');
          await Future.delayed(Duration(seconds: 1));
          Navigator.pop(context);
        } else {
          _showError(responseData['message'] ?? 'Error en el registro');
        }
      } catch (e) {
        _showError('Error: ${e.toString()}');
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    } else {
      // Mostrar error específico si la validación falla
      _showFieldErrors();
    }
  }

  void _showFieldErrors() {
    if (_nameController.text.trim().isEmpty) {
      _showError('Nombre completo es requerido');
      FocusScope.of(context).requestFocus(_nameFocus);
    } else if (_cedulaController.text.trim().isEmpty) {
      _showError('Cédula es requerida');
      FocusScope.of(context).requestFocus(_cedulaFocus);
    } else if (!RegExp(
      r'^[0-9]{10}$',
    ).hasMatch(_cedulaController.text.trim())) {
      _showError('Cédula debe tener 10 dígitos');
      FocusScope.of(context).requestFocus(_cedulaFocus);
    } else if (_emailController.text.trim().isEmpty) {
      _showError('Email es requerido');
      FocusScope.of(context).requestFocus(_emailFocus);
    } else if (!RegExp(
      r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
    ).hasMatch(_emailController.text.trim())) {
      _showError('Ingrese un email válido');
      FocusScope.of(context).requestFocus(_emailFocus);
    } else if (_passwordController.text.isEmpty) {
      _showError('Contraseña es requerida');
      FocusScope.of(context).requestFocus(_passwordFocus);
    } else if (_passwordController.text.length < 6) {
      _showError('Contraseña debe tener 6+ caracteres');
      FocusScope.of(context).requestFocus(_passwordFocus);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
