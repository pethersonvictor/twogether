// lib/src/calendar_screen.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:myapp/src/add_special_date_screen.dart';
import 'package:myapp/services/api_service.dart';
import 'package:myapp/models/important_date.dart';
import 'package:provider/provider.dart';
import 'package:myapp/auth_state_service.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<ImportantDate>> _events = {};
  List<ImportantDate> _selectedEvents = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    debugPrint('CalendarScreen: initState - Carregando datas...'); // DEBUG
    _loadImportantDates();
  }

  // Método para carregar as datas importantes do backend
  Future<void> _loadImportantDates() async {
    debugPrint('CalendarScreen: _loadImportantDates chamado.'); // DEBUG
    if (!mounted) {
      // Verifica se o widget ainda está ativo
      debugPrint(
        'CalendarScreen: _loadImportantDates chamado, mas widget não está montado.',
      ); // DEBUG
      return;
    }

    setState(() {
      _isLoading = true;
    });
    try {
      final apiService = ApiService();
      final authService = Provider.of<AuthStateService>(context, listen: false);
      final currentUserId = authService.userId;

      if (currentUserId == null) {
        debugPrint(
          'CalendarScreen: Usuário não autenticado no _loadImportantDates.',
        ); // DEBUG
        throw Exception(
          'Usuário não autenticado. Redirecionando para o login.',
        );
      }

      final List<dynamic> rawDates = await apiService.fetchImportantDates();
      debugPrint(
        'CalendarScreen: Datas recebidas do backend: ${rawDates.length} itens.',
      ); // DEBUG

      List<ImportantDate> userDates =
          rawDates
              .map((json) => ImportantDate.fromJson(json))
              .where((date) => date.usuarioId == currentUserId)
              .toList();
      debugPrint(
        'CalendarScreen: Datas filtradas para o usuário: ${userDates.length} itens.',
      ); // DEBUG

      _events.clear();
      for (var date in userDates) {
        final day = DateTime.utc(
          date.dataEvento.year,
          date.dataEvento.month,
          date.dataEvento.day,
        );
        _events.putIfAbsent(day, () => []);
        _events[day]!.add(date);
      }
      debugPrint(
        'CalendarScreen: Mapa _events populado com ${_events.length} dias com eventos.',
      ); // DEBUG

      _selectedEvents = _getEventsForDay(_selectedDay ?? DateTime.now());
      debugPrint(
        'CalendarScreen: Eventos para o dia selecionado: ${_selectedEvents.length} itens.',
      ); // DEBUG
    } catch (e) {
      debugPrint('CalendarScreen: ERRO no _loadImportantDates: $e'); // DEBUG
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao carregar datas: ${e.toString().replaceFirst('Exception: ', '')}',
          ),
        ),
      );
      if (e.toString().contains('Não autenticado')) {
        Provider.of<AuthStateService>(context, listen: false).setLoggedOut();
        Navigator.pushReplacementNamed(context, '/welcome');
      }
    } finally {
      if (mounted) {
        // Só chama setState se o widget ainda estiver montado
        setState(() {
          _isLoading = false;
        });
        debugPrint('CalendarScreen: _isLoading definido como false.'); // DEBUG
      }
    }
  }

  List<ImportantDate> _getEventsForDay(DateTime day) {
    return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
      'CalendarScreen: build chamado. _isLoading: $_isLoading',
    ); // DEBUG
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendário'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 107, 129),
        foregroundColor: Colors.white,
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 255, 107, 129),
                ),
              )
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TableCalendar<ImportantDate>(
                      locale: 'pt_BR',
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _focusedDay,
                      selectedDayPredicate:
                          (day) => isSameDay(_selectedDay, day),
                      rangeSelectionMode: RangeSelectionMode.disabled,
                      eventLoader: _getEventsForDay,
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                          _selectedEvents = _getEventsForDay(selectedDay);
                        });
                        debugPrint(
                          'CalendarScreen: Dia selecionado: $selectedDay',
                        ); // DEBUG
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                        debugPrint(
                          'CalendarScreen: Mês/Ano alterado para: $focusedDay',
                        ); // DEBUG
                      },
                      calendarStyle: const CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: Color.fromARGB(255, 160, 132, 232),
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 107, 129),
                          shape: BoxShape.circle,
                        ),
                        markerDecoration: BoxDecoration(
                          color: Colors.purple,
                          shape: BoxShape.circle,
                        ),
                        outsideDaysVisible: false,
                      ),
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child:
                        _selectedEvents.isEmpty
                            ? const Center(
                              child: Text(
                                'Nenhum evento para este dia.',
                                style: TextStyle(color: Colors.black54),
                              ),
                            )
                            : ListView.builder(
                              itemCount: _selectedEvents.length,
                              itemBuilder: (context, index) {
                                final event = _selectedEvents[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 4.0,
                                  ),
                                  child: ListTile(
                                    leading: const Icon(Icons.event),
                                    title: Text(event.titulo),
                                    subtitle: Text(
                                      '${event.local ?? 'Local não informado'} - ${DateFormat('HH:mm').format(event.dataEvento)}',
                                    ),
                                    onTap: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Detalhes: ${event.titulo} em ${event.local}',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          debugPrint(
            'CalendarScreen: Botão "Adicionar Data" pressionado.',
          ); // DEBUG
          // Navega para a tela de adicionar data especial e aguarda o resultado
          final result = await Navigator.push(
            // Captura o resultado
            context,
            MaterialPageRoute(
              builder: (context) => const AddSpecialDateScreen(),
            ),
          );
          debugPrint(
            'CalendarScreen: Retornou de AddSpecialDateScreen com resultado: $result',
          ); // DEBUG

          // Se a data foi salva com sucesso, recarrega as datas
          if (result == true) {
            _loadImportantDates();
            // Também aciona o recarregamento na HomeScreen
            // Isso pode ser feito via Provider, mas para UI Test, podemos simplificar
            // Se a HomeScreen também precisar ser atualizada, a forma mais robusta é
            // usar um listener no AuthStateService ou um método de callback se ela for pai.
          }
        },
        backgroundColor: const Color.fromARGB(255, 255, 107, 129),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
