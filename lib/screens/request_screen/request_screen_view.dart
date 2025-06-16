import 'package:flutter/material.dart';
import 'request_screen_controller.dart';
import 'sections/predio_section.dart';
import 'sections/transporte_section.dart';
import 'sections/animales_section.dart';
import 'sections/aves_section.dart';

class RequestScreenView extends StatelessWidget {
  final RequestScreenController controller;

  const RequestScreenView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Scrollbar(
        controller: controller.scrollController,
        child: SingleChildScrollView(
          controller: controller.scrollController,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Predio Section
              PredioSection(controller: controller),
              
              const SizedBox(height: 24),
              
              // Transporte Section
              TransporteSection(controller: controller),
              
              const SizedBox(height: 24),
              
              // Animales Section
              AnimalesSection(controller: controller),
              
              const SizedBox(height: 24),
              
              // Aves Section
              AvesSection(controller: controller),
              
              const SizedBox(height: 24),
              
              // Observaciones Generales
              _buildSectionTitle('Observaciones Generales'),
              TextFormField(
                controller: controller.predioModel.observacionesGeneralesController,
                decoration: const InputDecoration(
                  labelText: 'Observaciones generales',
                  border: OutlineInputBorder(),
                  hintText: 'Ingrese observaciones generales si las hay',
                ),
                maxLines: 3,
              ),
              
              const SizedBox(height: 32),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.isLoading ? null : () => controller.enviarSolicitud(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: controller.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Enviar Solicitud', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
    );
  }
}