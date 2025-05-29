import 'package:flutter/material.dart';
import 'package:myapp/services/api_service.dart'; // <--- Caminho corrigidos
import 'package:provider/provider.dart'; // Importa Provider
import 'package:myapp/auth_state_service.dart'; // Importa seu AuthStateService

class EntrarScreen extends StatefulWidget {
  const EntrarScreen({super.key});

  @override
  State<EntrarScreen> createState() => _EntrarScreenState();
}

class _EntrarScreenState extends State<EntrarScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  bool _isLoading = false;

  Future<void> _loginUser() async { // Renomeado para clareza
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final apiService = ApiService();
        final response = await apiService.login(
          emailController.text.trim(),
          senhaController.text.trim(),
        );

        if (response['success'] == true) {
          // Usa o AuthStateService para atualizar o estado de login
          Provider.of<AuthStateService>(context, listen: false).setLoggedIn(
            token: response['token'],
            id: response['user']['id'],
            username: response['user']['username'],
            email: response['user']['email'],
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'])),
          );
          // Navega para a tela principal (MainAppScreen)
          Navigator.pushReplacementNamed(context, '/home');
        }
      } catch (e) {
        // Exibe a mensagem de erro da API
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))), // Remove "Exception: "
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Entrar")),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[Color(0xFFFF6B81), Color(0xFFA084E8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset("assets/logo.png", width: 100.0),
                Image.asset("assets/Rectangle.png", width: 70.0),
                const SizedBox(height: 30.0),
                const Text(
                  "Acessar conta", // Removido "(UI Test)"
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30.0),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration("E-mail"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu e-mail.';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Por favor, insira um e-mail válido.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: senhaController,
                  obscureText: true,
                  decoration: _inputDecoration("Senha"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua senha.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30.0),
                _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : ElevatedButton(
                        onPressed: _loginUser, // Chama a função real de login
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Entrar", style: TextStyle(color: Colors.white, fontSize: 16)), // Removido "(UI Test)"
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      fillColor: const Color(0xFFFFFFFF),
      filled: true,
      hintText: hintText,
      hintStyle: const TextStyle(color: Color.fromARGB(255, 102, 102, 102)),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(10),
      ),
      errorStyle: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }
}