import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../request_screen_controller.dart';

class TransporteSection extends StatelessWidget {
  final RequestScreenController controller;

  const TransporteSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: controller.transporteModel.tipoVia,
          decoration: const InputDecoration(
            labelText: 'Tipo de Vía *',
            border: OutlineInputBorder(),
          ),
          items: controller.transporteModel.tiposVia.map((tipo) {
            return DropdownMenuItem(value: tipo, child: Text(tipo));
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              controller.transporteModel.tipoVia = value;
              controller.notifyListeners();
            }
          },
          validator: (value) => value == null ? 'Seleccione una opción' : null,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: controller.transporteModel.tipoTransporte,
          decoration: const InputDecoration(
            labelText: 'Tipo de Transporte *',
            border: OutlineInputBorder(),
          ),
          items: controller.transporteModel.tiposTransporte.map((tipo) {
            return DropdownMenuItem(value: tipo, child: Text(tipo));
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              controller.transporteModel.tipoTransporte = value;
              controller.notifyListeners();
            }
          },
          validator: (value) => value == null ? 'Seleccione una opción' : null,
        ),
        if (controller.transporteModel.tipoTransporte == 'Otro') ...[
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.transporteModel.detalleOtro,
            decoration: const InputDecoration(
              labelText: 'Especifique el tipo de transporte *',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (controller.transporteModel.tipoTransporte == 'Otro' && 
                  (value == null || value.isEmpty)) {
                return 'Este campo es requerido';
              }
              return null;
            },
          ),
        ],
        const SizedBox(height: 12),
        TextFormField(
          controller: controller.transporteModel.nombreTransportista,
          decoration: const InputDecoration(
            labelText: 'Nombre del Transportista *',
            border: OutlineInputBorder(),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Este campo es requerido' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller.transporteModel.cedulaTransportista,
          decoration: const InputDecoration(
            labelText: 'Cédula del Transportista *',
            border: OutlineInputBorder(),
          ),
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
        const SizedBox(height: 12),
        TextFormField(
          controller: controller.transporteModel.placa,
          decoration: const InputDecoration(
            labelText: 'Placa del Vehículo *',
            border: OutlineInputBorder(),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Este campo es requerido' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller.transporteModel.telefonoTransportista,
          decoration: const InputDecoration(
            labelText: 'Teléfono del Transportista *',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) => value?.isEmpty ?? true ? 'Este campo es requerido' : null,
        ),
      ],
    );
  }
}