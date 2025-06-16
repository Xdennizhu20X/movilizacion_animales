import 'package:flutter/material.dart';

class TransporteModel {
  final TextEditingController nombreTransportista = TextEditingController();
  final TextEditingController placa = TextEditingController();
  final TextEditingController telefonoTransportista = TextEditingController();
  final TextEditingController cedulaTransportista = TextEditingController();
  final TextEditingController detalleOtro = TextEditingController();
  
  String tipoTransporte = 'Camión';
  String tipoVia = 'Terrestre';
  
  final List<String> tiposTransporte = ['Camión', 'Camioneta', 'Otro'];
  final List<String> tiposVia = ['Terrestre', 'Marítimo', 'Aéreo'];

Map<String, dynamic> toJson() {
  return {
    'tipo_via': tipoVia,
    'tipo_transporte': tipoTransporte,
    'es_terrestre': tipoVia == 'Terrestre',
    'nombre_transportista': nombreTransportista.text,
    'cedula_transportista': cedulaTransportista.text,
    'placa': placa.text,
    'telefono_transportista': telefonoTransportista.text,
    if (tipoTransporte == 'Otro') 'detalle_otro': detalleOtro.text,
  };
}

  void dispose() {
    nombreTransportista.dispose();
    placa.dispose();
    telefonoTransportista.dispose();
    cedulaTransportista.dispose();
    detalleOtro.dispose();
  }
}