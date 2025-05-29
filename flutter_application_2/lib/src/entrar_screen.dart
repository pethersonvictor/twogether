import 'package:flutter/material.dart';
import 'package:myapp/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:myapp/auth_state_service.dart';

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

  Future<void> _loginUser() async {
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
          Provider.of<AuthStateService>(context, listen: false).setLoggedIn(
            token: response['token'],
            id: response['user']['id'],
            username: response['user']['username'],
            email: response['user']['email'],
          );
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(response['message'])));
          Navigator.pushReplacementNamed(context, '/home');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
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
      body: DecoratedBox(
        // Aplicar o degradê ao body completo
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[Color(0xFFFF6B81), Color(0xFFA084E8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            // Usando Column para organizar o conteúdo
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 20.0),

              Image.asset("assets/logo.png", width: 120.0),
              const SizedBox(height: 10.0),
              Image.asset(
                "assets/nome.png",
                width: 80.0,
              ), // <-- ALTERADO PARA 'nome.png'
              const SizedBox(height: 40.0),

              Text(
                "Acessar conta",
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia',
                ),
              ),
              const SizedBox(height: 40.0),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.black),
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
                    const SizedBox(height: 25.0),
                    TextFormField(
                      controller: senhaController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.black),
                      decoration: _inputDecoration("Senha"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira sua senha.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40.0),

                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _loginUser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                            ),
                            child: const Text(
                              "Entrar",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
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
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 255, 107, 129),
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 160, 132, 232),
          width: 2.0,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }
}
