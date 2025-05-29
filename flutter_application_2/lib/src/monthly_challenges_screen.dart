import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MonthlyChallenge {
  final String id;
  final String title;
  final String description;
  bool completedByPartner1;
  bool completedByPartner2;
  final DateTime startDate;
  final DateTime endDate;

  MonthlyChallenge({
    required this.id,
    required this.title,
    this.description = '',
    required this.startDate,
    required this.endDate,
    this.completedByPartner1 = false,
    this.completedByPartner2 = false,
  });

  bool get isActive {
    final now = DateTime.now();
    return !now.isBefore(startDate) &&
        !now.isAfter(
          endDate
              .add(const Duration(days: 1))
              .subtract(const Duration(milliseconds: 1)),
        );
  }

  bool get isCompletedByBoth => completedByPartner1 && completedByPartner2;
}

class MonthlyChallengesScreen extends StatefulWidget {
  const MonthlyChallengesScreen({super.key});

  @override
  State<MonthlyChallengesScreen> createState() =>
      _MonthlyChallengesScreenState();
}

class _MonthlyChallengesScreenState extends State<MonthlyChallengesScreen> {
  List<MonthlyChallenge> _allChallenges = [
    MonthlyChallenge(
      id: '2025-05-challenge-1',
      title: 'Troquem presentes feito a mão',
      startDate: DateTime(2025, 5, 1),
      endDate: DateTime(2025, 5, 31),
      completedByPartner1: true,
      completedByPartner2: true,
    ),
    MonthlyChallenge(
      id: '2025-05-challenge-2',
      title: '30 minutos sem redes sociais',
      startDate: DateTime(2025, 5, 1),
      endDate: DateTime(2025, 5, 31),
    ),
    MonthlyChallenge(
      id: '2025-05-challenge-3',
      title: 'Patinete da Orla de AJU',
      startDate: DateTime(2025, 5, 1),
      endDate: DateTime(2025, 5, 31),
    ),
    MonthlyChallenge(
      id: '2025-05-challenge-4',
      title: 'Troquem cartas de amor',
      startDate: DateTime(2025, 5, 1),
      endDate: DateTime(2025, 5, 31),
    ),
    MonthlyChallenge(
      id: '2025-05-challenge-5',
      title: 'Surpreenda com uma comida favorita',
      startDate: DateTime(2025, 5, 1),
      endDate: DateTime(2025, 5, 31),
    ),
    MonthlyChallenge(
      id: '2025-05-challenge-6',
      title: 'Faça uma caminhada juntos',
      startDate: DateTime(2025, 5, 1),
      endDate: DateTime(2025, 5, 31),
    ),
    MonthlyChallenge(
      id: '2025-05-challenge-7',
      title: 'Piquenique',
      startDate: DateTime(2025, 5, 1),
      endDate: DateTime(2025, 5, 31),
    ),
    MonthlyChallenge(
      id: '2025-06-challenge-1',
      title: 'Planejar o Futuro',
      description:
          'Conversem sobre seus sonhos e metas para os próximos 6 meses.',
      startDate: DateTime(2025, 6, 1),
      endDate: DateTime(2025, 6, 30),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final List<MonthlyChallenge> activeChallenges =
        _allChallenges.where((c) => c.isActive).toList();
    final int completedCount =
        activeChallenges.where((c) => c.isCompletedByBoth).length;
    final double progress =
        activeChallenges.isEmpty
            ? 0.0
            : completedCount / activeChallenges.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color.fromARGB(255, 255, 107, 129),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/hearts_pattern.png',
                repeat: ImageRepeat.repeat,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: Colors.white);
                },
              ),
            ),
          ),
          Column(
            children: [
              Image.asset(
                'assets/logo_small.png',
                height: 40,
                errorBuilder: (context, error, stackTrace) {
                  return const Text(
                    'gether',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Desafios do\nMês',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'Georgia',
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child:
                    activeChallenges.isEmpty
                        ? const Center(
                          child: Text(
                            'Nenhum desafio ativo para este mês.',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          itemCount: activeChallenges.length,
                          itemBuilder: (context, index) {
                            final challenge = activeChallenges[index];
                            return _buildChallengeItem(challenge);
                          },
                        ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: LinearPercentIndicator(
                  percent: progress,
                  lineHeight: 25.0,
                  alignment: MainAxisAlignment.center,
                  barRadius: const Radius.circular(25),
                  backgroundColor: Colors.grey[200]!,
                  linearGradient: const LinearGradient(
                    colors: <Color>[Color(0xFFFF6B81), Color(0xFFA084E8)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  center: Text(
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeItem(MonthlyChallenge challenge) {
    final itemBackgroundColor =
        challenge.isCompletedByBoth
            ? const Color(0xFFFF6B81).withOpacity(0.8)
            : Colors.white;
    final itemTextColor =
        challenge.isCompletedByBoth ? Colors.white : Colors.black87;
    final checkboxCheckColor =
        challenge.isCompletedByBoth ? const Color(0xFFFF6B81) : Colors.white;
    final checkboxFillColor =
        challenge.isCompletedByBoth ? Colors.white : const Color(0xFFFF6B81);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: itemBackgroundColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: Row(
          children: [
            Checkbox(
              value: challenge.isCompletedByBoth,
              onChanged: (bool? newValue) {
                setState(() {
                  challenge.completedByPartner1 = newValue ?? false;
                  challenge.completedByPartner2 = newValue ?? false;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Desafio "${challenge.title}" marcado como ${newValue == true ? "Completo" : "Pendente"} (UI Test)',
                      ),
                    ),
                  );
                });
              },
              activeColor: checkboxFillColor,
              checkColor: checkboxCheckColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              side: BorderSide(
                color:
                    challenge.isCompletedByBoth
                        ? Colors.transparent
                        : const Color(0xFFFF6B81),
                width: 2,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                challenge.title,
                style: TextStyle(
                  fontSize: 16,
                  color: itemTextColor,
                  decoration:
                      challenge.isCompletedByBoth
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                  decorationColor: itemTextColor,
                  decorationThickness: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
