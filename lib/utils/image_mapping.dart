/// Mapeamento dos IDs das histórias para os nomes dos arquivos de imagens
class ImageMapping {
  // Mapeamento para imagens dos desenhos (para colorir)
  static const Map<String, String> _drawingImages = {
    '1': 'A criação.png',
    '2': 'Arca de Noé.png',
    '3': 'Davi e Golias.png', // Para Davi e Golias (usando o que temos)
    '4': 'Jonas e o peixe.png',
    '5': 'Daniel na Cova 1.png',
    '6': 'O nascimento de Jesus.png',
    '7': 'Jesus acalma a tempestade.png',
    '8': 'Multiplicador de pães.png', // Para multiplicação dos pães
    '9': 'O Bom Samaritano.png', // Para bom samaritano
    '10': 'Zaqueu na Arvore.png', // Para Zaqueu (usando o que temos)
  };

  // Mapeamento para imagens das histórias (ilustrações)
  static const Map<String, String> _storyImages = {
    '1': 'A criação colorida.png',
    '2': 'Arca de noé colorido.png',
    '3': 'Davi e Golias Colorido.png',
    '4': 'Jonas e o peixe grande Colorido.png',
    '5': 'Daniel na Cova colorido.png',
    '6': 'O Nascimento de Jesus colorido.png',
    '7': 'Jesus acalma a tempestade colorido.png',
    '8': 'Multiplicador de pães colorido.png',
    '9': 'O Bom Samaritano colorido.png',
    '10': 'Zaqueu na Arvore colorido.png',
  };

  /// Retorna o caminho da imagem do desenho para uma história
  static String? getDrawingImagePath(String historiaId) {
    final fileName = _drawingImages[historiaId];
    if (fileName == null) return null;
    
    return 'assets/images/drawings/$fileName';
  }

  /// Retorna o caminho da imagem da história para uma história
  static String? getStoryImagePath(String historiaId) {
    final fileName = _storyImages[historiaId];
    return fileName != null ? 'assets/images/stories/$fileName' : null;
  }

  /// Retorna todos os arquivos de desenho disponíveis
  static List<String> getAllDrawingImages() {
    return _drawingImages.values.map((fileName) => 'assets/images/drawings/$fileName').toList();
  }

  /// Retorna todos os arquivos de história disponíveis
  static List<String> getAllStoryImages() {
    return _storyImages.values.map((fileName) => 'assets/images/stories/$fileName').toList();
  }
}
