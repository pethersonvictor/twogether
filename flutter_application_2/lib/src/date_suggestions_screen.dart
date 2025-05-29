import 'package:flutter/material.dart';

class DateSuggestion {
  final String title;
  final String description;
  final List<String> categories;
  final String imageUrl;
  final bool isFavorite;

  DateSuggestion({
    required this.title,
    required this.description,
    this.categories = const [],
    this.imageUrl = '',
    this.isFavorite = false,
  });

  DateSuggestion copyWith({
    String? title,
    String? description,
    List<String>? categories,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return DateSuggestion(
      title: title ?? this.title,
      description: description ?? this.description,
      categories: categories ?? this.categories,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class DateSuggestionsScreen extends StatefulWidget {
  const DateSuggestionsScreen({super.key});

  @override
  State<DateSuggestionsScreen> createState() => _DateSuggestionsScreenState();
}

class _DateSuggestionsScreenState extends State<DateSuggestionsScreen> {
  List<DateSuggestion> _suggestions = [
    DateSuggestion(
      title: 'Piquenique no Parque',
      description:
          'Prepare uma cesta com comes e bebes e encontrem um lugar aconchegante no parque para um piquenique romântico.',
      categories: ['Ao Ar Livre', 'Romântico', 'Baixo Custo'],
      imageUrl: 'assets/piquenique.jpeg',
    ),
    DateSuggestion(
      title: 'Noite de Cinema em Casa',
      description:
          'Escolham um filme, façam pipoca, apaguem as luzes e criem um ambiente de cinema no conforto do lar.',
      categories: ['Em Casa', 'Relaxamento', 'Baixo Custo'],
      imageUrl: 'assets/cinema.jpeg',
    ),
    DateSuggestion(
      title: 'Aula de Culinária a Dois',
      description:
          'Aprendam a fazer um prato novo juntos, seja online ou em um curso presencial. A diversão é garantida!',
      categories: ['Gastronomia', 'Divertido', 'Experiência'],
      imageUrl: 'assets/cozinhar.jpeg',
    ),
    DateSuggestion(
      title: 'Explorar uma Nova Cidade/Bairro',
      description:
          'Visitem uma cidade próxima ou um bairro que vocês ainda não conhecem, descubram novos lugares e histórias.',
      categories: ['Aventura', 'Exploração'],
      imageUrl: 'assets/viagem.jpeg',
    ),
    DateSuggestion(
      title: 'Sessão de Jogos de Tabuleiro/Videogame',
      description:
          'Desafiem-se em jogos de tabuleiro, cartas ou videogames. Muita risada e competitividade saudável!',
      categories: ['Em Casa', 'Divertido'],
      imageUrl: 'assets/jogos.jpeg',
    ),
  ];

  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: const Color.fromARGB(255, 255, 107, 129),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(context, 'Todos', null),
                  _buildFilterChip(context, 'Romântico', 'Romântico'),
                  _buildFilterChip(context, 'Ao Ar Livre', 'Ao Ar Livre'),
                  _buildFilterChip(context, 'Em Casa', 'Em Casa'),
                  _buildFilterChip(context, 'Aventura', 'Aventura'),
                  _buildFilterChip(context, 'Gastronomia', 'Gastronomia'),
                  _buildFilterChip(context, 'Baixo Custo', 'Baixo Custo'),
                  _buildFilterChip(context, 'Divertido', 'Divertido'),
                ],
              ),
            ),
          ),
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
                  filteredSuggestions.isEmpty
                      ? const Center(
                        child: Text(
                          'Nenhuma sugestão encontrada para esta categoria.',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      )
                      : ListView.builder(
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
                              onTap: () {
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
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8.0,
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
                                                      .withOpacity(0.2),
                                                  labelStyle: const TextStyle(
                                                    color: Colors.deepPurple,
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                    ),
                                    Align(
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
                                          setState(() {
                                            final updatedSuggestion = suggestion
                                                .copyWith(
                                                  isFavorite:
                                                      !suggestion.isFavorite,
                                                );
                                            _suggestions[index] =
                                                updatedSuggestion;
                                          });
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Adicionar nova sugestão (UI Test)')),
          );
        },
        backgroundColor: const Color.fromARGB(255, 255, 107, 129),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    String? categoryValue,
  ) {
    final isSelected = _selectedCategory == categoryValue;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            _selectedCategory = selected ? categoryValue : null;
          });
        },
        selectedColor: const Color.fromARGB(
          255,
          255,
          107,
          129,
        ).withOpacity(0.5),
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: Colors.grey[200],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
