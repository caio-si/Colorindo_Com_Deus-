import 'package:flutter/material.dart';

/// Enum para as ferramentas de pintura disponíveis
enum PaintingTool {
  /// Pincel fino
  thinBrush,
  
  /// Pincel médio
  mediumBrush,
  
  /// Pincel grosso
  thickBrush,
  
  /// Borracha
  eraser,
}

/// Extensão para facilitar o uso do enum
extension PaintingToolExtension on PaintingTool {
  /// Retorna o nome amigável da ferramenta
  String get displayName {
    switch (this) {
      case PaintingTool.thinBrush:
        return 'Pincel Fino';
      case PaintingTool.mediumBrush:
        return 'Pincel Médio';
      case PaintingTool.thickBrush:
        return 'Pincel Grosso';
      case PaintingTool.eraser:
        return 'Borracha';
    }
  }
  
  /// Retorna o ícone correspondente à ferramenta
  IconData get icon {
    switch (this) {
      case PaintingTool.thinBrush:
        return Icons.brush;
      case PaintingTool.mediumBrush:
        return Icons.brush;
      case PaintingTool.thickBrush:
        return Icons.brush;
      case PaintingTool.eraser:
        return Icons.auto_fix_off;
    }
  }
  
  /// Retorna o tamanho do pincel
  double get brushSize {
    switch (this) {
      case PaintingTool.thinBrush:
        return 4.0;
      case PaintingTool.mediumBrush:
        return 8.0;
      case PaintingTool.thickBrush:
        return 16.0;
      case PaintingTool.eraser:
        return 12.0;
    }
  }
  
  /// Retorna se é uma borracha
  bool get isEraser {
    return this == PaintingTool.eraser;
  }
}
