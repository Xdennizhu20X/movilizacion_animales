import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../request_screen_controller.dart';

class AvesSection extends StatelessWidget {
  final RequestScreenController controller;

  const AvesSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.aves.length,
          itemBuilder: (context, index) {
            final ave = controller.aves[index];
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
                        Text('Aves ${index + 1}', 
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        if (controller.aves.length > 1)
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => controller.eliminarAve(index),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: ave.numeroGalpon,
                      decoration: const InputDecoration(
                        labelText: 'Número de Galpón *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value?.isEmpty ?? true ? 'Este campo es requerido' : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: ave.categoria,
                      decoration: const InputDecoration(
                        labelText: 'Categoría *',
                        border: OutlineInputBorder(),
                      ),
                      items: const ['Engorde', 'Postura', 'Reproductoras']
                          .map((categoria) {
                        return DropdownMenuItem(
                          value: categoria, 
                          child: Text(categoria),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          ave.categoria = value;
                          controller.notifyListeners();
                        }
                      },
                      validator: (value) => value == null ? 'Seleccione una categoría' : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: ave.edad,
                            decoration: const InputDecoration(
                              labelText: 'Edad (semanas) *',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: ave.totalAves,
                            decoration: const InputDecoration(
                              labelText: 'Total de Aves',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: ave.observaciones,
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
          onPressed: controller.agregarAve,
          icon: const Icon(Icons.add),
          label: const Text('Agregar Aves'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade100,
            foregroundColor: Colors.red.shade700,
          ),
        ),
      ],
    );
  }
}