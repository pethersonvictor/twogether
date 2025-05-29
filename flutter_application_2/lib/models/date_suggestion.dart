// lib/models/date_suggestion.dart
class DateSuggestionModel {
  // Renomeado para evitar conflito com a classe DateSuggestion da tela
  final String id;
  final String
  titulo; // Assumindo que seu backend usa 'titulo' para o nome da sugestão
  final String? descricao; // Assumindo 'descricao' para a descrição
  final String? dataImportanteId; // Se estiver vinculada a uma data importante
  final String? usuarioId; // Se a sugestão for criada por um usuário

  // Campos adicionais que você pode ter no backend para sugestões:
  final List<String>? categorias; // Ex: ['Romântico', 'Ao Ar Livre']
  final String? imageUrl; // URL de uma imagem para a sugestão

  DateSuggestionModel({
    required this.id,
    required this.titulo,
    this.descricao,
    this.dataImportanteId,
    this.usuarioId,
    this.categorias,
    this.imageUrl,
  });

  // Factory constructor para criar uma instância de DateSuggestionModel a partir de um JSON (Map)
  factory DateSuggestionModel.fromJson(Map<String, dynamic> json) {
    return DateSuggestionModel(
      id: json['_id'] as String,
      titulo: json['titulo'] as String,
      descricao: json['descricao'] as String?,
      dataImportanteId:
          json['data_importante_id'] != null
              ? (json['data_importante_id'] is Map
                      ? json['data_importante_id']['_id']
                      : json['data_importante_id'])
                  as String?
              : null,
      usuarioId:
          json['usuario_id'] != null
              ? (json['usuario_id'] is Map
                      ? json['usuario_id']['_id']
                      : json['usuario_id'])
                  as String?
              : null,
      // Se seu backend retorna categorias ou imagem:
      categorias:
          (json['categorias'] as List?)?.map((e) => e as String).toList(),
      imageUrl: json['imageUrl'] as String?,
    );
  }

  // Método para converter para JSON (útil para POST/PUT se o app permitir criar/editar)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'titulo': titulo,
      'descricao': descricao,
      'data_importante_id': dataImportanteId,
      'usuario_id': usuarioId,
      'categorias': categorias,
      'imageUrl': imageUrl,
    };
  }
}
