import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../request_screen_controller.dart';
import '../../../models/animal_model.dart';

class AnimalesSection extends StatelessWidget {
  final RequestScreenController controller;

  const AnimalesSection({super.key, required this.controller});

  static const Color mainColor = Color(0xFF6e328a);
  static const Color secondaryText = Colors.black87;
  static const Color borderColor = Color(0xFF6e328a);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return Column(
          children: [
            // Tabla de animales
            if (controller.animales.isNotEmpty) ...[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('#')),
                    DataColumn(label: Text('Identificación')),
                    DataColumn(label: Text('Especie')),
                    DataColumn(label: Text('Raza')),
                    DataColumn(label: Text('Acciones')),
                  ],
                  rows: List<DataRow>.generate(
                    controller.animales.length,
                    (index) {
                      final animal = controller.animales[index];
                      final raza = animal.razaSeleccionada == 'OTRA - ESPECIFIQUE'
                          ? animal.otraRazaEspecifique.text
                          : animal.razaSeleccionada ?? '';
                      
                      return DataRow(
                        cells: [
                          DataCell(Text('${index + 1}')),
                          DataCell(Text(animal.identificador.text)),
                          DataCell(Text(animal.especie.toUpperCase())),
                          DataCell(Text(raza)),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 18),
                                  onPressed: () => _mostrarDialogoAnimal(
                                    context, 
                                    index: index,
                                    isEditing: true,
                                  ),
                                ),
                                if (controller.animales.length > 1)
                                IconButton(
                                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                                  onPressed: () => controller.eliminarAnimal(index),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Botón para agregar animal
            ElevatedButton.icon(
              onPressed: () => _mostrarDialogoAnimal(context),
              icon: const Icon(Icons.add),
              label: const Text('Agregar Animal'),
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor.withOpacity(0.1),
                foregroundColor: mainColor,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

void _mostrarDialogoAnimal(
  BuildContext context, {
  int? index,
  bool isEditing = false,
}) {
  final formKey = GlobalKey<FormState>();

  // ✅ Usamos un solo modelo durante todo el diálogo
  final AnimalModel animal = isEditing && index != null
      ? controller.animales[index]
      : AnimalModel();

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(isEditing ? 'Editar Animal' : 'Agregar Animal'),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _styledField(
                      label: 'Identificación',
                      child: TextFormField(
                        controller: animal.identificador,
                        decoration: _inputDecoration('Número de identificación *'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(15),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Requerido';
                          if (!RegExp(r'^\d+$').hasMatch(value)) return 'Solo números';
                          if (value.length > 15) return 'Máx. 15 dígitos';
                          return null;
                        },
                      ),
                    ),
                    _styledField(
                      label: 'Especie',
                      child: DropdownButtonFormField<String>(
                        value: animal.especie.isEmpty ? 'bovino' : animal.especie,
                        decoration: _inputDecoration('Especie *'),
                        items: const [
                          DropdownMenuItem(value: 'bovino', child: Text('BOVINO')),
                          DropdownMenuItem(value: 'porcino', child: Text('PORCINO')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            animal.especie = value;
                            animal.razaSeleccionada = null;
                            setState(() {});
                          }
                        },
                        validator: (value) =>
                            value == null ? 'Seleccione una especie' : null,
                      ),
                    ),
_styledField(
  label: 'Raza',
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<String>.empty();
          }
          return _obtenerRazasPorEspecie(animal.especie).where((raza) {
            return raza.toLowerCase().contains(textEditingValue.text.toLowerCase());
          });
        },
        onSelected: (String selection) {
          animal.razaSeleccionada = selection;
          setState(() {});
        },
        fieldViewBuilder: (BuildContext context,
            TextEditingController fieldTextEditingController,
            FocusNode fieldFocusNode,
            VoidCallback onFieldSubmitted) {
          // Mantenemos sincronizado el controlador con el valor seleccionado
          if (animal.razaSeleccionada != null && 
              fieldTextEditingController.text.isEmpty) {
            fieldTextEditingController.text = animal.razaSeleccionada!;
          }
          return TextFormField(
            controller: fieldTextEditingController,
            focusNode: fieldFocusNode,
            decoration: _inputDecoration('Raza *'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Seleccione una raza';
              }
              return null;
            },
          );
        },
        optionsViewBuilder: (BuildContext context,
            AutocompleteOnSelected<String> onSelected,
            Iterable<String> options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4.0,
              child: SizedBox(
                height: 200.0,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String option = options.elementAt(index);
                    return InkWell(
                      onTap: () {
                        onSelected(option);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(option),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
      if (animal.razaSeleccionada == 'OTRA - ESPECIFIQUE')
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: TextFormField(
            controller: animal.otraRazaEspecifique,
            decoration: _inputDecoration('Especifique la raza *'),
            validator: (value) {
              if (animal.razaSeleccionada == 'OTRA - ESPECIFIQUE' &&
                  (value == null || value.isEmpty)) {
                return 'Por favor especifique';
              }
              return null;
            },
          ),
        ),
    ],
  ),
),
                    Row(
                      children: [
                        Expanded(
                          child: _styledField(
                            label: 'Sexo',
                            child: DropdownButtonFormField<String>(
                              value: animal.sexo.isEmpty ? 'M' : animal.sexo,
                              decoration: _inputDecoration('Sexo *'),
                              items: const [
                                DropdownMenuItem(value: 'M', child: Text('Macho')),
                                DropdownMenuItem(value: 'H', child: Text('Hembra')),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  animal.sexo = value;
                                }
                              },
                              validator: (value) =>
                                  value == null ? 'Seleccione sexo' : null,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _styledField(
                            label: 'Color',
                            child: TextFormField(
                              controller: animal.color,
                              decoration: _inputDecoration('Color *'),
                              validator: (value) =>
                                  value?.isEmpty ?? true ? 'Requerido' : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    _styledField(
                      label: 'Edad',
                      child: TextFormField(
                        controller: animal.edad,
                        decoration: _inputDecoration('Edad (años/meses) *'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Requerido' : null,
                      ),
                    ),
                    _styledField(
                      label: 'Comerciante',
                      child: TextFormField(
                        controller: animal.comerciante,
                        decoration: _inputDecoration('Comerciante *'),
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Requerido' : null,
                      ),
                    ),
                    _styledField(
                      label: 'Observaciones',
                      child: TextFormField(
                        controller: animal.observaciones,
                        decoration: _inputDecoration('Observaciones'),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    if (isEditing && index != null) {
                      controller.notifyListeners(); // Solo refresca
                    } else {
                      controller.agregarAnimal(animal); // Nuevo animal completo
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(isEditing ? 'Guardar' : 'Agregar'),
              ),
            ],
          );
        },
      );
    },
  );
}

  List<String> _obtenerRazasPorEspecie(String especie) {
    // Mapeo de razas por especie (podría moverse al controlador si es necesario)
    const razasPorEspecie = {
      'bovino': [
        'GIROLANDO (GYR HOLSTEIN)',
        'HOLSTEIN ROJO',
        'HOLSTEIN NEGRO',
        'JERSEY',
        'JERSEY NEOZELANDES',
        'SIMMENTAL',
        'BROWN SWISS',
        'CHAROLAIS-CHAROLESA',
        'NORMANDO',
        'SENEPOL',
        'GYR',
        'BOMBALIER',
        'ANGUS NEGRO',
        'ANGUS ROJO',
        'BRAFORD',
        'BRAHMAN',
        'BRANGUS',
        'LIDIA',
        'SANTA GERTRUDIS',
        'YAKUR',
        'SINDHI',
        'GUZERAT',
        'CRUZADO',
        'OTRA - ESPECIFIQUE'
      ],
      'porcino': [
        'YORKSHIRE',
        'LANDRACE',
        'DUROC',
        'PIETRAIN',
        'HAMPSHIRE',
        'BLANCO BELGA',
        'LARGE WHITE',
        'CRUZADO',
        'OTRA - ESPECIFIQUE'
      ],
      'ave': [
        'COBB',
        'ROSS',
        'LOHMANN BROWN',
        'HY-LINE',
        'OTRA - ESPECIFIQUE'
      ],
    };
    
    return razasPorEspecie[especie] ?? [];
  }

  Widget _styledField({required String label, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: secondaryText,
            ),
          ),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: mainColor, width: 2),
      ),
      isDense: true,
    );
  }
}