import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:movilizacion_animales/screens/auth_checker.dart';
import 'package:movilizacion_animales/services/api_service.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/request_screen/request_screen.dart';
import 'screens/viewRequests_screen.dart';
import 'screens/forgotPasswordScreen.dart';
import 'package:movilizacion_animales/screens/webview_screen.dart';
import 'screens/profile_screen.dart'; // Importar la nueva pantalla

void main() {
  runApp(const MovilizacionApp());
}

class MovilizacionApp extends StatefulWidget {
  const MovilizacionApp({super.key});

  @override
  State<MovilizacionApp> createState() => _MovilizacionAppState();
}

class _MovilizacionAppState extends State<MovilizacionApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movilización Animal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: AuthChecker(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/request': (context) => RequestScreen(),
        '/viewRequests': (context) => ViewRequestsScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/profile': (context) => ProfileScreen(), // Agregar la nueva ruta
      },
    );
  }
}
