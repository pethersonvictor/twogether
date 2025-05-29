import 'package:flutter/material.dart';

// Modelo simplificado para Sugestão de Encontro (para dados mockados locais)
class DateSuggestionDisplay {
  final String id;
  final String title;
  final String description;
  final List<String> categories;
  final String assetPath; // Caminho para o asset local
  final bool isFavorite;

  DateSuggestionDisplay({
    required this.id, // Adicionei 'id' para consistência, se quiser usá-lo
    required this.title,
    required this.description,
    this.categories = const [],
    this.assetPath = '',
    this.isFavorite = false,
  });
}

class DateSuggestionsScreen extends StatefulWidget {
  const DateSuggestionsScreen({super.key});

  @override
  State<DateSuggestionsScreen> createState() => _DateSuggestionsScreenState();
}

class _DateSuggestionsScreenState extends State<DateSuggestionsScreen> {
  // Lista de sugestões de encontros (15 dados mockados locais)
  List<DateSuggestionDisplay> _suggestions = [
    DateSuggestionDisplay(
      id: '1',
      title: 'Piquenique no Parque',
      description:
          'Prepare uma cesta com comes e bebes e encontrem um lugar aconchegante no parque para um piquenique romântico.',
      categories: ['Ao Ar Livre', 'Romântico', 'Baixo Custo'],
      assetPath: 'assets/piquenique.jpeg',
    ),
    DateSuggestionDisplay(
      id: '2',
      title: 'Noite de Cinema em Casa',
      description:
          'Escolham um filme, façam pipoca, apaguem as luzes e criem um ambiente de cinema no conforto do lar.',
      categories: ['Em Casa', 'Relaxamento', 'Baixo Custo'],
      assetPath: 'assets/cinema.jpeg',
    ),
    DateSuggestionDisplay(
      id: '3',
      title: 'Aula de Culinária a Dois',
      description:
          'Aprendam a fazer um prato novo juntos, seja online ou em um curso presencial. A diversão é garantida!',
      categories: ['Gastronomia', 'Divertido', 'Experiência'],
      assetPath: 'assets/cozinhar.jpeg',
    ),
    DateSuggestionDisplay(
      id: '4',
      title: 'Explorar Nova Cidade',
      description:
          'Visitem uma cidade próxima ou um bairro que vocês ainda não conhecem, descubram novos lugares e histórias.',
      categories: ['Aventura', 'Exploração'],
      assetPath: 'assets/viagem.jpeg',
    ),
    DateSuggestionDisplay(
      id: '5',
      title: 'Sessão de Jogos',
      description:
          'Desafiem-se em jogos de tabuleiro, cartas ou videogames. Muita risada e competitividade saudável!',
      categories: ['Em Casa', 'Divertido'],
      assetPath: 'assets/jogos.jpeg',
    ),
    DateSuggestionDisplay(
      id: '6',
      title: 'Noite das Estrelas',
      description:
          'Encontrem um local escuro e observem as estrelas, talvez com um telescópio ou binóculos.',
      categories: ['Ao Ar Livre', 'Romântico'],
      assetPath: 'assets/estrelado.png',
    ),
    DateSuggestionDisplay(
      id: '7',
      title: 'Karaokê em Casa',
      description:
          'Montem um karaokê improvisado e cantem suas músicas favoritas sem vergonha.',
      categories: ['Em Casa', 'Divertido'],
      assetPath: 'assets/karaoke.png',
    ),
    DateSuggestionDisplay(
      id: '8',
      title: 'Voluntariado a Dois',
      description:
          'Escolham uma causa e dediquem um tempo para ajudar uma instituição ou projeto social juntos.',
      categories: ['Experiência', 'Significativo'],
      assetPath: 'assets/voluntario.png',
    ),
    DateSuggestionDisplay(
      id: '9',
      title: 'Trilha na Natureza',
      description:
          'Explorem uma trilha ecológica, apreciando a natureza e a companhia um do outro.',
      categories: ['Ao Ar Livre', 'Aventura'],
      assetPath: 'assets/trilha.png',
    ),
    DateSuggestionDisplay(
      id: '10',
      title: 'Crie uma Playlist',
      description:
          'Montem uma playlist com músicas que marcaram o relacionamento de vocês e dancem.',
      categories: ['Em Casa', 'Romântico', 'Baixo Custo'],
      assetPath: 'assets/playlist.png',
    ),
    DateSuggestionDisplay(
      id: '11',
      title: 'Café da Manhã na Cama',
      description:
          'Preparem um café da manhã especial e levem para a cama do seu par para começar o dia com carinho.',
      categories: ['Em Casa', 'Romântico', 'Baixo Custo'],
      assetPath: 'assets/cafe.png',
    ),
    DateSuggestionDisplay(
      id: '12',
      title: 'Visite um Museu/Galeria',
      description:
          'Passem uma tarde explorando arte, história ou ciência em um museu ou galeria local.',
      categories: ['Cultura', 'Experiência'],
      assetPath: 'assets/museu.png',
    ),
    DateSuggestionDisplay(
      id: '13',
      title: 'Noite de Massagem',
      description:
          'Troquem massagens relaxantes, criando um momento de conexão e bem-estar.',
      categories: ['Em Casa', 'Romântico', 'Relaxamento'],
      assetPath: 'assets/massagem.png',
    ),
    DateSuggestionDisplay(
      id: '14',
      title: 'Passeio de Bicicleta',
      description:
          'Aluguem bicicletas ou usem as suas para explorar a cidade ou um parque de uma nova perspectiva.',
      categories: ['Ao Ar Livre', 'Divertido'],
      assetPath: 'assets/bike.png',
    ),
    DateSuggestionDisplay(
      id: '15',
      title: 'Desafio de Cozinha "MasterChef"',
      description:
          'Escolham um ingrediente secreto e cada um tenta criar um prato criativo com ele.',
      categories: ['Gastronomia', 'Divertido', 'Experiência'],
      assetPath: 'assets/chefe.png',
    ),
  ];

  String? _selectedCategory;
  // bool _isLoading = false; // Removido, não é mais necessário

  @override
  void initState() {
    super.initState();
    // A tela agora é puramente local, não precisa de carregamento assíncrono
    // _isLoading = false; // Já é false por padrão se não inicializar
  }

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
                          'Nenhuma sugestão encontrada.',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
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
                                      'Detalhes de "${suggestion.title}" (Mocked)',
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (suggestion.assetPath.isNotEmpty) ...[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          // AGORA USA Image.asset
                                          suggestion.assetPath,
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
                                    if (suggestion.description.isNotEmpty)
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
                                    if (suggestion.categories.isNotEmpty)
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
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Favoritar "${suggestion.title}" (Mocked)',
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
      // FLOATING ACTION BUTTON REMOVIDO AQUI
      // floatingActionButton: FloatingActionButton(...)
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
