import 'package:flutter/material.dart';

class PredioModel {
  // Campos del Predio de Origen
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController localidadController = TextEditingController();
  final TextEditingController sitioController = TextEditingController();
  final TextEditingController parroquiaController = TextEditingController();
  final TextEditingController ubicacionOrigenController = TextEditingController();

  String condicionTenencia = 'Propio'; // Propio, Arrendado, Prestado
  final List<String> condicionTenenciaOptions = [
    'Propio',
    'Arrendado',
    'Prestado',
  ];

  // Campos del Destino
  final TextEditingController nombreDestinoController = TextEditingController();
  final TextEditingController parroquiaDestinoController = TextEditingController();
  final TextEditingController ubicacionDestinoController = TextEditingController();

  // Coordenadas
  double? latitudDestino;
  double? longitudDestino;
  final TextEditingController kilometroController = TextEditingController();

  bool _esCentroFaenamiento = false;
  bool get esCentroFaenamiento => _esCentroFaenamiento;
  
  set esCentroFaenamiento(bool value) {
    _esCentroFaenamiento = value;
    if (value) {
      // Establecer valores predeterminados cuando es centro de faenamiento
      nombreDestinoController.text = 'Faenamiento Santa Cruz';
      parroquiaDestinoController.text = 'Santa Cruz';
      ubicacionDestinoController.text = 'Santa Cruz';
    } else {
      // Limpiar los campos si se desmarca
      nombreDestinoController.clear();
      parroquiaDestinoController.clear();
      ubicacionDestinoController.clear();
    }
  }

  // Observaciones generales
  final TextEditingController observacionesGeneralesController = TextEditingController();

  String? get observacionesGenerales =>
      observacionesGeneralesController.text.isNotEmpty
          ? observacionesGeneralesController.text
          : null;

  // Predio de Origen
  Map<String, dynamic> toJsonPredioOrigen() {
    return {
      'nombre': nombreController.text,
      'localidad': localidadController.text,
      'sitio': sitioController.text,
      'parroquia': parroquiaController.text,
      'kilometro': double.tryParse(kilometroController.text) ?? 0.0,
      'es_centro_faenamiento': false,
      'latitud': 0.0,
      'longitud': 0.0,
      'ubicacion': ubicacionOrigenController.text.isNotEmpty
          ? ubicacionOrigenController.text
          : "Ubicación no especificada",
      'tipo': 'origen',
      'condicion_tenencia': condicionTenencia,
    };
  }

  // Predio de Destino
  Map<String, dynamic> toJsonDestino() {
    return {
      'nombre_predio': nombreDestinoController.text,
      'parroquia': parroquiaDestinoController.text,
      'ubicacion': ubicacionDestinoController.text.isNotEmpty
          ? ubicacionDestinoController.text
          : "Ubicación no especificada",
      'es_centro_faenamiento': esCentroFaenamiento,
      'latitud': latitudDestino ?? 0.0,
      'longitud': longitudDestino ?? 0.0,
      'tipo': 'destino',
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'predio_origen': toJsonPredioOrigen(),
      'destino': toJsonDestino(),
      'observaciones_generales': observacionesGenerales,
    };
  }

  // Validaciones
  bool isOrigenValid() {
    final double? kilometro = double.tryParse(kilometroController.text);
    return nombreController.text.isNotEmpty &&
        parroquiaController.text.isNotEmpty &&
        localidadController.text.isNotEmpty &&
        condicionTenencia.isNotEmpty;
  }

  bool isDestinoValid() {
    return nombreDestinoController.text.isNotEmpty &&
        parroquiaDestinoController.text.isNotEmpty;
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
    ubicacionOrigenController.dispose();
    nombreDestinoController.dispose();
    parroquiaDestinoController.dispose();
    ubicacionDestinoController.dispose();
    observacionesGeneralesController.dispose();
  }
}