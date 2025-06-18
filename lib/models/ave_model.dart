import 'package:flutter/material.dart';

class AveModel {
  final TextEditingController numeroGalpon;
  final TextEditingController edad;
  final TextEditingController totalAves;
  final TextEditingController observaciones;
  
  String categoria;

  AveModel({
    String? initialCategoria,
    String? initialNumeroGalpon,
    String? initialEdad,
    String? initialTotalAves,
    String? initialObservaciones,
  }) : 
    categoria = initialCategoria ?? 'Engorde',
    numeroGalpon = TextEditingController(text: initialNumeroGalpon),
    edad = TextEditingController(text: initialEdad),
    totalAves = TextEditingController(text: initialTotalAves),
    observaciones = TextEditingController(text: initialObservaciones);

  Map<String, dynamic> toJson() {
    return {
      'numero_galpon': numeroGalpon.text,
      'categoria': categoria,
      'edad': int.tryParse(edad.text) ?? 0,
      'total': int.tryParse(totalAves.text) ?? 0,
      'observaciones': observaciones.text,
    };
  }

  void dispose() {
    numeroGalpon.dispose();
    edad.dispose();
    totalAves.dispose();
    observaciones.dispose();
  }
}