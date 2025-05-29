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
      appBar: AppBar(
        title: const Text("Entrar"),
        backgroundColor:
            Colors.transparent, // AppBar transparente para o degradê de fundo
        elevation: 0, // Sem sombra
        foregroundColor: Colors.white, // Ícones e texto brancos na AppBar
        centerTitle: true,
      ),
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
                // Adicionei um SizedBox para empurrar o conteúdo mais para baixo, se necessário
                // const SizedBox(height: 50.0), // Descomente e ajuste se quiser mais espaço no topo
                Image.asset(
                  "assets/logo.png",
                  width: 120.0,
                ), // Aumentei um pouco a logo principal
                const SizedBox(height: 10.0), // Espaçamento entre as logos
                Image.asset(
                  "assets/nome.png",
                  width: 80.0,
                ), // Aumentei a largura da imagem 'nome.png'
                const SizedBox(
                  height: 40.0,
                ), // Aumentei o espaçamento após as logos

                Text(
                  "Acessar conta",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 28, // Aumentei o tamanho da fonte para o título
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia', // Adicionei uma fonte mais elegante
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                ), // Aumentei o espaçamento antes dos campos

                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    color: Colors.black,
                  ), // Texto digitado preto
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
                const SizedBox(height: 25.0), // Ajustei o espaçamento
                TextFormField(
                  controller: senhaController,
                  obscureText: true,
                  style: const TextStyle(
                    color: Colors.black,
                  ), // Texto digitado preto
                  decoration: _inputDecoration("Senha"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua senha.';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 40.0,
                ), // Aumentei o espaçamento antes do botão

                _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : SizedBox(
                      width: double.infinity, // Botão ocupa toda a largura
                      child: ElevatedButton(
                        onPressed: _loginUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ), // Aumentei o padding vertical do botão
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              12,
                            ), // Deixei as bordas um pouco mais arredondadas
                          ),
                          elevation: 5, // Adicionei uma sombra para o botão
                        ),
                        child: const Text(
                          "Entrar",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ), // Aumentei fonte e peso
                        ),
                      ),
                    ),
                const SizedBox(height: 20), // Espaçamento final
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Função auxiliar para padronizar a decoração dos TextFields
  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      fillColor: const Color(0xFFFFFFFF),
      filled: true,
      hintText: hintText,
      hintStyle: const TextStyle(color: Color.fromARGB(255, 102, 102, 102)),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(
          12,
        ), // Bordas dos campos um pouco mais arredondadas
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 255, 107, 129),
          width: 1.5,
        ), // Borda sutil
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 160, 132, 232),
          width: 2.0,
        ), // Borda mais proeminente no foco
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 15,
      ), // Aumentei o padding interno
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }
}
