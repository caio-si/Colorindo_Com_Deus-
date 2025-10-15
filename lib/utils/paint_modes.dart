/// Enum para os modos de pintura disponíveis
enum PaintMode {
  /// Modo livre - toque direto na área para colorir
  free,
  
  /// Modo guiado - selecionar número da área e depois a cor
  guided,
}

/// Extensão para facilitar o uso do enum
extension PaintModeExtension on PaintMode {
  /// Retorna o nome amigável do modo
  String get displayName {
    switch (this) {
      case PaintMode.free:
        return 'Modo Livre';
      case PaintMode.guided:
        return 'Modo Guiado';
    }
  }
  
  /// Retorna o ícone correspondente ao modo
  String get icon {
    switch (this) {
      case PaintMode.free:
        return '🎨';
      case PaintMode.guided:
        return '🔢';
    }
  }
  
  /// Retorna a descrição do modo
  String get description {
    switch (this) {
      case PaintMode.free:
        return 'Toque diretamente na área para colorir';
      case PaintMode.guided:
        return 'Selecione o número da área e depois a cor';
    }
  }
}
