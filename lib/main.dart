import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/request_screen/request_screen.dart';
import 'screens/viewRequests_screen.dart';
import 'screens/forgotPasswordScreen.dart';
import 'package:movilizacion_animales/screens/webview_screen.dart';

void main() {
  runApp(MovilizacionApp());
}

class MovilizacionApp extends StatelessWidget {
  const MovilizacionApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movilización Animal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/request': (context) => RequestScreen(), 
        '/viewRequests': (context) => ViewRequestsScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
      },
    );
  }
}
