import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../services/api_service.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  
  // Controllers para campos básicos
  final _predioOrigenController = TextEditingController();
  final _parroquiaOrigenController = TextEditingController();
  final _ubicacionOrigenController = TextEditingController();
  final _centroFaenamientoController = TextEditingController();
  final _ubicacionDestinoController = TextEditingController();
  final _nombrePredioDestinoController = TextEditingController();
  final _direccionDestinoController = TextEditingController();
  final _parroquiaDestinoController = TextEditingController();
  final _observacionesGeneralesController = TextEditingController();
  
  // Controllers para transporte
  final _nombreTransportistaController = TextEditingController();
  final _placaController = TextEditingController();
  final _telefonoTransportistaController = TextEditingController();
  final _cedulaTransportistaController = TextEditingController();
  final _detalleOtroController = TextEditingController();
  
  // Listas para animales y aves
  final List<Map<String, dynamic>> _animales = [];
  final List<Map<String, dynamic>> _aves = [];
  
  // Variables de estado
  String _selectedTipoTransporte = 'Camión';
  String _selectedTipoVia = 'Terrestre';
  String _selectedDatosAdicionales = 'Propio';
  bool _isLoading = false;
  
  // Opciones para dropdowns
  final List<String> _tiposTransporte = ['Camión', 'Camioneta', 'Otro'];
  final List<String> _tiposVia = ['Terrestre', 'Marítimo', 'Aéreo'];
  final List<String> _datosAdicionales = ['Propio', 'Arrendado', 'Prestado'];
  final List<String> _categoriasBovino = ['Bovino', 'Porcino', 'Ovino', 'Caprino'];
  final List<String> _sexos = ['M', 'H'];
  final List<String> _categoriasAves = ['Engorde', 'Postura', 'Reproductoras'];

  @override
  void initState() {
    super.initState();
    _agregarAnimal();
    _agregarAve();
  }

  @override
  void dispose() {
    _predioOrigenController.dispose();
    _parroquiaOrigenController.dispose();
    _ubicacionOrigenController.dispose();
    _centroFaenamientoController.dispose();
    _ubicacionDestinoController.dispose();
    _nombrePredioDestinoController.dispose();
    _direccionDestinoController.dispose();
    _parroquiaDestinoController.dispose();
    _observacionesGeneralesController.dispose();
    _nombreTransportistaController.dispose();
    _placaController.dispose();
    _telefonoTransportistaController.dispose();
    _cedulaTransportistaController.dispose();
    _detalleOtroController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _agregarAnimal() {
    setState(() {
      _animales.add({
        'identificador': TextEditingController(),
        'categoria': 'Bovino',
        'raza': TextEditingController(),
        'sexo': 'M',
        'color': TextEditingController(),
        'edad': TextEditingController(),
        'comerciante': TextEditingController(),
        'observaciones': TextEditingController(),
      });
    });
  }

  void _eliminarAnimal(int index) {
    if (_animales.length > 1) {
      setState(() {
        _animales[index]['identificador'].dispose();
        _animales[index]['raza'].dispose();
        _animales[index]['color'].dispose();
        _animales[index]['edad'].dispose();
        _animales[index]['comerciante'].dispose();
        _animales[index]['observaciones'].dispose();
        _animales.removeAt(index);
      });
    }
  }

  void _agregarAve() {
    setState(() {
      _aves.add({
        'numero_galpon': TextEditingController(),
        'categoria': 'Engorde',
        'edad': TextEditingController(),
        'total_aves': TextEditingController(),
        'observaciones': TextEditingController(),
      });
    });
  }

  void _eliminarAve(int index) {
    if (_aves.length > 1) {
      setState(() {
        _aves[index]['numero_galpon'].dispose();
        _aves[index]['edad'].dispose();
        _aves[index]['total_aves'].dispose();
        _aves[index]['observaciones'].dispose();
        _aves.removeAt(index);
      });
    }
  }

  Future<void> _enviarSolicitud() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final datos = {
        'fecha': DateTime.now().toIso8601String().split('T')[0],
        'animales': _animales.map((animal) => {
          'identificador': animal['identificador'].text,
          'categoria': animal['categoria'],
          'raza': animal['raza'].text,
          'sexo': animal['sexo'],
          'color': animal['color'].text,
          'edad': int.tryParse(animal['edad'].text) ?? 0,
          'comerciante': animal['comerciante'].text,
          'observaciones': animal['observaciones'].text,
        }).toList(),
        'aves': _aves.isNotEmpty ? _aves.map((ave) => {
          'numero_galpon': ave['numero_galpon'].text,
          'categoria': ave['categoria'],
          'edad': int.tryParse(ave['edad'].text) ?? 0,
          'total': int.tryParse(ave['total_aves'].text) ?? 0,
          'observaciones': ave['observaciones'].text,
        }).toList() : [],
        'predio_origen': {
          'nombre': _predioOrigenController.text,
          'parroquia': _parroquiaOrigenController.text,
          'ubicacion': _ubicacionOrigenController.text,
          'datos_adicionales': _selectedDatosAdicionales, // Cambiado a string directo
        },
        'destino': {
          'centro_faenamiento': _centroFaenamientoController.text,
          'ubicacion': _ubicacionDestinoController.text,
          'nombre_predio': _nombrePredioDestinoController.text,
          'direccion': _direccionDestinoController.text,
          'parroquia': _parroquiaDestinoController.text,
        },
        'transporte': {
          'tipo_via': _selectedTipoVia,
          'tipo_transporte': _selectedTipoTransporte,
          'nombre_transportista': _nombreTransportistaController.text,
          'cedula_transportista': _cedulaTransportistaController.text,
          'placa': _placaController.text,
          'telefono_transportista': _telefonoTransportistaController.text,
        },
        'datos_adicionales': {
          'observaciones_generales': _observacionesGeneralesController.text.isNotEmpty 
              ? _observacionesGeneralesController.text 
              : null,
        },
      };

      // Debug: Mostrar JSON
      debugPrint('=== JSON ENVIADO ===');
      debugPrint(jsonEncode(datos));
      
      // Enviar a la API
      final response = await ApiService.enviarSolicitud(datos);
      
      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solicitud enviada exitosamente'),
          backgroundColor: Colors.red,
        ),
      );
      
      // Limpiar formulario después de enviar
      _formKey.currentState?.reset();
      Navigator.pop(context);
      
    } catch (e) {
      debugPrint('=== ERROR ===');
      debugPrint(e.toString());
      
      String errorMessage = 'Error al enviar solicitud';
      
      if (e is ApiException) {
        errorMessage = e.message ?? errorMessage;
        if (e.statusCode == 400) {
          errorMessage = 'Datos incompletos o incorrectos. Verifique toda la información.';
        }
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Solicitud de Movilización'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: Scrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sección de Predios
                _buildSectionTitle('Información de Predios'),
                _buildPredioSection(),
                
                const SizedBox(height: 24),
                
                // Sección de Transporte
                _buildSectionTitle('Información de Transporte'),
                _buildTransporteSection(),
                
                const SizedBox(height: 24),
                
                // Sección de Animales
                _buildSectionTitle('Animales'),
                _buildAnimalesSection(),
                
                const SizedBox(height: 24),
                
                // Sección de Aves (Opcional)
                _buildSectionTitle('Aves (Opcional)'),
                _buildAvesSection(),
                
                const SizedBox(height: 24),
                
                // Observaciones Generales
                _buildSectionTitle('Observaciones Generales'),
                TextFormField(
                  controller: _observacionesGeneralesController,
                  decoration: const InputDecoration(
                    labelText: 'Observaciones generales',
                    border: OutlineInputBorder(),
                    hintText: 'Ingrese observaciones generales si las hay',
                  ),
                  maxLines: 3,
                ),
                
                const SizedBox(height: 32),
                
                // Botón de envío
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _enviarSolicitud,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Enviar Solicitud', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _buildPredioSection() {
    return Column(
      children: [
        // Predio de Origen
        const Text('Predio de Origen', 
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _predioOrigenController,
          decoration: const InputDecoration(
            labelText: 'Nombre del Predio de Origen *',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es requerido';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _parroquiaOrigenController,
          decoration: const InputDecoration(
            labelText: 'Parroquia de Origen *',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es requerido';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _ubicacionOrigenController,
          decoration: const InputDecoration(
            labelText: 'Ubicación del Predio de Origen *',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es requerido';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _selectedDatosAdicionales,
          decoration: const InputDecoration(
            labelText: 'Tipo de Propiedad *',
            border: OutlineInputBorder(),
          ),
          items: _datosAdicionales.map((tipo) {
            return DropdownMenuItem(value: tipo, child: Text(tipo));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedDatosAdicionales = value!;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Seleccione una opción';
            }
            return null;
          },
        ),
        
        const SizedBox(height: 24),
        
        // Destino
        const Text('Destino', 
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _centroFaenamientoController,
          decoration: const InputDecoration(
            labelText: 'Centro de Faenamiento *',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es requerido';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _ubicacionDestinoController,
          decoration: const InputDecoration(
            labelText: 'Ubicación del Centro *',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es requerido';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _nombrePredioDestinoController,
          decoration: const InputDecoration(
            labelText: 'Nombre del Predio de Destino *',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es requerido';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _direccionDestinoController,
          decoration: const InputDecoration(
            labelText: 'Dirección de Destino *',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es requerido';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _parroquiaDestinoController,
          decoration: const InputDecoration(
            labelText: 'Parroquia de Destino *',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es requerido';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTransporteSection() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: _selectedTipoVia,
          decoration: const InputDecoration(
            labelText: 'Tipo de Vía *',
            border: OutlineInputBorder(),
          ),
          items: _tiposVia.map((tipo) {
            return DropdownMenuItem(value: tipo, child: Text(tipo));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedTipoVia = value!;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Seleccione una opción';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _selectedTipoTransporte,
          decoration: const InputDecoration(
            labelText: 'Tipo de Transporte *',
            border: OutlineInputBorder(),
          ),
          items: _tiposTransporte.map((tipo) {
            return DropdownMenuItem(value: tipo, child: Text(tipo));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedTipoTransporte = value!;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Seleccione una opción';
            }
            return null;
          },
        ),
        if (_selectedTipoTransporte == 'Otro') ...[
          const SizedBox(height: 12),
          TextFormField(
            controller: _detalleOtroController,
            decoration: const InputDecoration(
              labelText: 'Especifique el tipo de transporte *',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (_selectedTipoTransporte == 'Otro' && (value == null || value.isEmpty)) {
                return 'Este campo es requerido';
              }
              return null;
            },
          ),
        ],
        const SizedBox(height: 12),
        TextFormField(
          controller: _nombreTransportistaController,
          decoration: const InputDecoration(
            labelText: 'Nombre del Transportista *',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es requerido';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _cedulaTransportistaController,
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
          controller: _placaController,
          decoration: const InputDecoration(
            labelText: 'Placa del Vehículo *',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es requerido';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _telefonoTransportistaController,
          decoration: const InputDecoration(
            labelText: 'Teléfono del Transportista *',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es requerido';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAnimalesSection() {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _animales.length,
          itemBuilder: (context, index) {
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
                        Text('Animal ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        if (_animales.length > 1)
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _eliminarAnimal(index),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _animales[index]['identificador'],
                      decoration: const InputDecoration(
                        labelText: 'Identificador',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _animales[index]['categoria'],
                      decoration: const InputDecoration(
                        labelText: 'Categoría *',
                        border: OutlineInputBorder(),
                      ),
                      items: _categoriasBovino.map((categoria) {
                        return DropdownMenuItem(value: categoria, child: Text(categoria));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _animales[index]['categoria'] = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Seleccione una categoría';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _animales[index]['raza'],
                            decoration: const InputDecoration(
                              labelText: 'Raza *',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Requerido';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _animales[index]['sexo'],
                            decoration: const InputDecoration(
                              labelText: 'Sexo *',
                              border: OutlineInputBorder(),
                            ),
                            items: _sexos.map((sexo) {
                              return DropdownMenuItem(
                                value: sexo, 
                                child: Text(sexo == 'M' ? 'Macho' : 'Hembra')
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _animales[index]['sexo'] = value!;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Seleccione sexo';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _animales[index]['color'],
                            decoration: const InputDecoration(
                              labelText: 'Color *',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Requerido';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _animales[index]['edad'],
                            decoration: const InputDecoration(
                              labelText: 'Edad (años) *',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Requerido';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _animales[index]['comerciante'],
                      decoration: const InputDecoration(
                        labelText: 'Comerciante *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo es requerido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _animales[index]['observaciones'],
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
          onPressed: _agregarAnimal,
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

  Widget _buildAvesSection() {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _aves.length,
          itemBuilder: (context, index) {
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
                        Text('Aves ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        if (_aves.length > 1)
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _eliminarAve(index),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _aves[index]['numero_galpon'],
                      decoration: const InputDecoration(
                        labelText: 'Número de Galpón *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo es requerido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _aves[index]['categoria'],
                      decoration: const InputDecoration(
                        labelText: 'Categoría *',
                        border: OutlineInputBorder(),
                      ),
                      items: _categoriasAves.map((categoria) {
                        return DropdownMenuItem(value: categoria, child: Text(categoria));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _aves[index]['categoria'] = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Seleccione una categoría';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _aves[index]['edad'],
                            decoration: const InputDecoration(
                              labelText: 'Edad (semanas) *',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Requerido';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _aves[index]['total_aves'],
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
                      controller: _aves[index]['observaciones'],
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
          onPressed: _agregarAve,
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