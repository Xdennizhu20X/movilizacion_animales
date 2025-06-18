import 'package:flutter/material.dart';
import 'request_screen_controller.dart';
import 'sections/predio_section.dart';
import 'sections/transporte_section.dart';
import 'sections/animales_section.dart';
import 'sections/aves_section.dart';

class RequestScreenView extends StatelessWidget {
  final RequestScreenController controller;
  final Color primaryPurple = const Color(0xFF6e328a);
  final Color whiteColor = Colors.white;
  final Color secondaryText = const Color(0xFF4A4A4A);

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
              _buildSectionCard(
                child: PredioSection(controller: controller),
              ),
              
              const SizedBox(height: 24),
              
              // Transporte Section
              _buildSectionCard(
                child: TransporteSection(controller: controller),
              ),
              
              const SizedBox(height: 24),
              
              // Animales Section
              _buildSectionCard(
                child: AnimalesSection(controller: controller),
              ),
              
              const SizedBox(height: 24),
              
              // Aves Section
              _buildSectionCard(
                child: AvesSection(controller: controller),
              ),
              
              const SizedBox(height: 24),
              
              // Observaciones Generales
              _buildSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Observaciones Generales'),
                    TextFormField(
                      controller: controller.predioModel.observacionesGeneralesController,
                      decoration: _inputDecoration(
                        'Observaciones generales',
                        hintText: 'Ingrese observaciones generales si las hay',
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.isLoading 
                      ? null 
                      : () => controller.enviarSolicitud(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryPurple,
                    foregroundColor: whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: controller.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Enviar Solicitud', 
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: primaryPurple,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {String? hintText}) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      labelStyle: TextStyle(
        color: secondaryText,
        fontWeight: FontWeight.w500,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: primaryPurple.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: primaryPurple, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}