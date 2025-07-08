import 'package:flutter/material.dart';

class PredioModel {
  // Campos del Predio de Origen
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController localidadController = TextEditingController();
  final TextEditingController sitioController = TextEditingController();
  final TextEditingController parroquiaController = TextEditingController();

  String condicionTenencia = 'Propio'; // Propio, Arrendado, Prestado
  final List<String> condicionTenenciaOptions = [
    'Propio',
    'Arrendado',
    'Prestado',
  ];

  // Campos del Destino (ahora con más campos)
  final TextEditingController nombreDestinoController = TextEditingController();
  final TextEditingController parroquiaDestinoController =
      TextEditingController();
  final TextEditingController direccionDestinoController =
      TextEditingController();

  // Para latitud y longitud puedes usar variables normales o TextEditingController si quieres entrada manual
  double? latitudDestino;
  final TextEditingController kilometroController = TextEditingController();
  double? longitudDestino;

  bool esCentroFaenamiento = false;

  // Observaciones generales
  final TextEditingController observacionesGeneralesController =
      TextEditingController();

  String? get observacionesGenerales =>
      observacionesGeneralesController.text.isNotEmpty
          ? observacionesGeneralesController.text
          : null;

  // Método para obtener datos del predio de origen
   Map<String, dynamic> toJsonPredioOrigen() {
    return {
      'nombre': nombreController.text,
      'localidad': localidadController.text,
      'sitio': sitioController.text,
      'parroquia': parroquiaController.text,
      'kilometro': double.tryParse(kilometroController.text) ?? 0.0,
      'es_centro_faenamiento': false, // o según tu lógica
      'latitud': null,
      'longitud': null,
      'tipo': 'origen',
      'condicion_tenencia': condicionTenencia,
    };
  }

  Map<String, dynamic> toJsonDestino() {
    return {
      'nombre_predio': nombreDestinoController.text,
      'parroquia': parroquiaDestinoController.text,
      'direccion': direccionDestinoController.text,
      'es_centro_faenamiento': esCentroFaenamiento, // bool
      'latitud': latitudDestino,
      'longitud': longitudDestino,
      'tipo': 'destino',
    };
  }

  // Método para obtener todos los datos en formato limpio y sin duplicados
  Map<String, dynamic> toJson() {
    return {
      'predio_origen': toJsonPredioOrigen(),
      'destino': toJsonDestino(),
      'observaciones_generales': observacionesGenerales,
    };
  }

  // Validaciones mejoradas para origen y destino
  bool isOrigenValid() {
    final double? kilometro = double.tryParse(kilometroController.text);
    return nombreController.text.isNotEmpty &&
        parroquiaController.text.isNotEmpty &&
        localidadController.text.isNotEmpty &&
        condicionTenencia.isNotEmpty;
  }

  bool isDestinoValid() {
    return nombreDestinoController.text.isNotEmpty &&
        parroquiaDestinoController.text.isNotEmpty &&
        direccionDestinoController.text.isNotEmpty;
  }

  bool isValid() {
    return isOrigenValid() && isDestinoValid();
  }

  void dispose() {
    nombreController.dispose();
    parroquiaController.dispose();
    localidadController.dispose();
    sitioController.dispose();
    kilometroController.dispose();
    nombreDestinoController.dispose();
    parroquiaDestinoController.dispose();
    direccionDestinoController.dispose();
    observacionesGeneralesController.dispose();
  }
}
