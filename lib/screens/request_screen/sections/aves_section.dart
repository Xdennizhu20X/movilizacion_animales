import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../request_screen_controller.dart';
import '../../../models/ave_model.dart';

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
        return Column(
          children: [
            // Tabla de aves
            if (controller.aves.isNotEmpty) ...[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('#')),
                    DataColumn(label: Text('Galpón')),
                    DataColumn(label: Text('Categoría')),
                    DataColumn(label: Text('Raza')),
                    DataColumn(label: Text('Total Aves')),
                    DataColumn(label: Text('Acciones')),
                  ],
                  rows: List<DataRow>.generate(
                    controller.aves.length,
                    (index) {
                      final ave = controller.aves[index];
                      final raza = ave.raza == 'OTRA - ESPECIFIQUE'
                          ? ave.otraRazaEspecifique.text
                          : ave.raza;
                      
                      return DataRow(
                        cells: [
                          DataCell(Text('${index + 1}')),
                          DataCell(Text(ave.numeroGalpon.text)),
                          DataCell(Text(ave.categoria)),
                          DataCell(Text(raza)),
                          DataCell(Text(ave.totalAves.text)),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 18),
                                  onPressed: () => _mostrarDialogoAve(
                                    context, 
                                    index: index,
                                    isEditing: true,
                                  ),
                                ),
                                if (controller.aves.length > 1)
                                IconButton(
                                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                                  onPressed: () => controller.eliminarAve(index),
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

            // Botón para agregar ave
            ElevatedButton.icon(
              onPressed: () => _mostrarDialogoAve(context),
              icon: const Icon(Icons.add),
              label: const Text('Agregar Lote de Aves'),
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

  void _mostrarDialogoAve(
    BuildContext context, {
    int? index,
    bool isEditing = false,
  }) {
    final formKey = GlobalKey<FormState>();
    final categoriasAves = ['Engorde', 'Postura'];
    final razasAves = ['COBB', 'ROSS', 'LOHMANN BROWN', 'HY-LINE', 'OTRA - ESPECIFIQUE'];

    // Crear una copia del ave existente o uno nuevo
    final ave = isEditing && index != null 
        ? AveModel(
            initialCategoria: controller.aves[index].categoria,
            initialRaza: controller.aves[index].raza,
            initialNumeroGalpon: controller.aves[index].numeroGalpon.text,
            initialEdad: controller.aves[index].edad.text,
            initialTotalAves: controller.aves[index].totalAves.text,
            initialObservaciones: controller.aves[index].observaciones.text,
          )
        : AveModel();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(isEditing ? 'Editar Lote de Aves' : 'Agregar Lote de Aves'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Número de Galpón
                      _styledField(
                        label: 'Número de Galpón',
                        child: TextFormField(
                          controller: ave.numeroGalpon,
                          decoration: _inputDecoration('Número de Galpón *'),
                          validator: (value) => 
                              value?.isEmpty ?? true ? 'Requerido' : null,
                        ),
                      ),

                      // Categoría
                      _styledField(
                        label: 'Categoría',
                        child: DropdownButtonFormField<String>(
                          value: ave.categoria,
                          decoration: _inputDecoration('Categoría *'),
                          items: categoriasAves.map((categoria) {
                            return DropdownMenuItem(
                              value: categoria,
                              child: Text(categoria),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              ave.categoria = value;
                              setState(() {});
                            }
                          },
                          validator: (value) => 
                              value == null ? 'Seleccione una categoría' : null,
                        ),
                      ),

                      // Raza
                      _styledField(
                        label: 'Raza',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButtonFormField<String>(
                              value: ave.raza,
                              decoration: _inputDecoration('Raza *'),
                              items: razasAves.map((raza) {
                                return DropdownMenuItem(
                                  value: raza,
                                  child: Text(raza),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  ave.raza = value;
                                  setState(() {});
                                }
                              },
                              validator: (value) => 
                                  value == null ? 'Seleccione una raza' : null,
                            ),
                            if (ave.raza == 'OTRA - ESPECIFIQUE')
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: TextFormField(
                                  controller: ave.otraRazaEspecifique,
                                  decoration: _inputDecoration('Especifique la raza *'),
                                  validator: (value) {
                                    if (ave.raza == 'OTRA - ESPECIFIQUE' && 
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

                      // Edad y Total de Aves
                      Row(
                        children: [
                          Expanded(
                            child: _styledField(
                              label: 'Edad (semanas)',
                              child: TextFormField(
                                controller: ave.edad,
                                decoration: _inputDecoration('Edad *'),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(3),
                                ],
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
                                decoration: _inputDecoration('Total *'),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: ave.validarTotalAves,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Observaciones
                      _styledField(
                        label: 'Observaciones',
                        child: TextFormField(
                          controller: ave.observaciones,
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
                        // Actualizar el ave existente
                        controller.aves[index] = ave;
                      } else {
                        // Agregar nuevo ave
                        controller.aves.add(ave);
                      }
                      controller.notifyListeners();
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