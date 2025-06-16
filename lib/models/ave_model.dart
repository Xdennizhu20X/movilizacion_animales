import 'package:flutter/material.dart';

class AveModel {
  final TextEditingController numeroGalpon = TextEditingController();
  final TextEditingController edad = TextEditingController();
  final TextEditingController totalAves = TextEditingController();
  final TextEditingController observaciones = TextEditingController();
  
  String categoria = 'Engorde';

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