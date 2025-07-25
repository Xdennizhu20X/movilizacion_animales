import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimalModel {
  // Controladores para campos de texto editables
  final TextEditingController identificador = TextEditingController();
  final TextEditingController color = TextEditingController();
  final TextEditingController edad = TextEditingController();
  final TextEditingController comerciante = TextEditingController();
  final TextEditingController observaciones = TextEditingController();
  final TextEditingController otraRazaEspecifique = TextEditingController();

  // Valores seleccionables en dropdowns
  String especie = 'bovino';
  String categoria = 'adulto';
  String sexo = 'M'; // M = Macho, H = Hembra
  String? razaSeleccionada;

  // Listas de opciones para los dropdowns
  static const List<String> especies = ['bovino', 'porcino', 'ave'];
  static const List<String> categorias = ['ternero', 'adulto', 'joven'];
  static const List<String> sexos = ['M', 'H'];
  
  // Razas organizadas por especie
  static const Map<String, List<String>> razasPorEspecie = {
    'bovino': [
      'GIROLANDO (GYR HOLSTEIN)',
      'HOLSTEIN ROJO',
      'HOLSTEIN NEGRO',
      'JERSEY',
      'JERSEY NEOZELANDES',
      'SIMMENTAL',
      'BROWN SWISS',
      'CHAROLAIS-CHAROLESA',
      'NORMANDO',
      'SENEPOL',
      'GYR',
      'BOMBALIER',
      'ANGUS NEGRO',
      'ANGUS ROJO',
      'BRAFORD',
      'BRAHMAN',
      'BRANGUS',
      'LIDIA',
      'SANTA GERTRUDIS',
      'YAKUR',
      'SINDHI',
      'GUZERAT',
      'CRUZADO',
      'OTRA - ESPECIFIQUE'
    ],
    'porcino': [
      'YORKSHIRE',
      'LANDRACE',
      'DUROC',
      'PIETRAIN',
      'HAMPSHIRE',
      'BLANCO BELGA',
      'LARGE WHITE',
      'CRUZADO',
      'OTRA - ESPECIFIQUE'
    ],
    'ave': [
      'COBB',
      'ROSS',
      'LOHMANN BROWN',
      'HY-LINE',
      'OTRA - ESPECIFIQUE'
    ],
  };

  // Método para obtener las razas disponibles según la especie actual
  List<String> get razasDisponibles {
    return razasPorEspecie[especie] ?? [];
  }

  // Validación para el campo de identificación
  static String? validarIdentificador(String? value) {
    if (value == null || value.isEmpty) {
      return 'El identificador es requerido';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Solo se permiten números';
    }
    if (value.length > 15) {
      return 'Máximo 15 dígitos';
    }
    return null;
  }

  // Formateadores para el campo de identificación
  static List<TextInputFormatter> get identificadorInputFormatters => [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(15),
  ];

  // Validación para el campo "Otra raza (especifique)"
  String? validarOtraRaza(String? value) {
    if (razaSeleccionada == 'OTRA - ESPECIFIQUE' && (value == null || value.isEmpty)) {
      return 'Por favor especifique la raza';
    }
    return null;
  }

  // Método para crear una copia profunda del modelo
  AnimalModel copyWith() {
    final nuevoAnimal = AnimalModel();
    
    // Copiar valores de los controladores
    nuevoAnimal.identificador.text = identificador.text;
    nuevoAnimal.color.text = color.text;
    nuevoAnimal.edad.text = edad.text;
    nuevoAnimal.comerciante.text = comerciante.text;
    nuevoAnimal.observaciones.text = observaciones.text;
    nuevoAnimal.otraRazaEspecifique.text = otraRazaEspecifique.text;
    
    // Copiar valores seleccionables
    nuevoAnimal.especie = especie;
    nuevoAnimal.categoria = categoria;
    nuevoAnimal.sexo = sexo;
    nuevoAnimal.razaSeleccionada = razaSeleccionada;
    
    return nuevoAnimal;
  }

  // Convertir el modelo a formato JSON para enviar al servidor
  Map<String, dynamic> toJson() {
    return {
      'especie': especie,
      'identificador': identificador.text,
      'categoria': categoria,
      'raza': razaSeleccionada == 'OTRA - ESPECIFIQUE' 
          ? otraRazaEspecifique.text 
          : razaSeleccionada,
      'sexo': sexo,
      'color': color.text,
      'edad': int.tryParse(edad.text) ?? 0,
      'comerciante': comerciante.text,
      'observaciones': observaciones.text,
    };
  }

  // Limpieza de los controladores cuando ya no se necesiten
  void dispose() {
    identificador.dispose();
    color.dispose();
    edad.dispose();
    comerciante.dispose();
    observaciones.dispose();
    otraRazaEspecifique.dispose();
  }

  // Método para reiniciar/resetear el modelo
  void reset() {
    identificador.clear();
    color.clear();
    edad.clear();
    comerciante.clear();
    observaciones.clear();
    otraRazaEspecifique.clear();
    
    especie = 'bovino';
    categoria = 'adulto';
    sexo = 'M';
    razaSeleccionada = null;
  }
}