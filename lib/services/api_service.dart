// api_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart'; // Para kIsWeb
import 'package:open_file/open_file.dart';
import 'dart:html' as html;


class ApiService {
  static const String _baseUrl =
      'https://back-abg.onrender.com/api'; // URL base de tu API
  static const int _timeoutSeconds = 30; // Timeout para las solicitudes

  // Método privado para obtener headers con autenticación
  static Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Obtener el token almacenado
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Método genérico para manejar respuestas HTTP
  static dynamic _handleResponse(http.Response response) {
    final responseData = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return responseData;
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: responseData['message'] ?? 'Error desconocido',
        errors: responseData['errors'],
      );
    }
  }

  static Future<bool> _isOnline() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  // Método para enviar la solicitud
  static Future<Map<String, dynamic>> enviarSolicitud(
    Map<String, dynamic> datos,
  ) async {
    try {
      final url = Uri.parse('$_baseUrl/movilizaciones/registro-completo');
      final response = await http
          .post(url, headers: await _getHeaders(), body: jsonEncode(datos))
          .timeout(const Duration(seconds: _timeoutSeconds));

      return _handleResponse(response);
    } on http.ClientException catch (e) {
      throw ApiException(message: 'Error de conexión: ${e.message}');
    } on TimeoutException {
      // Now properly imported
      throw ApiException(message: 'Tiempo de espera agotado');
    } catch (e) {
      throw ApiException(message: 'Error inesperado: $e');
    }
  }

  

  // Método para obtener solicitudes (ejemplo adicional)
  static Future<List<dynamic>> obtenerMisMovilizaciones({
    String? estado,
    String? fechaInicio,
    String? fechaFin,
  }) async {
    try {
      // Construir la URL con parámetros de consulta si existen
      final params = <String, String>{};
      if (estado != null) params['estado'] = estado;
      if (fechaInicio != null) params['fecha_inicio'] = fechaInicio;
      if (fechaFin != null) params['fecha_fin'] = fechaFin;

      final url = Uri.parse(
        '$_baseUrl/movilizaciones',
      ).replace(queryParameters: params.isNotEmpty ? params : null);

      final response = await http
          .get(url, headers: await _getHeaders())
          .timeout(const Duration(seconds: _timeoutSeconds));

      final responseData = _handleResponse(response);
      if (responseData is Map<String, dynamic> && responseData.containsKey('data') && responseData['data'] is List) {
        return responseData['data'];
      }
      return responseData;
    } on http.ClientException catch (e) {
      throw ApiException(message: 'Error de conexión: ${e.message}');
    } on TimeoutException {
      throw ApiException(message: 'Tiempo de espera agotado');
    } catch (e) {
      throw ApiException(message: 'Error al obtener movilizaciones: $e');
    }
  }

  static Future<void> descargarCertificadoPdf(int movilizacionId) async {
    try {
      final url = '$_baseUrl/movilizaciones/$movilizacionId/certificado';
      final token = await _getToken();
      final headers = {'Authorization': 'Bearer $token'};

      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: _timeoutSeconds));

      if (response.statusCode == 200) {
        if (kIsWeb) {
          // Implementación para web
          final bytes = response.bodyBytes;
          final blob = html.Blob([bytes]);
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor =
              html.document.createElement('a') as html.AnchorElement
                ..href = url
                ..style.display = 'none'
                ..download = 'certificado_$movilizacionId.pdf';
          html.document.body?.children.add(anchor);
          anchor.click();
          html.document.body?.children.remove(anchor);
          html.Url.revokeObjectUrl(url);
        } else {
          // Implementación para móvil con verificación de null
          final directory = await getDownloadsDirectory();
          if (directory != null) {
            final filePath =
                '${directory.path}/certificado_$movilizacionId.pdf';
            final file = File(filePath);
            await file.writeAsBytes(response.bodyBytes);
            await OpenFile.open(filePath);
          } else {
            throw ApiException(
              message: 'No se pudo acceder al directorio de descargas',
            );
          }
        }
      } else {
        throw ApiException(
          statusCode: response.statusCode,
          message: 'Error al descargar el certificado',
        );
      }
    } on TimeoutException {
      throw ApiException(message: 'Tiempo de espera agotado');
    } catch (e) {
      throw ApiException(message: 'Error al descargar PDF: $e');
    }
  }
}

// Puedes agregar más métodos para otras operaciones aquí

// Clase para manejar excepciones de la API
class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final dynamic errors;

  ApiException({this.statusCode, required this.message, this.errors});

  @override
  String toString() {
    return 'ApiException: $message${statusCode != null ? ' (Código: $statusCode)' : ''}';
  }
}
