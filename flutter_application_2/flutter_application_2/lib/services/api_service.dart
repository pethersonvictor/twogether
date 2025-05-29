// lib/services/api_service.dart
import 'dart:convert'; // Para usar json.encode e json.decode
import 'package:http/http.dart' as http; // Para fazer requisições HTTP
import 'package:shared_preferences/shared_preferences.dart'; // Para armazenar dados localmente

class ApiService {
  // ATENÇÃO: SUBSTITUA PELA URL REAL DO SEU BACKEND
  // Lembre-se: '10.0.2.2' para emulador Android, 'localhost' ou IP da sua máquina para celular físico/simulador iOS.
  static const String _baseUrl = 'http://10.0.2.2:3000'; // URL base do seu servidor Node.js

  // --- MÉTODOS DE AUTENTICAÇÃO ---

  /// Realiza o cadastro de um novo usuário no backend.
  /// Retorna um Map com 'success', 'message', 'token' e 'user' em caso de sucesso.
  /// Lança uma Exception em caso de falha.
  Future<Map<String, dynamic>> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register'), // Endpoint de cadastro
      headers: {'Content-Type': 'application/json'}, // Define o tipo de conteúdo como JSON
      body: json.encode({ // Converte o Map em uma String JSON
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    // Verifica o status da resposta HTTP
    if (response.statusCode == 201) { // Status 201 Created indica sucesso
      final responseBody = json.decode(response.body); // Decodifica o corpo da resposta JSON
      final String token = responseBody['token'];
      final String userId = responseBody['user']['id']; // Assume que o ID do usuário está em response.user.id
      final String userName = responseBody['user']['username'];
      final String userEmail = responseBody['user']['email'];

      // Salva o token e dados do usuário no SharedPreferences para persistência
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
      await prefs.setString('user_id', userId);
      await prefs.setString('user_name', userName);
      await prefs.setString('user_email', userEmail);

      return {'success': true, 'message': 'Cadastro realizado com sucesso!', 'token': token, 'user': responseBody['user']};
    } else {
      // Em caso de erro, decodifica a mensagem de erro do backend
      final errorBody = json.decode(response.body);
      throw Exception(errorBody['message'] ?? 'Erro ao registrar usuário. Tente novamente.');
    }
  }

  /// Realiza o login de um usuário no backend.
  /// Retorna um Map com 'success', 'message', 'token' e 'user' em caso de sucesso.
  /// Lança uma Exception em caso de falha.
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'), // Endpoint de login
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    // Verifica o status da resposta HTTP
    if (response.statusCode == 200) { // Status 200 OK indica sucesso
      final responseBody = json.decode(response.body);
      final String token = responseBody['token'];
      final String userId = responseBody['user']['id'];
      final String userName = responseBody['user']['username'];
      final String userEmail = responseBody['user']['email'];

      // Salva o token e dados do usuário no SharedPreferences para persistência
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
      await prefs.setString('user_id', userId);
      await prefs.setString('user_name', userName);
      await prefs.setString('user_email', userEmail);

      return {'success': true, 'message': 'Login realizado com sucesso!', 'token': token, 'user': responseBody['user']};
    } else {
      // Em caso de erro, decodifica a mensagem de erro do backend
      final errorBody = json.decode(response.body);
      throw Exception(errorBody['message'] ?? 'Credenciais inválidas. Verifique e-mail e senha.');
    }
  }

  /// Realiza o logout do usuário, limpando os dados de autenticação armazenados localmente.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('user_id');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    // Se o backend tiver um endpoint de logout para invalidar o token no lado do servidor, chame-o aqui.
  }

  /// Retorna o token JWT armazenado localmente, se existir.
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  /// Retorna o ID do usuário armazenado localmente, se existir.
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  /// Retorna o nome do usuário armazenado localmente, se existir.
  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  // --- MÉTODOS AUXILIARES PARA REQUISIÇÕES PROTEGIDAS (com JWT) ---

  /// Método GET genérico para requisições que exigem autenticação.
  /// Adiciona automaticamente o token JWT ao cabeçalho 'Authorization'.
  /// Retorna o corpo da resposta decodificado como Map.
  /// Lança uma Exception se não houver token ou se a requisição falhar.
  Future<Map<String, dynamic>> _get(String path) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Não autenticado. Faça login novamente.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl$path'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Envia o token JWT no formato Bearer
      },
    );

    if (response.statusCode == 200) { // Status 200 OK indica sucesso
      return json.decode(response.body);
    } else {
      final errorBody = json.decode(response.body);
      // Tenta extrair a mensagem de erro de diferentes campos (erro, message)
      throw Exception(errorBody['erro'] ?? errorBody['message'] ?? 'Erro ao buscar dados.');
    }
  }

  /// Método POST genérico para requisições que exigem autenticação.
  /// Adiciona automaticamente o token JWT ao cabeçalho 'Authorization'.
  /// Retorna o corpo da resposta decodificado como Map.
  /// Lança uma Exception se não houver token ou se a requisição falhar.
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

    // Verifica o status da resposta HTTP (201 Created ou 200 OK para sucesso)
    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final errorBody = json.decode(response.body);
      // Tenta extrair a mensagem de erro de diferentes campos (erro, message)
      throw Exception(errorBody['erro'] ?? errorBody['message'] ?? 'Erro ao enviar dados.');
    }
  }

  // --- MÉTODOS PARA DADOS ESPECÍFICOS DO APLICATIVO ---

  /// Busca as datas importantes do backend.
  /// Retorna uma Future<List<dynamic>> contendo as datas.
  /// Lança uma Exception se a requisição falhar ou o formato da resposta for inesperado.
  Future<List<dynamic>> fetchImportantDates() async {
    final response = await _get('/datas-importantes'); // Endpoint do backend

    // MUDANÇA AQUI: Garante que o retorno é uma List<dynamic>
    if (response is List) { // Se a resposta já é uma lista diretamente
      return response;
    } else if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is List) {
      // Se a resposta é um Map e a lista está dentro da chave 'data'
      return response['data'] as List<dynamic>;
    } else {
      // Caso a resposta não seja nem uma lista direta nem um Map com 'data' como lista
      // Isso indica um formato de resposta inesperado.
      print('Aviso: Formato de dados de "datas importantes" inesperado. Resposta: $response');
      throw Exception('Formato de dados de datas importantes inesperado do servidor.');
    }
  }

  /// Adiciona uma nova data importante ao backend.
  /// `dateData` deve ser um Map contendo os dados da data (e.g., 'titulo', 'data_evento', 'local', 'momento', 'usuario_id').
  /// Retorna um Map com a resposta do servidor em caso de sucesso (geralmente o objeto salvo).
  /// Lança uma Exception em caso de falha.
  Future<Map<String, dynamic>> addImportantDateApi(Map<String, dynamic> dateData) async {
    final response = await _post('/datas-importantes', dateData); // Endpoint do backend
    return response;
  }
}