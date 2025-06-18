import 'package:flutter/material.dart';
import 'request_screen_controller.dart';
import 'request_screen_view.dart';

class RequestScreen extends StatelessWidget {
  final Color primaryPurple = const Color(0xFF6e328a);
  final Color whiteColor = Colors.white;
  final Color secondaryText = const Color(0xFF4A4A4A);

  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Text(
          'Nueva Solicitud de Movilización',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: primaryPurple,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RequestScreenView(
        controller: RequestScreenController(),
      ),
    );
  }
}