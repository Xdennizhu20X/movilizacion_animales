import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movilizacion_animales/services/auth_service.dart';

class UserService {
  static const String _baseUrl = 'http://51.178.31.63:3000/api/usuarios';

  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'No se encontró token de autenticación.',
        };
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/perfil'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'data': data['data']};
      } else {
        return {'success': false, 'message': data['message']};
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: \${e.toString()}',
      };
    }
  }
}
