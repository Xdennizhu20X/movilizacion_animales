import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RequestScreen extends StatefulWidget {
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();

  final String _fechaActual = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  String? _especieSeleccionada;
  int _cantidadAnimales = 0;

  String? _provinciaOrigen, _cantonOrigen, _parroquiaOrigen, _direccionOrigen;
  String? _provinciaDestino, _cantonDestino, _parroquiaDestino, _direccionDestino;

  bool _transportePropio = true;
  String? _placaVehiculo, _nombreTransportista;
  String? _tipoTransporte;
  String? _cedulaTransportista, _telefonoTransportista, _detalleOtroTransporte;

  List<Map<String, TextEditingController>> animales = [];

  final Color yellowColor = Color(0xFFFFD100);
  final Color blueColor = Color(0xFF003399);
  final Color redColor = Color(0xFFCE1126);

  InputDecoration _inputDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon, color: blueColor) : null,
      labelStyle: TextStyle(color: blueColor),
      filled: true,
      fillColor: yellowColor.withOpacity(0.1),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: blueColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: redColor, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: redColor,
        title: Text('Solicitar Movilización', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Fecha actual: $_fechaActual', style: TextStyle(color: Colors.grey)),
              SizedBox(height: 16),
              TextFormField(
                controller: _nombreController,
                decoration: _inputDecoration('Nombre completo', icon: Icons.person),
                validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _cedulaController,
                decoration: _inputDecoration('Cédula', icon: Icons.credit_card),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _telefonoController,
                decoration: _inputDecoration('Teléfono', icon: Icons.phone),
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _especieSeleccionada,
                decoration: _inputDecoration('Especie del animal', icon: Icons.pets),
                items: ['Bovino', 'Porcino', 'Ovino', 'Caprino', 'Aves']
                    .map((especie) => DropdownMenuItem(
                          value: especie,
                          child: Text(especie),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _especieSeleccionada = value),
                validator: (value) => value == null ? 'Selecciona una especie' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: _inputDecoration('Cantidad de animales', icon: Icons.numbers),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Campo obligatorio';
                  final cantidad = int.tryParse(value);
                  if (cantidad == null || cantidad <= 0) return 'Cantidad inválida';
                  return null;
                },
                onChanged: (value) {
                  final cantidad = int.tryParse(value) ?? 0;
                  setState(() {
                    _cantidadAnimales = cantidad;
                    _generateAnimalInputs(_cantidadAnimales);
                  });
                },
              ),
              SizedBox(height: 24),
              if (animales.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Datos por animal:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: redColor)),
                    ...animales
                        .asMap()
                        .entries
                        .map((entry) => _buildAnimalCard(entry.key, entry.value))
                        .toList(),
                  ],
                ),
              SizedBox(height: 24),
              _buildSection('Información de Origen', [
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration('Provincia de origen', icon: Icons.map),
                  items: ['Pichincha', 'Guayas', 'Manabí']
                      .map((prov) => DropdownMenuItem(value: prov, child: Text(prov)))
                      .toList(),
                  onChanged: (value) => setState(() => _provinciaOrigen = value),
                  validator: (value) => value == null ? 'Selecciona una provincia' : null,
                ),
                TextFormField(
                  decoration: _inputDecoration('Cantón de origen', icon: Icons.location_city),
                  onChanged: (value) => _cantonOrigen = value,
                ),
                TextFormField(
                  decoration: _inputDecoration('Parroquia de origen'),
                  onChanged: (value) => _parroquiaOrigen = value,
                ),
                TextFormField(
                  decoration: _inputDecoration('Dirección exacta de origen', icon: Icons.home),
                  onChanged: (value) => _direccionOrigen = value,
                ),
              ]),
              _buildSection('Información de Destino', [
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration('Provincia de destino', icon: Icons.map),
                  items: ['Pichincha', 'Guayas', 'Manabí']
                      .map((prov) => DropdownMenuItem(value: prov, child: Text(prov)))
                      .toList(),
                  onChanged: (value) => setState(() => _provinciaDestino = value),
                  validator: (value) => value == null ? 'Selecciona una provincia' : null,
                ),
                TextFormField(
                  decoration: _inputDecoration('Cantón de destino'),
                  onChanged: (value) => _cantonDestino = value,
                ),
                TextFormField(
                  decoration: _inputDecoration('Parroquia de destino'),
                  onChanged: (value) => _parroquiaDestino = value,
                ),
                TextFormField(
                  decoration: _inputDecoration('Dirección exacta de destino'),
                  onChanged: (value) => _direccionDestino = value,
                ),
              ]),
              _buildSection('Transporte', [
                SwitchListTile(
                  title: Text('¿Usarás transporte propio?'),
                  value: _transportePropio,
                  onChanged: (value) => setState(() => _transportePropio = value),
                ),
                DropdownButtonFormField<String>(
                  value: _tipoTransporte,
                  decoration: _inputDecoration('Tipo de transporte'),
                  items: ['Terrestre', 'Otro']
                      .map((tipo) => DropdownMenuItem(value: tipo, child: Text(tipo)))
                      .toList(),
                  onChanged: (value) => setState(() => _tipoTransporte = value),
                  validator: (value) => value == null ? 'Selecciona un tipo de transporte' : null,
                ),
                if (_tipoTransporte == 'Terrestre') ...[
                  TextFormField(
                    decoration: _inputDecoration('Nombre del transportista', icon: Icons.person),
                    onChanged: (value) => _nombreTransportista = value,
                  ),
                  TextFormField(
                    decoration: _inputDecoration('Número de matrícula o placa'),
                    onChanged: (value) => _placaVehiculo = value,
                  ),
                  TextFormField(
                    decoration: _inputDecoration('Cédula de identidad'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _cedulaTransportista = value,
                  ),
                  TextFormField(
                    decoration: _inputDecoration('Teléfono'),
                    keyboardType: TextInputType.phone,
                    onChanged: (value) => _telefonoTransportista = value,
                  ),
                ] else if (_tipoTransporte == 'Otro') ...[
                  TextFormField(
                    decoration: _inputDecoration('Detalle del otro transporte'),
                    onChanged: (value) => _detalleOtroTransporte = value,
                  ),
                ],
              ]),
              SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueColor,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Enviar Solicitud', style: TextStyle(fontSize: 18, color: Colors.white)),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Resumen'),
                        content: Text('Formulario completo. ¿Deseas enviar?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _enviarFormulario();
                            },
                            child: Text('Enviar'),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: redColor)),
            SizedBox(height: 12),
            ...children.map((e) => Padding(padding: EdgeInsets.symmetric(vertical: 4), child: e)).toList(),
          ],
        ),
      ),
    );
  }

  void _generateAnimalInputs(int cantidad) {
    animales = List.generate(cantidad, (index) {
      return {
        'identificacion': TextEditingController(),
        'categoria': TextEditingController(),
        'raza': TextEditingController(),
        'sexo': TextEditingController(),
        'color': TextEditingController(),
        'edad': TextEditingController(),
        'comerciante': TextEditingController(),
        'observaciones': TextEditingController(),
      };
    });
  }

  Widget _buildAnimalCard(int index, Map<String, TextEditingController> animal) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Animal #${index + 1}', style: TextStyle(fontWeight: FontWeight.bold, color: blueColor)),
            ...animal.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: TextFormField(
                  controller: entry.value,
                  decoration: _inputDecoration(_capitalize(entry.key)),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _enviarFormulario() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Formulario enviado con éxito.')),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1);
  }
}
