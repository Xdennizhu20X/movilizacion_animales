import 'package:flutter/material.dart';
import 'request_screen_controller.dart';
import 'request_screen_view.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Solicitud de Movilización'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: RequestScreenView(
        controller: RequestScreenController(),
      ),
    );
  }
}