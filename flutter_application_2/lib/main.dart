import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:myapp/auth_state_service.dart';

// Importa todas as suas telas
import 'package:myapp/src/welcome_screen.dart';
import 'package:myapp/src/cadastro_screen.dart';
import 'package:myapp/src/entrar_screen.dart';
import 'package:myapp/src/calendar_screen.dart';
import 'package:myapp/src/home_screen.dart';
import 'package:myapp/src/date_suggestions_screen.dart';
import 'package:myapp/src/monthly_challenges_screen.dart';
import 'package:myapp/src/main_app_screen.dart';
import 'package:myapp/src/add_special_date_screen.dart';
import 'package:myapp/src/settings_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthStateService(),
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
      home: Consumer<AuthStateService>(
        builder: (context, authService, _) {
          if (authService.isLoggedIn) {
            return const MainAppScreen();
          } else {
            return const MyWidget();
          }
        },
      ),
      routes: {
        '/welcome': (context) => const MyWidget(),
        '/login': (context) => const EntrarScreen(),
        '/cadastro': (context) => const CadastroScreen(),
        '/home': (context) => const MainAppScreen(),
        '/calendar': (context) => const CalendarScreen(),
        '/date_suggestions': (context) => const DateSuggestionsScreen(),
        '/monthly_challenges': (context) => const MonthlyChallengesScreen(),
        '/add_special_date': (context) => const AddSpecialDateScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
