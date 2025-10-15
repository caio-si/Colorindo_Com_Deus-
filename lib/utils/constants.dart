class AppConstants {
  // Versão do App
  static const String appVersion = '1.0.0';
  static const String appName = 'Colorindo com Deus';
  
  // Configurações de UI
  static const double borderRadius = 20.0;
  static const double cardElevation = 5.0;
  static const double iconSize = 28.0;
  
  // Animações
  static const int animationDuration = 300;
  static const int shortAnimationDuration = 150;
  
  // Storage Keys
  static const String keySettings = 'settings';
  static const String keyProgress = 'progress';
  static const String keyGallery = 'gallery';
  
  // Configurações de Desenho
  static const double minZoom = 0.5;
  static const double maxZoom = 4.0;
  static const double strokeWidth = 2.0;
  
  // Versículos de Prêmio
  static const List<String> prizeVerses = [
    '"Tudo posso naquele que me fortalece."\nFilipenses 4:13',
    '"Porque Deus amou o mundo de tal maneira que deu o seu Filho unigênito."\nJoão 3:16',
    '"O Senhor é o meu pastor; nada me faltará."\nSalmos 23:1',
    '"Confie no Senhor de todo o seu coração."\nProvérbios 3:5',
    '"Seja forte e corajoso! Não tenha medo."\nJosué 1:9',
    '"Jesus Cristo é o mesmo ontem, hoje e para sempre."\nHebreus 13:8',
    '"Deus é amor."\n1 João 4:8',
    '"Ame o Senhor, o seu Deus, de todo o seu coração."\nMateus 22:37',
    '"Deixai vir a mim as criancinhas."\nMarcos 10:14',
    '"Eu sou o caminho, a verdade e a vida."\nJoão 14:6',
  ];
  
  // Mensagens de Conquista
  static const Map<int, String> achievementMessages = {
    1: 'Primeira obra de arte! 🎨',
    5: 'Artista dedicado! Você coloriu 5 desenhos! ⭐',
    10: 'Mestre das cores! Todos os desenhos completos! 🏆',
  };
}

