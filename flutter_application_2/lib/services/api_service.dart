// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _baseUrl = 'http://192.168.0.4:3000';

  Future<Map<String, dynamic>> register(
    String username,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      final responseBody = json.decode(response.body);
      final String token = responseBody['token'];
      final String userId = responseBody['user']['id'];
      final String userName = responseBody['user']['username'];
      final String userEmail = responseBody['user']['email'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
      await prefs.setString('user_id', userId);
      await prefs.setString('user_name', userName);
      await prefs.setString('user_email', userEmail);

      return {
        'success': true,
        'message': 'Cadastro realizado com sucesso!',
        'token': token,
        'user': responseBody['user'],
      };
    } else {
      final errorBody = json.decode(response.body);
      throw Exception(
        errorBody['message'] ?? 'Erro ao registrar usuário. Tente novamente.',
      );
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final String token = responseBody['token'];
      final String userId = responseBody['user']['id'];
      final String userName = responseBody['user']['username'];
      final String userEmail = responseBody['user']['email'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
      await prefs.setString('user_id', userId);
      await prefs.setString('user_name', userName);
      await prefs.setString('user_email', userEmail);

      return {
        'success': true,
        'message': 'Login realizado com sucesso!',
        'token': token,
        'user': responseBody['user'],
      };
    } else {
      final errorBody = json.decode(response.body);
      throw Exception(
        errorBody['message'] ??
            'Credenciais inválidas. Verifique e-mail e senha.',
      );
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('user_id');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  Future<dynamic> _get(String path) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Não autenticado. Faça login novamente.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl$path'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decodedBody = json.decode(response.body);
      if (decodedBody is List) {
        return {'data': decodedBody};
      }
      return decodedBody;
    } else {
      final errorBody = json.decode(response.body);
      throw Exception(
        errorBody['erro'] ?? errorBody['message'] ?? 'Erro ao buscar dados.',
      );
    }
  }

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> data,
  ) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Não autenticado. Faça login novamente.');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl$path'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final errorBody = json.decode(response.body);
      throw Exception(
        errorBody['erro'] ?? errorBody['message'] ?? 'Erro ao enviar dados.',
      );
    }
  }

  Future<List<dynamic>> fetchImportantDates() async {
    final dynamic responseData = await _get('/datas-importantes');

    if (responseData is List) {
      return responseData;
    } else if (responseData is Map<String, dynamic> &&
        responseData.containsKey('data') &&
        responseData['data'] is List) {
      return responseData['data'] as List<dynamic>;
    } else {
      print(
        'Aviso: Formato de dados de "datas importantes" inesperado. Resposta: $responseData',
      );
      throw Exception(
        'Formato de dados de datas importantes inesperado do servidor. Esperava uma lista ou um objeto com a chave "data" contendo uma lista.',
      );
    }
  }

  Future<Map<String, dynamic>> addImportantDateApi(
    Map<String, dynamic> dateData,
  ) async {
    final response = await _post('/datas-importantes', dateData);
    return response;
  }

  // Removido o fetchDateSuggestions() e addDateSuggestionApi() pois a tela de sugestões será mockada.
  // Se quiser adicionar estes de volta para futuras integrações, você pode.
  /*
  Future<List<dynamic>> fetchDateSuggestions() async {
    final dynamic responseData = await _get('/sugestoes');
    if (responseData is List) { return responseData; }
    else if (responseData is Map<String, dynamic> && responseData.containsKey('data') && responseData['data'] is List) {
      return responseData['data'] as List<dynamic>;
    } else {
      print('Aviso: Formato de dados de "sugestões de encontros" inesperado. Resposta: $responseData');
      throw Exception('Formato de dados de sugestões de encontros inesperado do servidor. Esperava uma lista ou um objeto com a chave "data" contendo uma lista.');
    }
  }

  Future<Map<String, dynamic>> addDateSuggestionApi(Map<String, dynamic> suggestionData) async {
    final response = await _post('/sugestoes', suggestionData);
    return response;
  }
  */
}
