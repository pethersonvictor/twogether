import 'package:flutter/material.dart';

// Modelo simples para uma Sugestão de Encontro
class DateSuggestion {
  final String title;
  final String description;
  final List<String>
  categories; // Ex: ['Romântico', 'Ao Ar Livre', 'Baixo Custo']
  final String imageUrl; // Opcional
  final bool isFavorite; // Para simular o estado de favorito

  DateSuggestion({
    required this.title,
    required this.description,
    this.categories = const [],
    this.imageUrl = '',
    this.isFavorite = false,
  });
}

class DateSuggestionsScreen extends StatefulWidget {
  const DateSuggestionsScreen({super.key});

  @override
  State<DateSuggestionsScreen> createState() => _DateSuggestionsScreenState();
}

class _DateSuggestionsScreenState extends State<DateSuggestionsScreen> {
  // Lista de sugestões de encontros (dados mockados para UI)
  List<DateSuggestion> _suggestions = [
    DateSuggestion(
      title: 'Piquenique no Parque',
      description:
          'Prepare uma cesta com comes e bebes e encontrem um lugar aconchegante no parque para um piquenique romântico.',
      categories: ['Ao Ar Livre', 'Romântico', 'Baixo Custo'],
      imageUrl:
          'assets/piquenique.jpeg', // Adicione esta imagem aos seus assets
    ),
    DateSuggestion(
      title: 'Noite de Cinema em Casa',
      description:
          'Escolham um filme, façam pipoca, apaguem as luzes e criem um ambiente de cinema no conforto do lar.',
      categories: ['Em Casa', 'Relaxamento', 'Baixo Custo'],
      imageUrl: 'assets/cinema.jpeg', // Adicione esta imagem aos seus assets
    ),
    DateSuggestion(
      title: 'Aula de Culinária a Dois',
      description:
          'Aprendam a fazer um prato novo juntos, seja online ou em um curso presencial. A diversão é garantida!',
      categories: ['Gastronomia', 'Divertido', 'Experiência'],
      imageUrl: 'assets/cozinhar.jpeg', // Adicione esta imagem aos seus assets
    ),
    DateSuggestion(
      title: 'Explorar uma Nova Cidade/Bairro',
      description:
          'Visitem uma cidade próxima ou um bairro que vocês ainda não conhecem, descubram novos lugares e histórias.',
      categories: ['Aventura', 'Exploração'],
      imageUrl: 'assets/viagem.jpeg', // Adicione esta imagem aos seus assets
    ),
    DateSuggestion(
      title: 'Sessão de Jogos de Tabuleiro/Videogame',
      description:
          'Desafiem-se em jogos de tabuleiro, cartas ou videogames. Muita risada e competitividade saudável!',
      categories: ['Em Casa', 'Divertido'],
      imageUrl: 'assets/jogos.jpeg', // Adicione esta imagem aos seus assets
    ),
  ];

