import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../request_screen_controller.dart';

class AnimalesSection extends StatelessWidget {
  final RequestScreenController controller;

  const AnimalesSection({super.key, required this.controller});

  static const Color mainColor = Color(0xFF6e328a);
  static const Color secondaryText = Colors.black87;
  static const Color borderColor = Color(0xFF6e328a);

  static const Map<String, List<String>> categoriasPorEspecie = {
    'bovino': ['adulto', 'ternero'],
    'porcino': ['adulto', 'lechón'],
    'ovino': ['adulto'],
    'caprino': ['adulto'],
    'ave': ['adulto', 'pollito'],
  };

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        print('AnimalesSection rebuild: ${controller.animales.length} animales'); // Debug
        
        return Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.animales.length,
              itemBuilder: (context, index) {
                final animal = controller.animales[index];
                final categoriasDisponibles = categoriasPorEspecie[animal.especie]!;

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Animal ${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            if (controller.animales.length > 1)
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => controller.eliminarAnimal(index),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        _styledField(
                          label: 'Identificador',
                          child: TextFormField(
                            controller: animal.identificador,
                            decoration: _inputDecoration('Identificador'),
                          ),
                        ),

                        _styledField(
                          label: 'Especie',
                          child: DropdownButtonFormField<String>(
                            value: animal.especie,
                            decoration: _inputDecoration('Especie *'),
                            items: categoriasPorEspecie.keys.map((especie) {
                              return DropdownMenuItem(
                                value: especie,
                                child: Text(especie.toUpperCase()),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                animal.especie = value;
                                animal.categoria = categoriasPorEspecie[value]!.first;
                                controller.notifyListeners();
                              }
                            },
                            validator: (value) => value == null ? 'Seleccione una especie' : null,
                          ),
                        ),

                        _styledField(
                          label: 'Categoría',
                          child: DropdownButtonFormField<String>(
                            value: categoriasDisponibles.contains(animal.categoria)
                                ? animal.categoria
                                : null,
                            decoration: _inputDecoration('Categoría *'),
                            items: categoriasDisponibles.map((categoria) {
                              return DropdownMenuItem(
                                value: categoria,
                                child: Text(categoria),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                animal.categoria = value;
                                controller.notifyListeners();
                              }
                            },
                            validator: (value) => value == null ? 'Seleccione una categoría' : null,
                          ),
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: _styledField(
                                label: 'Raza',
                                child: TextFormField(
                                  controller: animal.raza,
                                  decoration: _inputDecoration('Raza *'),
                                  validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _styledField(
                                label: 'Sexo',
                                child: DropdownButtonFormField<String>(
                                  value: animal.sexo,
                                  decoration: _inputDecoration('Sexo *'),
                                  items: const ['M', 'H'].map((sexo) {
                                    return DropdownMenuItem(
                                      value: sexo,
                                      child: Text(sexo == 'M' ? 'Macho' : 'Hembra'),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      animal.sexo = value;
                                      controller.notifyListeners();
                                    }
                                  },
                                  validator: (value) => value == null ? 'Seleccione sexo' : null,
                                ),
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: _styledField(
                                label: 'Color',
                                child: TextFormField(
                                  controller: animal.color,
                                  decoration: _inputDecoration('Color *'),
                                  validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _styledField(
                                label: 'Edad',
                                child: TextFormField(
                                  controller: animal.edad,
                                  decoration: _inputDecoration('Edad (años) *'),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
                                ),
                              ),
                            ),
                          ],
                        ),

                        _styledField(
                          label: 'Comerciante',
                          child: TextFormField(
                            controller: animal.comerciante,
                            decoration: _inputDecoration('Comerciante *'),
                            validator: (value) => value?.isEmpty ?? true ? 'Este campo es requerido' : null,
                          ),
                        ),

                        _styledField(
                          label: 'Observaciones',
                          child: TextFormField(
                            controller: animal.observaciones,
                            decoration: _inputDecoration('Observaciones'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            ElevatedButton.icon(
              onPressed: () {
                print('Botón presionado, agregando animal...'); // Debug
                controller.agregarAnimal();
              },
              icon: const Icon(Icons.add),
              label: const Text('Agregar Animal'),
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor.withOpacity(0.1),
                foregroundColor: mainColor,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Widget reutilizable para agrupar campos con margen vertical
  Widget _styledField({required String label, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: child,
    );
  }

  /// InputDecoration centralizado
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: secondaryText, fontWeight: FontWeight.w500),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: borderColor),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: mainColor, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}