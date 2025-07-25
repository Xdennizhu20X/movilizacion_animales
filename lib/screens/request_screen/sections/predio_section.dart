import 'package:flutter/material.dart';
import '../request_screen_controller.dart';

class PredioSection extends StatefulWidget {
  final RequestScreenController controller;

  const PredioSection({super.key, required this.controller});

  @override
  State<PredioSection> createState() => _PredioSectionState();
}

class _PredioSectionState extends State<PredioSection> {
  static const Color mainColor = Color(0xFF6e328a);
  static const Color secondaryText = Colors.black87;
  static const double spacing = 14.0;

  InputDecoration _inputDecoration(String label, {bool isRequired = true}) {
    return InputDecoration(
      labelText: label + (isRequired ? ' *' : ''),
      labelStyle: const TextStyle(color: secondaryText, fontWeight: FontWeight.w500),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: mainColor),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: mainColor, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold, 
          fontSize: 17, 
          color: mainColor
        ),
      ),
    );
  }

  Widget _buildOrigenSection() {
    final predio = widget.controller.predioModel;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Predio de Origen'),
        const SizedBox(height: 10),
        
        TextFormField(
          controller: predio.nombreController,
          decoration: _inputDecoration('Nombre del Predio'),
          validator: (value) => value?.isEmpty ?? true ? 'Este campo es requerido' : null,
        ),
        const SizedBox(height: spacing),

        TextFormField(
          controller: predio.parroquiaController,
          decoration: _inputDecoration('Parroquia'),
          validator: (value) => value?.isEmpty ?? true ? 'Este campo es requerido' : null,
        ),
        const SizedBox(height: spacing),

        TextFormField(
          controller: predio.localidadController,
          decoration: _inputDecoration('Localidad (sector)'),
          validator: (value) => value?.isEmpty ?? true ? 'Este campo es requerido' : null,
        ),
        const SizedBox(height: spacing),

        TextFormField(
          controller: predio.sitioController,
          decoration: _inputDecoration('Sitio'),
          validator: (value) => value?.isEmpty ?? true ? 'Este campo es requerido' : null,
        ),
        const SizedBox(height: spacing),

        TextFormField(
          controller: predio.kilometroController,
          decoration: _inputDecoration('Kilómetro (máximo 50 km)'),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Este campo es requerido';
            if (double.tryParse(value) == null || double.parse(value) > 50) {
              return 'Debe ser un número ≤ 50';
            }
            return null;
          },
        ),
        const SizedBox(height: spacing),

        DropdownButtonFormField<String>(
          key: ValueKey(predio.condicionTenencia),
          value: predio.condicionTenencia,
          decoration: _inputDecoration('Tipo de Propiedad'),
          items: predio.condicionTenenciaOptions.map(
            (opcion) => DropdownMenuItem(value: opcion, child: Text(opcion)),
          ).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => predio.condicionTenencia = value);
              widget.controller.notifyListeners();
            }
          },
          validator: (value) => value == null ? 'Seleccione una opción' : null,
        ),
      ],
    );
  }

Widget _buildDestinoSection() {
  final predio = widget.controller.predioModel;
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _sectionTitle('Destino'),
      const SizedBox(height: 10),

      // Selector de tipo de destino
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
        subtitle: const Text('Marque esta opción si el destino es un matadero autorizado'),
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: mainColor,
        contentPadding: EdgeInsets.zero,
      ),
      const SizedBox(height: spacing),

      // Mostrar los campos de destino (que ahora tendrán los valores predeterminados si es centro de faenamiento)
      TextFormField(
        controller: predio.nombreDestinoController,
        decoration: _inputDecoration('Nombre del Predio Destino'),
        readOnly: predio.esCentroFaenamiento, // Hacer el campo de solo lectura si es centro de faenamiento
        validator: (value) => value?.isEmpty ?? true ? 'Este campo es requerido' : null,
      ),
      const SizedBox(height: spacing),

      TextFormField(
        controller: predio.parroquiaDestinoController,
        decoration: _inputDecoration('Parroquia Destino'),
        readOnly: predio.esCentroFaenamiento, // Hacer el campo de solo lectura si es centro de faenamiento
        validator: (value) => value?.isEmpty ?? true ? 'Este campo es requerido' : null,
      ),
      const SizedBox(height: spacing),

      TextFormField(
        controller: predio.ubicacionDestinoController,
        decoration: _inputDecoration('Ubicación Destino'),
        readOnly: predio.esCentroFaenamiento, // Hacer el campo de solo lectura si es centro de faenamiento
        validator: (value) => value?.isEmpty ?? true ? 'Este campo es requerido' : null,
      ),
      const SizedBox(height: spacing),
    ],
  );
}
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOrigenSection(),
          const SizedBox(height: spacing * 1.5),
          _buildDestinoSection(),
        ],
      ),
    );
  }
}