  // Categoria atualmente selecionada para filtro
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    // Filtrar sugestões com base na categoria selecionada
    final filteredSuggestions =
        _selectedCategory == null
            ? _suggestions
            : _suggestions
                .where((s) => s.categories.contains(_selectedCategory))
                .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ideias de Encontros'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(
          255,
          255,
          107,
          129,
        ), // Cor do seu degradê
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Área de Filtros (fundo branco)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            color: Colors.white, // Fundo branco para os filtros
            child: SingleChildScrollView(
              // Permite rolagem horizontal dos chips
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(
                    context,
                    'Todos',
                    null,
                  ), // Chip para mostrar todas as categorias
                  _buildFilterChip(context, 'Romântico', 'Romântico'),
                  _buildFilterChip(context, 'Ao Ar Livre', 'Ao Ar Livre'),
                  _buildFilterChip(context, 'Em Casa', 'Em Casa'),
                  _buildFilterChip(context, 'Aventura', 'Aventura'),
                  _buildFilterChip(context, 'Gastronomia', 'Gastronomia'),
                  _buildFilterChip(context, 'Baixo Custo', 'Baixo Custo'),
                  _buildFilterChip(context, 'Divertido', 'Divertido'),
                  // Adicione mais categorias conforme necessário
                ],
              ),
            ),
          ),
          // Lista de Sugestões (fundo com degradê)
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[Color(0xFFFF6B81), Color(0xFFA084E8)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child:
                  filteredSuggestions
                          .isEmpty // Mensagem se não houver sugestões na categoria
                      ? const Center(
                        child: Text(
                          'Nenhuma sugestão encontrada para esta categoria.',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      )
                      : ListView.builder(
                        // Constrói a lista de cards de sugestões
                        padding: const EdgeInsets.all(16.0),
                        itemCount: filteredSuggestions.length,
                        itemBuilder: (context, index) {
                          final suggestion = filteredSuggestions[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 15.0),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: InkWell(
                              // Torna o card clicável
                              onTap: () {
                                // Simula a navegação para uma tela de detalhes da sugestão
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Detalhes de "${suggestion.title}" (UI Test)',
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (suggestion.imageUrl.isNotEmpty) ...[
                                      // Exibe imagem se existir
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          suggestion.imageUrl,
                                          height: 150,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Container(
                                              // Fallback se a imagem não carregar
                                              height: 150,
                                              color: Colors.grey[200],
                                              child: const Center(
                                                child: Icon(
                                                  Icons.broken_image,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                    Text(
                                      suggestion.title,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      suggestion.description,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                      maxLines: 2, // Limita a 2 linhas
                                      overflow:
                                          TextOverflow
                                              .ellipsis, // Adiciona "..." se o texto for muito longo
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      // Para exibir as categorias como chips
                                      spacing:
                                          8.0, // Espaçamento entre os chips
                                      children:
                                          suggestion.categories
                                              .map(
                                                (category) => Chip(
                                                  label: Text(
                                                    category,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  backgroundColor: Colors
                                                      .deepPurple
                                                      .withOpacity(
                                                        0.2,
                                                      ), // Cores suaves
                                                  labelStyle: const TextStyle(
                                                    color: Colors.deepPurple,
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                    ),
                                    Align(
                                      // Ícone de favorito
                                      alignment: Alignment.bottomRight,
                                      child: IconButton(
                                        icon: Icon(
                                          suggestion.isFavorite
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color:
                                              suggestion.isFavorite
                                                  ? Colors.red
                                                  : Colors.grey,
                                        ),
                                        onPressed: () {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            // Simula marcar favorito
                                            SnackBar(
                                              content: Text(
                                                suggestion.isFavorite
                                                    ? 'Removido dos favoritos (UI Test)'
                                                    : 'Adicionado aos favoritos (UI Test)',
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Simula a adição de uma nova sugestão
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Adicionar nova sugestão (UI Test)')),
          );
        },
        backgroundColor: const Color.fromARGB(
          255,
          255,
          107,
          129,
        ), // Cor do seu tema
        child: const Icon(Icons.add, color: Colors.white), // Ícone de adicionar
      ),
    );
  }

  // Widget auxiliar para os chips de filtro
  Widget _buildFilterChip(
    BuildContext context,
    String label,
    String? categoryValue,
  ) {
    final isSelected =
        _selectedCategory ==
        categoryValue; // Verifica se o chip está selecionado
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            _selectedCategory =
                selected
                    ? categoryValue
                    : null; // Atualiza a categoria selecionada
          });
        },
        selectedColor: const Color.fromARGB(
          255,
          255,
          107,
          129,
        ).withOpacity(0.5), // Cor do chip selecionado
        checkmarkColor: Colors.white, // Cor do checkmark
        labelStyle: TextStyle(
          color:
              isSelected
                  ? Colors.white
                  : Colors.black87, // Cor do texto do chip
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor:
            Colors.grey[200], // Cor de fundo do chip não selecionado
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ), // Borda arredondada
      ),
    );
  }
}
