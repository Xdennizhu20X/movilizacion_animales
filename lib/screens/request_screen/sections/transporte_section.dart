import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../request_screen_controller.dart';

class TransporteSection extends StatelessWidget {
  final RequestScreenController controller;

  const TransporteSection({super.key, required this.controller});

  static const Color mainColor = Color(0xFF6e328a);
  static const Color secondaryText = Colors.black87;
  static const double spacing = 14.0;

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
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
        DropdownButtonFormField<String>(
          value: transporte.tipoVia,
          decoration: _inputDecoration('Tipo de Vía *'),
          items: transporte.tiposVia.map(
            (tipo) => DropdownMenuItem(value: tipo, child: Text(tipo)),
          ).toList(),
          onChanged: (value) {
            if (value != null) {
              transporte.tipoVia = value;
              controller.notifyListeners();
            }
          },
          validator: (value) => value == null ? 'Seleccione una opción' : null,
        ),
        const SizedBox(height: spacing),

        DropdownButtonFormField<String>(
          value: transporte.tipoTransporte,
          decoration: _inputDecoration('Tipo de Transporte *'),
          items: transporte.tiposTransporte.map(
            (tipo) => DropdownMenuItem(value: tipo, child: Text(tipo)),
          ).toList(),
          onChanged: (value) {
            if (value != null) {
              transporte.tipoTransporte = value;
              controller.notifyListeners();
            }
          },
          validator: (value) => value == null ? 'Seleccione una opción' : null,
        ),
        if (transporte.tipoTransporte == 'Otro') ...[
          const SizedBox(height: spacing),
          TextFormField(
            controller: transporte.detalleOtro,
            decoration: _inputDecoration('Especifique el tipo de transporte *'),
            validator: (value) {
              if (transporte.tipoTransporte == 'Otro' && (value == null || value.isEmpty)) {
                return 'Este campo es requerido';
              }
              return null;
            },
          ),
        ],
        const SizedBox(height: spacing),

        TextFormField(
          controller: transporte.nombreTransportista,
          decoration: _inputDecoration('Nombre del Transportista *'),
          validator: (value) => value?.isEmpty ?? true ? 'Este campo es requerido' : null,
        ),
        const SizedBox(height: spacing),

        TextFormField(
          controller: transporte.cedulaTransportista,
          decoration: _inputDecoration('Cédula del Transportista *'),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es requerido';
            }
            if (value.length != 10) {
              return 'La cédula debe tener 10 dígitos';
            }
            return null;
          },
        ),
        const SizedBox(height: spacing),

        TextFormField(
          controller: transporte.placa,
          decoration: _inputDecoration('Placa del Vehículo *'),
          validator: (value) => value?.isEmpty ?? true ? 'Este campo es requerido' : null,
        ),
        const SizedBox(height: spacing),

        TextFormField(
          controller: transporte.telefonoTransportista,
          decoration: _inputDecoration('Teléfono del Transportista *'),
          keyboardType: TextInputType.phone,
          validator: (value) => value?.isEmpty ?? true ? 'Este campo es requerido' : null,
        ),
      ],
    );
  }
}
