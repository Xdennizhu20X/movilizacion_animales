import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../request_screen_controller.dart';

class AvesSection extends StatelessWidget {
  final RequestScreenController controller;

  const AvesSection({super.key, required this.controller});

  static const Color mainColor = Color(0xFF6e328a);
  static const Color secondaryText = Colors.black87;
  static const Color borderColor = Color(0xFF6e328a);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        print('AvesSection rebuild: ${controller.aves.length} aves'); // Debug
        
        return Column(
          children: [
            // Mostrar mensaje cuando no hay aves
            if (controller.aves.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'No hay aves agregadas. Presiona "Agregar Aves" para empezar.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            
            // Lista de aves (solo si hay aves)
            if (controller.aves.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.aves.length,
                itemBuilder: (context, index) {
                  print('Building ave item $index'); // Debug
                  final ave = controller.aves[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Aves ${index + 1}', 
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              if (controller.aves.length > 1)
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => controller.eliminarAve(index),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          
                          _styledField(
                            label: 'Número de Galpón',
                            child: TextFormField(
                              controller: ave.numeroGalpon,
                              decoration: _inputDecoration('Número de Galpón *'),
                              validator: (value) => 
                                value?.isEmpty ?? true ? 'Este campo es requerido' : null,
                            ),
                          ),
                          
                          _styledField(
                            label: 'Categoría',
                            child: DropdownButtonFormField<String>(
                              value: ave.categoria,
                              decoration: _inputDecoration('Categoría *'),
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
                              validator: (value) => 
                                value == null ? 'Seleccione una categoría' : null,
                            ),
                          ),
                          
                          Row(
                            children: [
                              Expanded(
                                child: _styledField(
                                  label: 'Edad',
                                  child: TextFormField(
                                    controller: ave.edad,
                                    decoration: _inputDecoration('Edad (semanas) *'),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    validator: (value) => 
                                      value?.isEmpty ?? true ? 'Requerido' : null,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _styledField(
                                  label: 'Total de Aves',
                                  child: TextFormField(
                                    controller: ave.totalAves,
                                    decoration: _inputDecoration('Total de Aves'),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          _styledField(
                            label: 'Observaciones',
                            child: TextFormField(
                              controller: ave.observaciones,
                              decoration: _inputDecoration('Observaciones'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            
            // Botón para agregar aves
            ElevatedButton.icon(
              onPressed: () {
                print('Botón presionado, agregando ave...'); // Debug
                controller.agregarAve();
              },
              icon: const Icon(Icons.add),
              label: Text(
                controller.aves.isEmpty 
                  ? 'Agregar Aves' 
                  : 'Agregar Más Aves',
              ),
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
      labelStyle: const TextStyle(
        color: secondaryText, 
        fontWeight: FontWeight.w500,
      ),
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