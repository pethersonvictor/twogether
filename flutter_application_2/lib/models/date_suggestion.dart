// lib/models/date_suggestion.dart
// Este modelo será usado apenas para a estrutura dos dados MOCKADOS na tela de sugestões.
// Se você for integrar com o backend para sugestões no futuro, o fromJson/toJson
// precisaria corresponder à API real de sugestões do seu backend.
class DateSuggestionModel {
  final String id;
  final String titulo;
  final String? descricao;
  final String? dataImportanteId;
  final String? usuarioId;
  final List<String>? categorias;
  final String? imageUrl; // Agora esperando um asset local

  DateSuggestionModel({
    required this.id,
    required this.titulo,
    this.descricao,
    this.dataImportanteId,
    this.usuarioId,
    this.categorias,
    this.imageUrl,
  });

  // Este fromJson é baseado em como o backend retornaria, mas não será usado diretamente
  // na tela de sugestões AGORA, já que os dados serão mockados.
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
      categorias:
          (json['categorias'] as List?)?.map((e) => e as String).toList(),
      imageUrl:
          json['imageUrl'] as String?, // Ainda espera URL se vier do backend
    );
  }

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
