import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // Configurações de localização para português do Brasil
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Tema do aplicativo (Material Design 3)
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Definição das rotas nomeadas para navegação
      initialRoute: '/welcome', // A tela de boas-vindas é a primeira a ser exibida
      routes: {
        '/welcome': (context) => const MyWidget(),
        '/login': (context) => const EntrarScreen(),
        '/cadastro': (context) => const CadastroScreen(),
        // A rota '/home' agora aponta para a MainAppScreen que contém a BottomNavigationBar
        // e gerencia a exibição das telas principais (Home, Calendário, etc.)
        '/home': (context) => const MainAppScreen(),
        // As rotas abaixo são mantidas para que as telas possam ser acessadas diretamente
        // para testes ou se você mudar a lógica de navegação posteriormente.
        '/calendar': (context) => const CalendarScreen(),
        '/date_suggestions': (context) => const DateSuggestionsScreen(),
        '/monthly_challenges': (context) => const MonthlyChallengesScreen(),
        '/add_special_date': (context) => const AddSpecialDateScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}