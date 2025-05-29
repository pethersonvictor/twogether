// lib/src/welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:myapp/auth_state_service.dart'; // Import AuthStateService

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  // Lógica para verificar o estado de login e redirecionar
  void _checkAuthStatusAndRedirect() {
    final authService = Provider.of<AuthStateService>(context, listen: false);
    if (authService.isLoggedIn) {
      // Se já estiver logado, vai direto para a Home (MainAppScreen)
      Navigator.pushReplacementNamed(context, '/home');
    }
    // Senão, permanece na WelcomeScreen para login/cadastro
  }

  @override
  void initState() {
    super.initState();
    // Chama a verificação após a primeira renderização do widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthStatusAndRedirect();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Escuta mudanças no estado de autenticação para reagir se o usuário fizer logout
    return Consumer<AuthStateService>(
      builder: (context, authService, child) {
        // Se o usuário já estiver logado (e _checkAuthStatusAndRedirect não o redirecionou por alguma razão)
        // ou se ele estiver deslogando e voltar para esta tela, este Consumer pode lidar com isso.
        // Contudo, a principal lógica de redirecionamento está no main.dart e no initState.
        return Scaffold(
          body: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[Color(0xFFFF6B81), Color(0xFFA084E8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/logo.png", width: 250.0),
                  Image.asset("assets/Rectangle.png", width: 200.0),
                  const SizedBox(height: 50.0),

                  // Botão Entrar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navega para a tela de Login
                        Navigator.pushNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Entrar', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),

                  const SizedBox(height: 15.0),

                  // Botão Cadastrar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navega para a tela de Cadastro
                        Navigator.pushNamed(context, '/cadastro');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Cadastrar', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}