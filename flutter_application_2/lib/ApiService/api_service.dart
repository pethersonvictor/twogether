// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // ATENÇÃO: SUBSTITUA PELA URL REAL DO SEU BACKEND
  // Lembre-se: '10.0.2.2' para emulador Android, 'localhost' ou IP da sua máquina para celular físico/simulador iOS.
  static const String _baseUrl = 'http://10.0.2.2:3000'; // Base URL do seu servidor Node.js

  // --- MÉTODOS DE AUTENTICAÇÃO ---

  Future<Map<String, dynamic>> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register'), // Endpoint de cadastro
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) { // Status 201 Created para sucesso no cadastro
      final responseBody = json.decode(response.body);
      final String token = responseBody['token'];
      final String userId = responseBody['user']['id'];
      final String userName = responseBody['user']['username'];

      // Salva o token e dados do usuário no SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
      await prefs.setString('user_id', userId);
      await prefs.setString('user_name', userName);
      await prefs.setString('user_email', email); // Salva o e-mail também

      return {'success': true, 'message': 'Cadastro realizado com sucesso!', 'token': token, 'user': responseBody['user']};
    } else {
      final errorBody = json.decode(response.body);
      throw Exception(errorBody['message'] ?? 'Erro ao registrar usuário. Tente novamente.');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'), // Endpoint de login
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) { // Status 200 OK para sucesso no login
      final responseBody = json.decode(response.body);
      final String token = responseBody['token'];
      final String userId = responseBody['user']['id'];
      final String userName = responseBody['user']['username'];

      // Salva o token e dados do usuário no SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
      await prefs.setString('user_id', userId);
      await prefs.setString('user_name', userName);
      await prefs.setString('user_email', email);

      return {'success': true, 'message': 'Login realizado com sucesso!', 'token': token, 'user': responseBody['user']};
    } else {
      final errorBody = json.decode(response.body);
      throw Exception(errorBody['message'] ?? 'Credenciais inválidas. Verifique e-mail e senha.');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('user_id');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    // Você pode adicionar um endpoint de logout no backend se ele invalidar o token
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

  // --- MÉTODOS PARA DADOS PROTEGIDOS (FUTURO) ---
  // Estes métodos precisarão de um token JWT para funcionar se o backend os proteger.
  // Você precisará de um middleware de autenticação no seu backend.

  Future<Map<String, dynamic>> _get(String path) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Não autenticado. Faça login novamente.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl$path'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Envia o token JWT
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final errorBody = json.decode(response.body);
      throw Exception(errorBody['erro'] ?? errorBody['message'] ?? 'Erro ao buscar dados.');
    }
  }

  Future<Map<String, dynamic>> _post(String path, Map<String, dynamic> data) async {
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
      throw Exception(errorBody['erro'] ?? errorBody['message'] ?? 'Erro ao enviar dados.');
    }
  }

  // Exemplo de método para buscar datas importantes (requer autenticação no backend)
  Future<List<dynamic>> fetchImportantDates() async {
    final response = await _get('/datas-importantes'); // Endpoint do backend
    return response['data'] ?? response; // Supondo que a resposta seja uma lista ou um objeto com chave 'data'
  }

  // Exemplo de método para adicionar uma data importante (requer autenticação no backend)
  Future<Map<String, dynamic>> addImportantDate(Map<String, dynamic> dateData) async {
    final response = await _post('/datas-importantes', dateData); // Endpoint do backend
    return response;
  }
}// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // ATENÇÃO: SUBSTITUA PELA URL REAL DO SEU BACKEND
  // Lembre-se: '10.0.2.2' para emulador Android, 'localhost' ou IP da sua máquina para celular físico/simulador iOS.
  static const String _baseUrl = 'http://10.0.2.2:3000'; // Base URL do seu servidor Node.js

  // --- MÉTODOS DE AUTENTICAÇÃO ---

  Future<Map<String, dynamic>> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register'), // Endpoint de cadastro
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) { // Status 201 Created para sucesso no cadastro
      final responseBody = json.decode(response.body);
      final String token = responseBody['token'];
      final String userId = responseBody['user']['id'];
      final String userName = responseBody['user']['username'];

      // Salva o token e dados do usuário no SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
      await prefs.setString('user_id', userId);
      await prefs.setString('user_name', userName);
      await prefs.setString('user_email', email); // Salva o e-mail também

      return {'success': true, 'message': 'Cadastro realizado com sucesso!', 'token': token, 'user': responseBody['user']};
    } else {
      final errorBody = json.decode(response.body);
      throw Exception(errorBody['message'] ?? 'Erro ao registrar usuário. Tente novamente.');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'), // Endpoint de login
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) { // Status 200 OK para sucesso no login
      final responseBody = json.decode(response.body);
      final String token = responseBody['token'];
      final String userId = responseBody['user']['id'];
      final String userName = responseBody['user']['username'];

      // Salva o token e dados do usuário no SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
      await prefs.setString('user_id', userId);
      await prefs.setString('user_name', userName);
      await prefs.setString('user_email', email);

      return {'success': true, 'message': 'Login realizado com sucesso!', 'token': token, 'user': responseBody['user']};
    } else {
      final errorBody = json.decode(response.body);
      throw Exception(errorBody['message'] ?? 'Credenciais inválidas. Verifique e-mail e senha.');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('user_id');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    // Você pode adicionar um endpoint de logout no backend se ele invalidar o token
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

  // --- MÉTODOS PARA DADOS PROTEGIDOS (FUTURO) ---
  // Estes métodos precisarão de um token JWT para funcionar se o backend os proteger.
  // Você precisará de um middleware de autenticação no seu backend.

  Future<Map<String, dynamic>> _get(String path) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Não autenticado. Faça login novamente.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl$path'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Envia o token JWT
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final errorBody = json.decode(response.body);
      throw Exception(errorBody['erro'] ?? errorBody['message'] ?? 'Erro ao buscar dados.');
    }
  }

  Future<Map<String, dynamic>> _post(String path, Map<String, dynamic> data) async {
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
      throw Exception(errorBody['erro'] ?? errorBody['message'] ?? 'Erro ao enviar dados.');
    }
  }

  // Exemplo de método para buscar datas importantes (requer autenticação no backend)
  Future<List<dynamic>> fetchImportantDates() async {
    final response = await _get('/datas-importantes'); // Endpoint do backend
    return response['data'] ?? response; // Supondo que a resposta seja uma lista ou um objeto com chave 'data'
  }

  // Exemplo de método para adicionar uma data importante (requer autenticação no backend)
  Future<Map<String, dynamic>> addImportantDate(Map<String, dynamic> dateData) async {
    final response = await _post('/datas-importantes', dateData); // Endpoint do backend
    return response;
  }
}