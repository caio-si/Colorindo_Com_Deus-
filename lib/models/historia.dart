class Historia {
  final String id;
  final String titulo;
  final String descricao;
  final String? descricaoCompleta;
  final String imagemPath;
  final String? audioNarracaoPath;
  final String referenciaBiblica;
  final String desenhoId;

  Historia({
    required this.id,
    required this.titulo,
    required this.descricao,
    this.descricaoCompleta,
    required this.imagemPath,
    this.audioNarracaoPath,
    required this.referenciaBiblica,
    required this.desenhoId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'descricaoCompleta': descricaoCompleta,
      'imagemPath': imagemPath,
      'audioNarracaoPath': audioNarracaoPath,
      'referenciaBiblica': referenciaBiblica,
      'desenhoId': desenhoId,
    };
  }

  factory Historia.fromJson(Map<String, dynamic> json) {
    return Historia(
      id: json['id'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      descricaoCompleta: json['descricaoCompleta'],
      imagemPath: json['imagemPath'],
      audioNarracaoPath: json['audioNarracaoPath'],
      referenciaBiblica: json['referenciaBiblica'],
      desenhoId: json['desenhoId'],
    );
  }
}

