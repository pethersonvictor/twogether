import 'package:flutter/material.dart';
// Importa todas as telas que serão exibidas na BottomNavigationBar
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
  // Define o índice da tela selecionada na barra de navegação.
  // O índice 2 é a Home (coração), conforme sua imagem.
  // 0: Adicionar Data Especial, 1: Calendário, 2: Home, 3: Sugestões, 4: Desafios
  int _selectedIndex = 2;

  // Lista de widgets (telas) que serão exibidos no IndexedStack.
  // A ordem aqui corresponde aos índices dos botões da BottomNavigationBar.
  final List<Widget> _widgetOptions = <Widget>[
    const AddSpecialDateScreen(), // Índice 0: Antiga lupa, agora adicionar data especial
    const CalendarScreen(), // Índice 1: Calendário
    const HomeScreen(), // Índice 2: Home
    const DateSuggestionsScreen(), // Índice 3: Sugestões de Encontros
    const MonthlyChallengesScreen(), // Índice 4: Desafios Mensais
  ];

  // Função chamada quando um item da barra de navegação é tocado
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Atualiza o índice da tela selecionada
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // O corpo do Scaffold usa um IndexedStack para exibir a tela selecionada.
      // IndexedStack mantém o estado de todas as telas, evitando que elas sejam reconstruídas
      // a cada troca, o que é bom para performance e UX em BottomNavigationBar.
      body: IndexedStack(
        index: _selectedIndex, // O índice da tela a ser exibida
        children: _widgetOptions, // A lista de todas as telas
      ),
      // A barra de navegação inferior personalizada
      bottomNavigationBar: Container(
        height: 80, // Altura fixa da barra
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            // Degradê de fundo da barra
            colors: <Color>[Color(0xFFFF6B81), Color(0xFFA084E8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25),
          ), // Borda arredondada no topo
          boxShadow: [
            // Sombra para a barra
            BoxShadow(color: Colors.black26, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: Row(
          // Linha de ícones na barra
          mainAxisAlignment:
              MainAxisAlignment
                  .spaceAround, // Espaçamento uniforme entre os ícones
          children: [
            // Itens da barra de navegação, com seus respectivos índices e ícones
            _buildNavBarItem(
              0,
              Icons.date_range,
            ), // Índice 0: Ícone de Data (antiga lupa)
            _buildNavBarItem(1, Icons.calendar_today), // Índice 1: Calendário
            _buildNavBarItem(2, Icons.home), // Índice 2: Home
            _buildNavBarItem(3, Icons.lightbulb_outline), // Índice 3: Sugestões
            _buildNavBarItem(4, Icons.local_activity), // Índice 4: Desafios
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para construir um item da barra de navegação
  Widget _buildNavBarItem(int index, IconData icon) {
    final bool isSelected =
        _selectedIndex == index; // Verifica se o item está selecionado
    return GestureDetector(
      onTap:
          () => _onItemTapped(
            index,
          ), // Ao tocar, chama a função para mudar a tela
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // Ocupa o mínimo de espaço vertical necessário
        mainAxisAlignment:
            MainAxisAlignment.center, // Centraliza o ícone verticalmente
        children: [
          Icon(
            icon,
            color:
                isSelected
                    ? Colors.white
                    : Colors.white.withOpacity(
                      0.7,
                    ), // Cor diferente para o item selecionado
            size: 30,
          ),
          // Se sua imagem tivesse texto abaixo dos ícones, você adicionaria aqui:
          // Text(
          //   label,
          //   style: TextStyle(color: isSelected ? Colors.white : Colors.white.withOpacity(0.7), fontSize: 10),
          // )
        ],
      ),
    );
  }
}
