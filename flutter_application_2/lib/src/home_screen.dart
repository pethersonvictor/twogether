import 'package:flutter/material.dart';
import 'dart:async'; // Para o contador regressivo

import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart'; // Importe Provider
import 'package:myapp/auth_state_service.dart'; // Importe AuthStateService

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- Lógica do Contador de Tempo ---
  late Timer _timer;
  final DateTime _anniversaryDate = DateTime(2025, 12, 25, 20, 0);
  Duration _timeUntilAnniversary = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timeUntilAnniversary = _anniversaryDate.difference(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_anniversaryDate.isBefore(DateTime.now())) {
        setState(() {
          _timeUntilAnniversary = Duration.zero;
          _timer.cancel();
        });
      } else {
        setState(() {
          _timeUntilAnniversary = _anniversaryDate.difference(DateTime.now());
        });
      }
    });
  }

  Map<String, String> _getFormattedTimeComponents(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return {
      'days': duration.inDays.toString(),
      'hours': twoDigits(duration.inHours.remainder(24)),
      'minutes': twoDigits(duration.inMinutes.remainder(60)),
      'seconds': twoDigits(duration.inSeconds.remainder(60)),
    };
  }
  // --- Fim da Lógica do Contador ---

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final timeComponents = _getFormattedTimeComponents(_timeUntilAnniversary);

    // Acessa o AuthStateService para obter o nome de usuário real
    final authService = Provider.of<AuthStateService>(context);
    final String welcomeUserName =
        authService.userName ?? 'Casal'; // Se não houver nome, usa 'Casal'

    // --- Dados Simulados para o Progresso dos Desafios na Home ---
    final int simulatedTotalChallenges = 5;
    final int simulatedCompletedChallenges = 2;
    final double simulatedChallengeProgress =
        simulatedTotalChallenges == 0
            ? 0.0
            : simulatedCompletedChallenges / simulatedTotalChallenges;
    // --- Fim dos Dados Simulados ---

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.white,
              child: Opacity(
                opacity: 0.1,
                child: Image.asset(
                  'assets/hearts_pattern.png',
                  repeat: ImageRepeat.repeat,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container();
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.55,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xFFFF6B81),
                    Color(0xFFA084E8),
                    Colors.white,
                  ],
                  stops: [0.0, 0.5, 1.0],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 50,
                  left: 16,
                  right: 16,
                  bottom: 10,
                ),
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/logo_small.png',
                      height: 40,
                      errorBuilder: (context, error, stackTrace) {
                        return const Text(
                          'gether',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.black),
                      onPressed: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                Image.asset('assets/couple_avatar.png').image,
                            onBackgroundImageError: (exception, stackTrace) {
                              debugPrint(
                                'Error loading couple avatar: $exception',
                              );
                            },
                          ),
                          const SizedBox(width: 15),
                          Text(
                            // MUDOU AQUI: Agora mostra o nome do usuário
                            'Olá, ${welcomeUserName}!',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Georgia',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: <Color>[
                              Color(0xFFFF6B81),
                              Color(0xFFA084E8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Aniversário de Namoro',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              '${timeComponents['days']}:${timeComponents['hours']}:${timeComponents['minutes']}:${timeComponents['seconds']}',
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Monospace',
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Dias',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Horas',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Minutos',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Segundos',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),

                      // --- CARDS DE ACESSO RÁPIDO NA PARTE BRANCA ---
                      _buildInfoCard(
                        context,
                        icon: Icons.event_note,
                        title: 'Próximos Lembretes',
                        subtitle: 'Aniversário de Namoro em 10 dias!',
                        color: const Color(0xFFE0F7FA),
                        onTap: () {
                          Navigator.pushNamed(context, '/calendar');
                        },
                      ),
                      const SizedBox(height: 15),

                      _buildInfoCard(
                        context,
                        icon: Icons.emoji_events,
                        title: 'Desafio do Mês',
                        subtitle:
                            'Status: ${simulatedCompletedChallenges}/${simulatedTotalChallenges} Concluído.',
                        color: const Color(0xFFFFF3E0),
                        onTap: () {
                          Navigator.pushNamed(context, '/monthly_challenges');
                        },
                        progressWidget: Container(
                          margin: const EdgeInsets.only(top: 8.0),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 5.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: LinearPercentIndicator(
                            percent: simulatedChallengeProgress,
                            lineHeight: 18.0,
                            alignment: MainAxisAlignment.center,
                            barRadius: const Radius.circular(15),
                            backgroundColor: Colors.grey[200]!,
                            linearGradient: const LinearGradient(
                              colors: <Color>[
                                Color(0xFFFF6B81),
                                Color(0xFFA084E8),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            center: Text(
                              '${(simulatedChallengeProgress * 100).toInt()}%',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para os cards de informação na parte branca
  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    Widget? progressWidget,
  }) {
    return Card(
      color: color,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 30, color: Colors.blueGrey.shade700),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey.shade800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Colors.grey,
                  ),
                ],
              ),
              if (progressWidget != null) progressWidget,
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
