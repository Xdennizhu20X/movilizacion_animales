import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../request_screen_controller.dart';

class AnimalesSection extends StatelessWidget {
  final RequestScreenController controller;

  const AnimalesSection({super.key, required this.controller});

  static const Map<String, List<String>> categoriasPorEspecie = {
    'bovino': ['adulto', 'ternero'],
    'porcino': ['adulto', 'lechón'],
    'ovino': ['adulto'],
    'caprino': ['adulto'],
    'ave': ['adulto', 'pollito'],
  };

  @override
  Widget build(BuildContext context) {
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
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Animal ${index + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (controller.animales.length > 1)
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => controller.eliminarAnimal(index),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: animal.identificador,
                      decoration: const InputDecoration(
                        labelText: 'Identificador',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: animal.especie,
                      decoration: const InputDecoration(
                        labelText: 'Especie *',
                        border: OutlineInputBorder(),
                      ),
                      items: categoriasPorEspecie.keys.map((especie) {
                        return DropdownMenuItem(
                          value: especie,
                          child: Text(especie.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          animal.especie = value;
                          // Reiniciar la categoría al valor por defecto
                          animal.categoria = categoriasPorEspecie[value]!.first;
                          controller.notifyListeners();
                        }
                      },
                      validator: (value) =>
                          value == null ? 'Seleccione una especie' : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: categoriasDisponibles.contains(animal.categoria)
                          ? animal.categoria
                          : null,
                      decoration: const InputDecoration(
                        labelText: 'Categoría *',
                        border: OutlineInputBorder(),
                      ),
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
                      validator: (value) =>
                          value == null ? 'Seleccione una categoría' : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: animal.raza,
                            decoration: const InputDecoration(
                              labelText: 'Raza *',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value?.isEmpty ?? true ? 'Requerido' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: animal.sexo,
                            decoration: const InputDecoration(
                              labelText: 'Sexo *',
                              border: OutlineInputBorder(),
                            ),
                            items: const ['M', 'H'].map((sexo) {
                              return DropdownMenuItem(
                                value: sexo,
                                child:
                                    Text(sexo == 'M' ? 'Macho' : 'Hembra'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                animal.sexo = value;
                                controller.notifyListeners();
                              }
                            },
                            validator: (value) =>
                                value == null ? 'Seleccione sexo' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: animal.color,
                            decoration: const InputDecoration(
                              labelText: 'Color *',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value?.isEmpty ?? true ? 'Requerido' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: animal.edad,
                            decoration: const InputDecoration(
                              labelText: 'Edad (años) *',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) =>
                                value?.isEmpty ?? true ? 'Requerido' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: animal.comerciante,
                      decoration: const InputDecoration(
                        labelText: 'Comerciante *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true
                              ? 'Este campo es requerido'
                              : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: animal.observaciones,
                      decoration: const InputDecoration(
                        labelText: 'Observaciones',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        ElevatedButton.icon(
          onPressed: controller.agregarAnimal,
          icon: const Icon(Icons.add),
          label: const Text('Agregar Animal'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade100,
            foregroundColor: Colors.red.shade700,
          ),
        ),
      ],
    );
  }
}
