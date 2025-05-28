import 'package:flutter/material.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  bool _isLoading = false;

  Future<void> _simularCadastro() async {
    if (_formKey.currentState!.validate()) { // Aciona a validação do formulário
      setState(() {
        _isLoading = true; // Ativa o indicador de carregamento
      });

      await Future.delayed(const Duration(seconds: 2)); // Simula um atraso de rede

      setState(() {
        _isLoading = false; // Desativa o indicador
      });

      // Se a validação passar e a simulação terminar, navega para a tela principal
      Navigator.pushReplacementNamed(context, '/home');

      // Mostra uma mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro UI simulado com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastro")),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[Color(0xFFFF6B81), Color(0xFFA084E8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView( // Permite rolagem se o teclado cobrir os campos
          padding: const EdgeInsets.all(20.0),
          child: Form( // Agrupa os campos para validação
            key: _formKey, // Associa a chave para controle do formulário
            child: Column(
              children: [
                Image.asset("assets/logo.png", width: 100.0),
                Image.asset("assets/nome.png", width: 70.0),
                const SizedBox(height: 30.0),
                const Text(
                  "Crie sua conta (UI Test)",
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30.0),
                TextFormField( // Campo para o nome
                  controller: nomeController,
                  decoration: _inputDecoration("Nome"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu nome.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField( // Campo para o e-mail
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress, // Teclado otimizado
                  decoration: _inputDecoration("E-mail"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu e-mail.';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) { // Validação de formato de e-mail
                      return 'Por favor, insira um e-mail válido.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField( // Campo para a senha
                  controller: senhaController,
                  obscureText: true, // Esconde a senha
                  decoration: _inputDecoration("Senha"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua senha.';
                    }
                    if (value.length < 6) { // Validação de tamanho mínimo
                      return 'A senha deve ter pelo menos 6 caracteres.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30.0),
                _isLoading // Exibe o indicador de carregamento ou o botão
                    ? const CircularProgressIndicator(color: Colors.white)
                    : ElevatedButton(
                        onPressed: _simularCadastro, // Chama a função de simulação
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Cadastrar (UI Test)", style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
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
        borderRadius: BorderRadius.circular(10),
      ),
      errorStyle: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold), // Estilo para mensagens de erro
    );
  }

  @override
  void dispose() {
    // Libera os controladores de texto da memória quando o widget é descartado
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }
}