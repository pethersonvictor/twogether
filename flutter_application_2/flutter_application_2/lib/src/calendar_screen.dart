import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:myapp/src/add_special_date_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendário'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 107, 129), // Cor do seu tema
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TableCalendar(
          locale: 'pt_BR', // Localização para português
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day), // Lógica de seleção de dia
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          calendarStyle: const CalendarStyle( // Estilo dos dias do calendário
            todayDecoration: BoxDecoration(
              color: Color.fromARGB(255, 160, 132, 232), // Cor do dia atual
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 107, 129), // Cor do dia selecionado
              shape: BoxShape.circle,
            ),
            outsideDaysVisible: false, // Oculta dias de outros meses
          ),
          headerStyle: const HeaderStyle( // Estilo do cabeçalho do calendário (mês e ano)
            formatButtonVisible: false, // Esconde o botão de formato (ex: semana, 2 semanas)
            titleCentered: true,
            titleTextStyle: TextStyle(fontSize: 18.0, color: Colors.black),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navega para a tela de adicionar data especial
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddSpecialDateScreen()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 255, 107, 129), // Cor do seu tema
        child: const Icon(Icons.add, color: Colors.white), // Ícone de adicionar
      ),
    );
  }
}