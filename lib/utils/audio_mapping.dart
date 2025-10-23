/// Mapeamento dos IDs das histórias para os nomes dos arquivos de áudio
class AudioMapping {
  static const Map<String, String> _audioFiles = {
    '1': 'A Criação do Mundo.mp3',
    '2': 'Noé e a Arca.mp3',
    '3': 'Davi e Golias.mp3',
    '4': 'Jonas e o Grande Peixe.mp3',
    '5': 'Daniel na Cova dos Leões.mp3',
    '6': 'O Nascimento de Jesus.mp3',
    '7': 'Jesus Acalma a Tempestade.mp3',
    '8': 'A Multiplicação dos Pães e Peixes.mp3',
    '9': 'O Bom Samaritano.mp3',
    '10': 'Zaqueu na Árvore.mp3',
    '11': 'Tentacao_deserto.mp3',
  };

  /// Retorna o caminho do arquivo de áudio para uma história
  static String? getAudioPath(String historiaId) {
    final fileName = _audioFiles[historiaId];
    return fileName != null ? 'audio/$fileName' : null;
  }

  /// Retorna todos os arquivos de áudio disponíveis
  static List<String> getAllAudioFiles() {
    return _audioFiles.values.map((fileName) => 'audio/$fileName').toList();
  }
}
