import 'package:flutter/material.dart';
import 'package:myapp/src/calendar_screen.dart';
import 'package:myapp/src/home_screen.dart';
import 'package:myapp/src/date_suggestions_screen.dart';
import 'package:myapp/src/monthly_challenges_screen.dart';
import 'package:myapp/src/add_special_date_screen.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _selectedIndex = 2;

  final List<Widget> _widgetOptions = <Widget>[
    const AddSpecialDateScreen(),
    const CalendarScreen(),
    const HomeScreen(),
    const DateSuggestionsScreen(),
    const MonthlyChallengesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _widgetOptions),
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[Color(0xFFFF6B81), Color(0xFFA084E8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            BoxShadow(color: Colors.black26, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavBarItem(0, Icons.date_range),
            _buildNavBarItem(1, Icons.calendar_today),
            _buildNavBarItem(2, Icons.home),
            _buildNavBarItem(3, Icons.lightbulb_outline),
            _buildNavBarItem(4, Icons.local_activity),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBarItem(int index, IconData icon) {
    final bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
            size: 30,
          ),
        ],
      ),
    );
  }
}
