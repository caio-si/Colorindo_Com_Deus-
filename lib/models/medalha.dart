enum TipoMedalha {
  primeiraPintura,
  cincoHistorias,
  dezHistorias,
  todosDesenhos,
  artistaDedicado,
}

class Medalha {
  final TipoMedalha tipo;
  final String titulo;
  final String descricao;
  final String iconePath;
  final bool conquistada;
  final DateTime? dataConquista;

  Medalha({
    required this.tipo,
    required this.titulo,
    required this.descricao,
    required this.iconePath,
    this.conquistada = false,
    this.dataConquista,
  });

  Map<String, dynamic> toJson() {
    return {
      'tipo': tipo.toString(),
      'titulo': titulo,
      'descricao': descricao,
      'iconePath': iconePath,
      'conquistada': conquistada,
      'dataConquista': dataConquista?.toIso8601String(),
    };
  }

  factory Medalha.fromJson(Map<String, dynamic> json) {
    return Medalha(
      tipo: TipoMedalha.values.firstWhere(
        (e) => e.toString() == json['tipo'],
      ),
      titulo: json['titulo'],
      descricao: json['descricao'],
      iconePath: json['iconePath'],
      conquistada: json['conquistada'],
      dataConquista: json['dataConquista'] != null
          ? DateTime.parse(json['dataConquista'])
          : null,
    );
  }
}

