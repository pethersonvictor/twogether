import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart'; // Import para o Provider
import 'package:myapp/auth_state_service.dart'; // Importa o seu serviço de estado

// Importa todas as suas telas
import 'package:myapp/src/welcome_screen.dart';
import 'package:myapp/src/cadastro_screen.dart';
import 'package:myapp/src/entrar_screen.dart';
import 'package:myapp/src/calendar_screen.dart';
import 'package:myapp/src/home_screen.dart';
import 'package:myapp/src/date_suggestions_screen.dart';
import 'package:myapp/src/monthly_challenges_screen.dart';
import 'package:myapp/src/main_app_screen.dart'; // Contém a BottomNavigationBar e o IndexedStack
import 'package:myapp/src/add_special_date_screen.dart';
import 'package:myapp/src/settings_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      // Adiciona o Provider no topo da árvore de widgets
      create:
          (context) =>
              AuthStateService(), // Cria uma instância do seu serviço de autenticação
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: Consumer gerencia a tela inicial com base no estado de autenticação
      home: Consumer<AuthStateService>(
        builder: (context, authService, _) {
          if (authService.isLoggedIn) {
            return const MainAppScreen(); // Se logado, vai para a MainAppScreen
          } else {
            return const MyWidget(); // Se não logado, vai para a WelcomeScreen
          }
        },
      ),
      routes: {
        // As rotas são mantidas para navegação por nome
        '/welcome': (context) => const MyWidget(),
        '/login': (context) => const EntrarScreen(),
        '/cadastro': (context) => const CadastroScreen(),
        '/home':
            (context) =>
                const MainAppScreen(), // Mantido para pushReplacementNamed
        '/calendar': (context) => const CalendarScreen(),
        '/date_suggestions': (context) => const DateSuggestionsScreen(),
        '/monthly_challenges': (context) => const MonthlyChallengesScreen(),
        '/add_special_date': (context) => const AddSpecialDateScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
