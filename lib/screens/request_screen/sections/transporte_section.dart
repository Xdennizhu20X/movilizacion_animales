import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../request_screen_controller.dart';

class TransporteSection extends StatelessWidget {
  final RequestScreenController controller;

  const TransporteSection({super.key, required this.controller});

  static const Color mainColor = Color(0xFF6e328a);
  static const Color secondaryText = Colors.black87;
  static const double spacing = 14.0;

  InputDecoration _inputDecoration(String label, {bool isRequired = true}) {
    return InputDecoration(
      labelText: label + (isRequired ? ' *' : ''),
      labelStyle: const TextStyle(color: secondaryText, fontWeight: FontWeight.w500),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: mainColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: mainColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transporte = controller.transporteModel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tipo de Transporte
        DropdownButtonFormField<String>(
          value: transporte.tipoTransporte,
          decoration: _inputDecoration('Tipo de Transporte'),
          items: transporte.tiposTransporte.map((tipo) {
            return DropdownMenuItem(
              value: tipo,
              child: Text(tipo == 'terrestre' ? 'Terrestre (Vehículo)' : 'Arreo (Caminando)'),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              transporte.tipoTransporte = value;
              controller.notifyListeners();
            }
          },
          validator: (value) => value == null ? 'Seleccione una opción' : null,
        ),
        const SizedBox(height: spacing),

        // Campos del Transportista
        TextFormField(
          controller: transporte.nombreTransportistaController,
          decoration: _inputDecoration('Nombre del Transportista'),
          validator: (value) => value?.isEmpty ?? true ? 'Este campo es requerido' : null,
        ),
        const SizedBox(height: spacing),

        TextFormField(
          controller: transporte.cedulaTransportistaController,
          decoration: _inputDecoration('Cédula del Transportista'),
          keyboardType: TextInputType.text,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) return 'Este campo es requerido';
            if (value.length != 10) return 'La cédula debe tener exactamente 10 dígitos';
            return null;
          },
        ),
        const SizedBox(height: spacing),

        // Campo Placa/Matrícula (solo para transporte terrestre)
        if (transporte.tipoTransporte == 'terrestre') ...[
          TextFormField(
            controller: transporte.placaMatriculaController,
            decoration: _inputDecoration('Placa/Matrícula del Vehículo'),
            validator: (value) {
              if (transporte.tipoTransporte == 'terrestre' && 
                  (value == null || value.isEmpty)) {
                return 'Este campo es requerido para transporte terrestre';
              }
              return null;
            },
          ),
          const SizedBox(height: spacing),
        ],

        TextFormField(
          controller: transporte.telefonoTransportistaController,
          decoration: _inputDecoration('Teléfono del Transportista'),
          keyboardType: TextInputType.phone,
          validator: (value) => value?.isEmpty ?? true ? 'Este campo es requerido' : null,
        ),
      ],
    );
  }
}