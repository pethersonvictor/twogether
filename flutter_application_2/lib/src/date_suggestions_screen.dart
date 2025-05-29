// lib/src/date_suggestions_screen.dart
import 'package:flutter/material.dart';
import 'package:myapp/services/api_service.dart'; // Importe seu ApiService
import 'package:myapp/models/date_suggestion.dart'; // Importe seu novo modelo
import 'package:provider/provider.dart'; // Para acessar o AuthStateService
import 'package:myapp/auth_state_service.dart'; // Para acessar o userId

class DateSuggestionsScreen extends StatefulWidget {
  const DateSuggestionsScreen({super.key});

  @override
  State<DateSuggestionsScreen> createState() => _DateSuggestionsScreenState();
}

class _DateSuggestionsScreenState extends State<DateSuggestionsScreen> {
  List<DateSuggestionModel> _suggestions = []; // Agora armazenará dados reais
  String? _selectedCategory; // Categoria atualmente selecionada para filtro
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDateSuggestions(); // Carrega as sugestões ao iniciar a tela
  }

  // Método para carregar as sugestões do backend
  Future<void> _loadDateSuggestions() async {
    setState(() {
      _isLoading = true; // Ativa o indicador de carregamento
    });
    try {
      final apiService = ApiService();
      final authService = Provider.of<AuthStateService>(context, listen: false);
      final currentUserId = authService.userId;

      if (currentUserId == null) {
        throw Exception(
          'Usuário não autenticado. Redirecionando para o login.',
        );
      }

      final List<dynamic> rawSuggestions =
          await apiService.fetchDateSuggestions();

      // Converte os dados brutos para o modelo DateSuggestionModel
      // Se seu backend filtra sugestões por usuário/casal, você não precisa do .where aqui.
      // Se as sugestões são para todos, ou se seu backend já filtrou, basta o map.
      _suggestions =
          rawSuggestions
              .map((json) => DateSuggestionModel.fromJson(json))
              // .where((s) => s.usuarioId == currentUserId) // Descomente e ajuste se precisar filtrar por usuário logado no Flutter
              .toList();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao carregar sugestões: ${e.toString().replaceFirst('Exception: ', '')}',
          ),
        ),
      );
      // Se o erro for de autenticação (ex: token inválido), redireciona
      if (e.toString().contains('Não autenticado')) {
        Provider.of<AuthStateService>(context, listen: false).setLoggedOut();
        Navigator.pushReplacementNamed(context, '/welcome');
      }
    } finally {
      setState(() {
        _isLoading = false; // Desativa o indicador de carregamento
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filtra sugestões com base na categoria selecionada (após carregar do backend)
    final filteredSuggestions =
        _selectedCategory == null
            ? _suggestions
            : _suggestions
                .where(
                  (s) =>
                      s.categorias != null &&
                      s.categorias!.contains(_selectedCategory),
                )
                .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ideias de Encontros'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 107, 129),
        foregroundColor: Colors.white,
      ),
      body:
          _isLoading // Exibe indicador de carregamento enquanto busca dados
              ? const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 255, 107, 129),
                ),
              )
              : Column(
                children: [
                  // Área de Filtros (fundo branco)
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
                          _buildFilterChip(
                            context,
                            'Todos',
                            null,
                          ), // Chip para mostrar todas as categorias
                          // Os nomes das categorias aqui devem vir do backend ou ser fixos
                          _buildFilterChip(context, 'Romântico', 'Romântico'),
                          _buildFilterChip(
                            context,
                            'Ao Ar Livre',
                            'Ao Ar Livre',
                          ),
                          _buildFilterChip(context, 'Em Casa', 'Em Casa'),
                          _buildFilterChip(context, 'Aventura', 'Aventura'),
                          _buildFilterChip(
                            context,
                            'Gastronomia',
                            'Gastronomia',
                          ),
                          _buildFilterChip(
                            context,
                            'Baixo Custo',
                            'Baixo Custo',
                          ),
                          _buildFilterChip(context, 'Divertido', 'Divertido'),
                          // Adicione mais categorias conforme necessário, ou carregue-as dinamicamente
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
                                  'Nenhuma sugestão encontrada.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
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
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Detalhes de "${suggestion.titulo}" (UI Test)',
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Exibe imagem se imageUrl não for nulo/vazio
                                            if (suggestion.imageUrl != null &&
                                                suggestion
                                                    .imageUrl!
                                                    .isNotEmpty) ...[
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.network(
                                                  // Use Image.network para URLs
                                                  suggestion
                                                      .imageUrl!, // Usa a URL da imagem do backend
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
                                              suggestion
                                                  .titulo, // Usa o campo 'titulo' do modelo
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            if (suggestion.descricao != null &&
                                                suggestion
                                                    .descricao!
                                                    .isNotEmpty)
                                              Text(
                                                suggestion
                                                    .descricao!, // Usa o campo 'descricao'
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            const SizedBox(height: 8),
                                            // Exibe categorias se existirem
                                            if (suggestion.categorias != null &&
                                                suggestion
                                                    .categorias!
                                                    .isNotEmpty)
                                              Wrap(
                                                spacing: 8.0,
                                                children:
                                                    suggestion.categorias!
                                                        .map(
                                                          (category) => Chip(
                                                            label: Text(
                                                              category,
                                                              style:
                                                                  const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                            ),
                                                            backgroundColor:
                                                                Colors
                                                                    .deepPurple
                                                                    .withOpacity(
                                                                      0.2,
                                                                    ),
                                                            labelStyle:
                                                                const TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .deepPurple,
                                                                ),
                                                          ),
                                                        )
                                                        .toList(),
                                              ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: IconButton(
                                                icon: Icon(
                                                  // A lógica isFavorite precisaria de um campo no backend
                                                  // Por enquanto, mostra sempre o ícone de "não favorito"
                                                  Icons.favorite_border,
                                                  color: Colors.grey,
                                                ),
                                                onPressed: () {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Favoritar (UI Test - precisa de backend)',
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
          // FUTURO: Navegar para uma tela para adicionar/editar sugestões
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Adicionar nova sugestão (UI Test)')),
          );
        },
        backgroundColor: const Color.fromARGB(255, 255, 107, 129),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Widget auxiliar para os chips de filtro
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
