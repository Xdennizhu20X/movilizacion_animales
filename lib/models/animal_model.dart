import 'package:flutter/material.dart';

class AnimalModel {
  final TextEditingController identificador = TextEditingController();
  final TextEditingController raza = TextEditingController();
  final TextEditingController color = TextEditingController();
  final TextEditingController edad = TextEditingController();
  final TextEditingController comerciante = TextEditingController();
  final TextEditingController observaciones = TextEditingController();

  String especie = 'bovino';         // Ahora coincide con el backend
  String categoria = 'adulto';       // Ejemplo: ternero, adulto, etc.
  String sexo = 'M';                 // M = macho, H = hembra, Otro

  Map<String, dynamic> toJson() {
    return {
      'especie': especie,
      'identificador': identificador.text,
      'categoria': categoria,
      'raza': raza.text,
      'sexo': sexo,
      'color': color.text,
      'edad': int.tryParse(edad.text) ?? 0,
      'comerciante': comerciante.text,
      'observaciones': observaciones.text,
    };
  }

  void dispose() {
    identificador.dispose();
    raza.dispose();
    color.dispose();
    edad.dispose();
    comerciante.dispose();
    observaciones.dispose();
  }
}
