import 'package:flutter/material.dart';
import '../request_screen_controller.dart';

class PredioSection extends StatefulWidget {
  final RequestScreenController controller;

  const PredioSection({super.key, required this.controller});

  @override
  State<PredioSection> createState() => _PredioSectionState();
}

class _PredioSectionState extends State<PredioSection> {
  @override
  Widget build(BuildContext context) {
    final predio = widget.controller.predioModel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Predio de Origen
        const Text(
          'Predio de Origen',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: predio.nombreController,
          decoration: const InputDecoration(
            labelText: 'Nombre del Predio *',
            border: OutlineInputBorder(),
          ),
          validator:
              (value) =>
                  value?.isEmpty ?? true ? 'Este campo es requerido' : null,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: predio.direccionController,
          decoration: const InputDecoration(
            labelText: 'Dirección *',
            border: OutlineInputBorder(),
          ),
          validator:
              (value) =>
                  value?.isEmpty ?? true ? 'Este campo es requerido' : null,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: predio.parroquiaController,
          decoration: const InputDecoration(
            labelText: 'Parroquia *',
            border: OutlineInputBorder(),
          ),
          validator:
              (value) =>
                  value?.isEmpty ?? true ? 'Este campo es requerido' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: predio.ubicacionController,
          decoration: const InputDecoration(
            labelText: 'Ubicación *',
            border: OutlineInputBorder(),
          ),
          validator:
              (value) =>
                  value?.isEmpty ?? true ? 'Este campo es requerido' : null,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          key: ValueKey(predio.condicionTenencia),
          value: predio.condicionTenencia,
          decoration: const InputDecoration(
            labelText: 'Tipo de Propiedad *',
            border: OutlineInputBorder(),
          ),
          items:
              predio.condicionTenenciaOptions
                  .map(
                    (opcion) =>
                        DropdownMenuItem(value: opcion, child: Text(opcion)),
                  )
                  .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                predio.condicionTenencia = value;
              });
              widget.controller.notifyListeners();
            }
          },
          validator: (value) => value == null ? 'Seleccione una opción' : null,
        ),

        const SizedBox(height: 24),

        // Destino
        const Text(
          'Destino',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 8),

        TextFormField(
          controller: predio.nombreDestinoController,
          decoration: const InputDecoration(
            labelText: 'Nombre del Predio Destino *',
            border: OutlineInputBorder(),
          ),
          validator:
              (value) =>
                  value?.isEmpty ?? true ? 'Este campo es requerido' : null,
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: predio.parroquiaDestinoController,
          decoration: const InputDecoration(
            labelText: 'Parroquia Destino *',
            border: OutlineInputBorder(),
          ),
          validator:
              (value) =>
                  value?.isEmpty ?? true ? 'Este campo es requerido' : null,
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: predio.direccionDestinoController,
          decoration: const InputDecoration(
            labelText: 'Dirección Destino *',
            border: OutlineInputBorder(),
          ),
          validator:
              (value) =>
                  value?.isEmpty ?? true ? 'Este campo es requerido' : null,
        ),
        const SizedBox(height: 12),

        CheckboxListTile(
          value: predio.esCentroFaenamiento,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                predio.esCentroFaenamiento = value;
              });
              widget.controller.notifyListeners();
            }
          },
          title: const Text('¿Es un Centro de Faenamiento?'),
          controlAffinity: ListTileControlAffinity.leading,
        ),

        const SizedBox(height: 12),

        // Observaciones generales (opcional)
        TextFormField(
          controller: predio.observacionesGeneralesController,
          decoration: const InputDecoration(
            labelText: 'Observaciones Generales (opcional)',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ],
    );
  }
}
