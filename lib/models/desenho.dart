import 'package:flutter/material.dart';

class Desenho {
  final String id;
  final String historiaId;
  final String titulo;
  final String imagemPath;
  final String miniaturaPath;
  final List<DesenhoArea> areas;

  Desenho({
    required this.id,
    required this.historiaId,
    required this.titulo,
    required this.imagemPath,
    required this.miniaturaPath,
    required this.areas,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'historiaId': historiaId,
      'titulo': titulo,
      'imagemPath': imagemPath,
      'miniaturaPath': miniaturaPath,
      'areas': areas.map((a) => a.toJson()).toList(),
    };
  }

  factory Desenho.fromJson(Map<String, dynamic> json) {
    return Desenho(
      id: json['id'],
      historiaId: json['historiaId'],
      titulo: json['titulo'],
      imagemPath: json['imagemPath'],
      miniaturaPath: json['miniaturaPath'],
      areas: (json['areas'] as List)
          .map((a) => DesenhoArea.fromJson(a))
          .toList(),
    );
  }
}

class DesenhoArea {
  final String id;
  final Path path;
  final Rect bounds;
  final int numero; // Número para colorir por números (1-15)
  final Color corSugerida; // Cor sugerida para esta área
  Color? corPreenchida;

  DesenhoArea({
    required this.id,
    required this.path,
    required this.bounds,
    required this.numero,
    required this.corSugerida,
    this.corPreenchida,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numero': numero,
      'corSugerida': corSugerida.value,
      'corPreenchida': corPreenchida?.value,
    };
  }

  factory DesenhoArea.fromJson(Map<String, dynamic> json) {
    return DesenhoArea(
      id: json['id'],
      path: Path(), // Será carregado do SVG
      bounds: Rect.zero,
      numero: json['numero'] ?? 1,
      corSugerida: Color(json['corSugerida'] ?? 0xFF000000),
      corPreenchida: json['corPreenchida'] != null
          ? Color(json['corPreenchida'])
          : null,
    );
  }

  void preencherComCor(Color cor) {
    corPreenchida = cor;
  }

  void limpar() {
    corPreenchida = null;
  }

  bool get isPreenchida => corPreenchida != null;
}

