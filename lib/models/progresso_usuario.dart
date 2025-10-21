import 'drawing_lines.dart';

class ProgressoUsuario {
  final String id;
  final String desenhoId;
  final Map<String, int> areasColoridas; // areaId -> cor (int value)
  final DateTime dataModificacao;
  final bool finalizado;
  final DrawingLines? drawingLines; // Linhas de desenho livre

  ProgressoUsuario({
    required this.id,
    required this.desenhoId,
    required this.areasColoridas,
    required this.dataModificacao,
    this.finalizado = false,
    this.drawingLines,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'desenhoId': desenhoId,
      'areasColoridas': areasColoridas,
      'dataModificacao': dataModificacao.toIso8601String(),
      'finalizado': finalizado,
      'drawingLines': drawingLines?.toJson(),
    };
  }

  factory ProgressoUsuario.fromJson(Map<String, dynamic> json) {
    return ProgressoUsuario(
      id: json['id']?.toString() ?? '',
      desenhoId: json['desenhoId']?.toString() ?? '',
      areasColoridas: json['areasColoridas'] != null 
          ? Map<String, int>.from(json['areasColoridas'].map((k, v) => MapEntry(k.toString(), v is int ? v : int.tryParse(v.toString()) ?? 0)))
          : <String, int>{},
      dataModificacao: DateTime.parse(json['dataModificacao']?.toString() ?? DateTime.now().toIso8601String()),
      finalizado: json['finalizado'] == true || json['finalizado'] == 'true',
      drawingLines: json['drawingLines'] != null 
          ? DrawingLines.fromJson(Map<String, dynamic>.from(json['drawingLines']))
          : null,
    );
  }

  ProgressoUsuario copyWith({
    String? id,
    String? desenhoId,
    Map<String, int>? areasColoridas,
    DateTime? dataModificacao,
    bool? finalizado,
    DrawingLines? drawingLines,
  }) {
    return ProgressoUsuario(
      id: id ?? this.id,
      desenhoId: desenhoId ?? this.desenhoId,
      areasColoridas: areasColoridas ?? this.areasColoridas,
      dataModificacao: dataModificacao ?? this.dataModificacao,
      finalizado: finalizado ?? this.finalizado,
      drawingLines: drawingLines ?? this.drawingLines,
    );
  }
}

