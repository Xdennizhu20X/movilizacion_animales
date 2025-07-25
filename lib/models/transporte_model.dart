import 'package:flutter/material.dart';

class TransporteModel {
  // Controladores actualizados
  final TextEditingController nombreTransportistaController = TextEditingController();
  final TextEditingController placaMatriculaController = TextEditingController();
  final TextEditingController telefonoTransportistaController = TextEditingController();
  final TextEditingController cedulaTransportistaController = TextEditingController();
  
  // Campos para tipo de transporte
  String tipoTransporte = 'terrestre'; // 'terrestre' o 'arreo'
  String tipoVia = 'terrestre'; // Mantenido por compatibilidad
  
  // Listas de opciones actualizadas
  final List<String> tiposTransporte = ['terrestre', 'arreo'];
  final List<String> tiposVia = ['terrestre']; // Solo terrestre ahora

Map<String, dynamic> toJson() {
  return {
    'tipo_transporte': tipoTransporte == 'terrestre' ? 'camión' : 'arreo',
    'es_terrestre': tipoTransporte == 'terrestre',
    'nombre_transportista': nombreTransportistaController.text,
    'cedula_transportista': cedulaTransportistaController.text,
    'placa': tipoTransporte == 'terrestre' 
        ? placaMatriculaController.text 
        : null,
    'telefono_transportista': telefonoTransportistaController.text,
  };
}


  bool isValid() {
    // Validación básica de campos requeridos
    bool camposValidos = nombreTransportistaController.text.isNotEmpty &&
        cedulaTransportistaController.text.isNotEmpty &&
        telefonoTransportistaController.text.isNotEmpty;
    
    // Si es transporte terrestre, validar también la placa
    if (tipoTransporte == 'terrestre') {
      camposValidos = camposValidos && placaMatriculaController.text.isNotEmpty;
    }
    
    // Validación de cédula (10 dígitos)
    final cedulaValida = cedulaTransportistaController.text.length == 10;
    
    return camposValidos && cedulaValida;
  }


  void dispose() {
    nombreTransportistaController.dispose();
    placaMatriculaController.dispose();
    telefonoTransportistaController.dispose();
    cedulaTransportistaController.dispose();
  }
}