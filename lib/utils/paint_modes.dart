/// Enum para os modos de pintura disponíveis
enum PaintMode {
  /// Modo livre - arrastar para pintar livremente
  free,
}

/// Extensão para facilitar o uso do enum
extension PaintModeExtension on PaintMode {
  /// Retorna o nome amigável do modo
  String get displayName {
    switch (this) {
      case PaintMode.free:
        return 'Modo Livre';
    }
  }
  
  /// Retorna o ícone correspondente ao modo
  String get icon {
    switch (this) {
      case PaintMode.free:
        return '🎨';
    }
  }
  
  /// Retorna a descrição do modo
  String get description {
    switch (this) {
      case PaintMode.free:
        return 'Arraste o dedo para pintar livremente';
    }
  }
}
