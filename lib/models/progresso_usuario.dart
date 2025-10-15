class ProgressoUsuario {
  final String id;
  final String desenhoId;
  final Map<String, int> areasColoridas; // areaId -> cor (int value)
  final DateTime dataModificacao;
  final bool finalizado;

  ProgressoUsuario({
    required this.id,
    required this.desenhoId,
    required this.areasColoridas,
    required this.dataModificacao,
    this.finalizado = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'desenhoId': desenhoId,
      'areasColoridas': areasColoridas,
      'dataModificacao': dataModificacao.toIso8601String(),
      'finalizado': finalizado,
    };
  }

  factory ProgressoUsuario.fromJson(Map<String, dynamic> json) {
    return ProgressoUsuario(
      id: json['id'],
      desenhoId: json['desenhoId'],
      areasColoridas: Map<String, int>.from(json['areasColoridas']),
      dataModificacao: DateTime.parse(json['dataModificacao']),
      finalizado: json['finalizado'] ?? false,
    );
  }

  ProgressoUsuario copyWith({
    String? id,
    String? desenhoId,
    Map<String, int>? areasColoridas,
    DateTime? dataModificacao,
    bool? finalizado,
  }) {
    return ProgressoUsuario(
      id: id ?? this.id,
      desenhoId: desenhoId ?? this.desenhoId,
      areasColoridas: areasColoridas ?? this.areasColoridas,
      dataModificacao: dataModificacao ?? this.dataModificacao,
      finalizado: finalizado ?? this.finalizado,
    );
  }
}

