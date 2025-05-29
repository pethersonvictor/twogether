import 'package:flutter/material.dart';
import 'dart:async';
import 'package:myapp/src/settings_screen.dart';
// import 'package:percent_indicator/percent_indicator.dart'; // REMOVIDO: Não precisamos mais do widget LinearPercentIndicator aqui
import 'package:provider/provider.dart';
import 'package:myapp/auth_state_service.dart';
import 'package:myapp/services/api_service.dart';
import 'package:myapp/models/important_date.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  // --- Lógica do Contador de Tempo ---
  late Timer _timer;
  final DateTime _anniversaryDate = DateTime(2025, 12, 25, 20, 0);
  Duration _timeUntilAnniversary = Duration.zero;

  // --- Lógica para Próxima Data Importante ---
  ImportantDate? _nextImportantDate;
  bool _isLoadingNextDate = false;

  // --- Lógica para Desafios (apenas contagem) ---
  int _challengesRemaining = 0; // Quantidade de desafios restantes
  bool _isLoadingChallenges = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startCountdown();
    _loadNextImportantDate();
    _loadChallengeStatus(); // NOVO: Carrega o status dos desafios
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadNextImportantDate();
      _loadChallengeStatus(); // Recarrega também o status dos desafios
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Isso é útil se a HomeScreen é reconstruída por alguma mudança de dependência
    // e precisamos garantir que os dados estão atualizados.
    // _loadNextImportantDate(); // Já coberto por initState e didChangeAppLifecycleState
    // _loadChallengeStatus();   // Já coberto por initState e didChangeAppLifecycleState
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

  Future<void> _loadNextImportantDate() async {
    setState(() {
      _isLoadingNextDate = true;
    });
    try {
      final apiService = ApiService();
      final authService = Provider.of<AuthStateService>(context, listen: false);
      final currentUserId = authService.userId;

      if (currentUserId == null) {
        print('Erro: Usuário não autenticado para buscar datas na Home.');
        _nextImportantDate = null;
        return;
      }

      final List<dynamic> rawDates = await apiService.fetchImportantDates();

      List<ImportantDate> userDates =
          rawDates
              .map((json) => ImportantDate.fromJson(json))
              .where((date) => date.usuarioId == currentUserId)
              .toList();

      List<ImportantDate> futureDates =
          userDates
              .where((date) => date.dataEvento.isAfter(DateTime.now()))
              .toList();

      if (futureDates.isNotEmpty) {
        futureDates.sort((a, b) => a.dataEvento.compareTo(b.dataEvento));
        _nextImportantDate = futureDates.first;
      } else {
        _nextImportantDate = null;
      }
    } catch (e) {
      print('Erro ao carregar próxima data importante: ${e.toString()}');
      _nextImportantDate = null;
      if (e.toString().contains('Não autenticado')) {
        Provider.of<AuthStateService>(context, listen: false).setLoggedOut();
        Navigator.pushReplacementNamed(context, '/welcome');
      }
    } finally {
      setState(() {
        _isLoadingNextDate = false;
      });
    }
  }

  // NOVO: Carrega o status dos desafios para exibir quantos faltam
  Future<void> _loadChallengeStatus() async {
    setState(() {
      _isLoadingChallenges = true;
    });
    try {
      final apiService = ApiService();
      final authService = Provider.of<AuthStateService>(context, listen: false);
      final currentUserId = authService.userId;

      if (currentUserId == null) {
        print('Erro: Usuário não autenticado para buscar desafios na Home.');
        _challengesRemaining = 0;
        return;
      }

      // NOVO: Você precisará de um método em ApiService para buscar os desafios.
      // Por enquanto, vamos simular os dados aqui ou no api_service.dart.
      // Se for integrado de verdade, ele buscaria a lista de desafios ativos do backend.
      // Por simplicidade, vamos usar os mockados da tela de desafios como base.
      // Isso é o que você tinha na MonthlyChallengesScreen antes.
      // (Futuramente, o ApiService teria um fetchChallenges() real)
      List<dynamic> rawChallenges = [
        // Simular alguns desafios, como em MonthlyChallengesScreen
        {
          'id': '1',
          'title': 'Desafio 1',
          'completedByPartner1': true,
          'completedByPartner2': false,
          'startDate': '2025-05-01',
          'endDate': '2025-05-31',
          'isActive': true,
        },
        {
          'id': '2',
          'title': 'Desafio 2',
          'completedByPartner1': false,
          'completedByPartner2': false,
          'startDate': '2025-05-01',
          'endDate': '2025-05-31',
          'isActive': true,
        },
        {
          'id': '3',
          'title': 'Desafio 3',
          'completedByPartner1': true,
          'completedByPartner2': true,
          'startDate': '2025-05-01',
          'endDate': '2025-05-31',
          'isActive': true,
        },
        {
          'id': '4',
          'title': 'Desafio 4',
          'completedByPartner1': false,
          'completedByPartner2': false,
          'startDate': '2025-05-01',
          'endDate': '2025-05-31',
          'isActive': true,
        },
        {
          'id': '5',
          'title': 'Desafio 5',
          'completedByPartner1': false,
          'completedByPartner2': false,
          'startDate': '2025-05-01',
          'endDate': '2025-05-31',
          'isActive': true,
        },
      ];

      List<dynamic> activeChallengesData =
          rawChallenges.where((c) {
            // Simular a lógica isActive aqui ou trazer do modelo MonthlyChallenge
            DateTime startDate = DateTime.parse(c['startDate']);
            DateTime endDate = DateTime.parse(c['endDate']);
            final now = DateTime.now();
            final isActive =
                !now.isBefore(startDate) &&
                !now.isAfter(
                  endDate
                      .add(const Duration(days: 1))
                      .subtract(const Duration(milliseconds: 1)),
                );
            return isActive;
          }).toList();

      // Contar quantos faltam
      int pendingCount = 0;
      for (var challengeJson in activeChallengesData) {
        // Assumindo que o desafio é concluído se completedByPartner1 E completedByPartner2 são true
        if (!(challengeJson['completedByPartner1'] == true &&
            challengeJson['completedByPartner2'] == true)) {
          pendingCount++;
        }
      }
      _challengesRemaining = pendingCount;
    } catch (e) {
      print('Erro ao carregar status dos desafios: ${e.toString()}');
      _challengesRemaining = 0;
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingChallenges = false;
        });
      }
    }
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final timeComponents = _getFormattedTimeComponents(_timeUntilAnniversary);

    final authService = Provider.of<AuthStateService>(context);
    final String welcomeUserName = authService.userName ?? 'Casal';

    // Os dados de progresso dos desafios serão obtidos de _challengesRemaining
    // final int simulatedTotalChallenges = 5;
    // final int simulatedCompletedChallenges = 2;
    // final double simulatedChallengeProgress = simulatedTotalChallenges == 0 ? 0.0 : simulatedCompletedChallenges / simulatedTotalChallenges;

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

                      _buildInfoCard(
                        context,
                        icon: Icons.event_note,
                        title:
                            _isLoadingNextDate
                                ? 'Carregando Lembretes...'
                                : (_nextImportantDate != null
                                    ? 'Próximo Lembrete: ${_nextImportantDate!.titulo}'
                                    : 'Nenhum lembrete próximo'),
                        subtitle:
                            _isLoadingNextDate
                                ? 'Buscando do servidor...'
                                : (_nextImportantDate != null
                                    ? DateFormat('dd/MM/yyyy HH:mm').format(
                                          _nextImportantDate!.dataEvento,
                                        ) +
                                        (_nextImportantDate!.local != null &&
                                                _nextImportantDate!
                                                    .local!
                                                    .isNotEmpty
                                            ? ' em ${_nextImportantDate!.local}'
                                            : '')
                                    : 'Adicione uma data especial!'),
                        color: const Color(0xFFE0F7FA),
                        onTap: () {
                          Navigator.pushNamed(context, '/calendar');
                        },
                      ),
                      const SizedBox(height: 15),

                      // Card de Desafio Mensal
                      _buildInfoCard(
                        context,
                        icon: Icons.emoji_events,
                        title: 'Desafio do Mês',
                        // O subtítulo agora mostra quantos desafios faltam
                        subtitle:
                            _isLoadingChallenges
                                ? 'Carregando status dos desafios...'
                                : (_challengesRemaining > 0
                                    ? 'Faltam ${_challengesRemaining} desafios!'
                                    : 'Todos os desafios concluídos!'),
                        color: const Color(0xFFFFF3E0),
                        onTap: () {
                          Navigator.pushNamed(context, '/monthly_challenges');
                        },
                        // BARRA DE PROGRESSO LINEARPERCENTINDICATOR REMOVIDA
                        // progressWidget: Container(...)
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

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    Widget? progressWidget, // Mantido, mas não será usado no card de desafios
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
              // O progressWidget não será mais exibido no card de desafios,
              // mas a propriedade ainda pode ser usada para outros cards futuros.
              // if (progressWidget != null)
              //   progressWidget,
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
