// lib/models/important_date.dart
class ImportantDate {
  final String id;
  final String titulo;
  final DateTime dataEvento;
  final String? local;
  final String? momento;
  final String? usuarioId;

  ImportantDate({
    required this.id,
    required this.titulo,
    required this.dataEvento,
    this.local,
    this.momento,
    this.usuarioId,
  });

  factory ImportantDate.fromJson(Map<String, dynamic> json) {
    return ImportantDate(
      id: json['_id'] as String,
      titulo: json['titulo'] as String,
      dataEvento: DateTime.parse(json['data_evento'] as String),
      local: json['local'] as String?,
      momento: json['momento'] as String?,
      usuarioId:
          json['usuario_id'] != null
              ? (json['usuario_id'] is Map
                      ? json['usuario_id']['_id']
                      : json['usuario_id'])
                  as String?
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'titulo': titulo,
      'data_evento': dataEvento.toIso8601String(),
      'local': local,
      'momento': momento,
      'usuario_id': usuarioId,
    };
  }
}
