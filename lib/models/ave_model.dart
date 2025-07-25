import 'package:flutter/material.dart';

class AveModel {
  final TextEditingController numeroGalpon;
  final TextEditingController edad;
  final TextEditingController totalAves;
  final TextEditingController observaciones;
  final TextEditingController otraRazaEspecifique;
  
  String categoria;
  String raza;

  // Constante para el límite máximo
  static const int maxAvesPorLote = 3000;

  AveModel({
    String? initialCategoria = 'Engorde',
    String? initialRaza,
    String? initialNumeroGalpon,
    String? initialEdad,
    String? initialTotalAves,
    String? initialObservaciones,
  }) : 
    categoria = initialCategoria ?? 'Engorde',
    raza = initialRaza ?? 'COBB',
    numeroGalpon = TextEditingController(text: initialNumeroGalpon),
    edad = TextEditingController(text: initialEdad),
    totalAves = TextEditingController(text: initialTotalAves),
    observaciones = TextEditingController(text: initialObservaciones),
    otraRazaEspecifique = TextEditingController();

  Map<String, dynamic> toJson() {
    return {
      'numero_galpon': numeroGalpon.text,
      'categoria': categoria,
      'raza': raza == 'OTRA - ESPECIFIQUE' ? otraRazaEspecifique.text : raza,
      'edad': int.tryParse(edad.text) ?? 0,
      'total': int.tryParse(totalAves.text) ?? 0,
      'observaciones': observaciones.text,
    };
  }

  // Método para validar el total de aves
  String? validarTotalAves(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    final total = int.tryParse(value);
    if (total == null) {
      return 'Ingrese un número válido';
    }
    if (total <= 0) {
      return 'Debe ser mayor a cero';
    }
    if (total > maxAvesPorLote) {
      return 'Máximo $maxAvesPorLote aves por lote';
    }
    return null;
  }

  void dispose() {
    numeroGalpon.dispose();
    edad.dispose();
    totalAves.dispose();
    observaciones.dispose();
    otraRazaEspecifique.dispose();
  }
}