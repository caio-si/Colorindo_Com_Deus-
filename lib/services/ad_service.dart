import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class AdService {
  static bool _isInitialized = false;
  static bool _isPremiumUser = false;
  
  // IDs do AdMob (teste vs produção)
  static const String _appId = 'ca-app-pub-4568120024867730~1895739471';
  static const String _bannerAdId = 'ca-app-pub-3940256099942544/6300978111'; // ID de teste
  static const String _interstitialAdId = 'ca-app-pub-3940256099942544/1033173712'; // ID de teste
  static const String _rewardedAdId = 'ca-app-pub-3940256099942544/5224354917'; // ID de teste
  
  // Contador para intersticial
  static int _interstitialCounter = 0;
  static const int _interstitialFrequency = 5; // A cada 5 navegações
  
  // Histórias bloqueadas (últimas 3) - TEMPORARIAMENTE DESABILITADO
  static const List<String> _lockedStories = ['9', '10', '11'];
  
  // ===== SISTEMA DE DESBLOQUEIO TEMPORÁRIO =====
  // - Últimas 3 histórias bloqueadas por padrão
  // - Desbloqueio via anúncio em vídeo (12h)
  // - Persistência local dos desbloqueios
  // - Verificação automática de expiração
  // - Intersticiais a cada 5 navegações (menos intrusivo)
  
  /// Inicializa o AdMob
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    // AdMob não funciona na web - apenas em dispositivos móveis
    if (kIsWeb) {
      print('🌐 Web detectada - AdMob desabilitado');
      await _loadPremiumStatus();
      await cleanExpiredUnlocks();
      _isInitialized = true;
      return;
    }
    
    await MobileAds.instance.initialize();
    await _loadPremiumStatus();
    await cleanExpiredUnlocks(); // Limpar desbloqueios expirados
    _isInitialized = true;
    
    print('🎯 AdService inicializado');
  }
  
  /// Carrega status premium do usuário
  static Future<void> _loadPremiumStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isPremiumUser = prefs.getBool('is_premium_user') ?? false;
    print('💎 Status Premium: $_isPremiumUser');
  }
  
  /// Verifica se usuário é premium
  static bool get isPremiumUser => _isPremiumUser;
  
  /// Verifica se história está bloqueada (assíncrono)
  static Future<bool> isStoryLocked(String storyId) async {
    if (_isPremiumUser) return false;
    if (!_lockedStories.contains(storyId)) return false;
    
    // Na web, todas as histórias estão desbloqueadas (sem anúncios)
    if (kIsWeb) return false;
    
    // Verificar se está desbloqueada temporariamente
    return !(await _isStoryTemporarilyUnlocked(storyId));
  }
  
  /// Verifica se história está desbloqueada temporariamente
  static Future<bool> _isStoryTemporarilyUnlocked(String storyId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final unlockTime = prefs.getInt('unlock_time_$storyId');
      if (unlockTime == null) return false;
      
      final now = DateTime.now().millisecondsSinceEpoch;
      final unlockDuration = 12 * 60 * 60 * 1000; // 12 horas em millisegundos
      
      return (now - unlockTime) < unlockDuration;
    } catch (e) {
      print('❌ Erro ao verificar desbloqueio: $e');
      return false;
    }
  }
  
  /// Desbloqueia história temporariamente (12h)
  static Future<void> unlockStoryTemporarily(String storyId) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().millisecondsSinceEpoch;
    await prefs.setInt('unlock_time_$storyId', now);
    print('🔓 História $storyId desbloqueada por 12 horas');
  }
  
  /// Verifica se história está desbloqueada (síncrono para UI)
  static bool isStoryUnlocked(String storyId) {
    if (_isPremiumUser) return true;
    if (!_lockedStories.contains(storyId)) return true;
    
    // Verificação síncrona básica - para UI responsiva
    // A verificação completa será feita assincronamente
    return false; // Por padrão, assume bloqueada se for uma das últimas 3
  }
  
  /// Obtém tempo restante de desbloqueio em horas
  static Future<int> getRemainingUnlockHours(String storyId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final unlockTime = prefs.getInt('unlock_time_$storyId');
      if (unlockTime == null) return 0;
      
      final now = DateTime.now().millisecondsSinceEpoch;
      final unlockDuration = 12 * 60 * 60 * 1000; // 12 horas em millisegundos
      final remaining = unlockDuration - (now - unlockTime);
      
      if (remaining <= 0) return 0;
      return (remaining / (60 * 60 * 1000)).ceil(); // Converter para horas
    } catch (e) {
      print('❌ Erro ao calcular tempo restante: $e');
      return 0;
    }
  }
  
  /// Limpa desbloqueios expirados
  static Future<void> cleanExpiredUnlocks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now().millisecondsSinceEpoch;
      final unlockDuration = 12 * 60 * 60 * 1000; // 12 horas
      
      for (final storyId in _lockedStories) {
        final unlockTime = prefs.getInt('unlock_time_$storyId');
        if (unlockTime != null && (now - unlockTime) >= unlockDuration) {
          await prefs.remove('unlock_time_$storyId');
          print('🧹 Desbloqueio expirado removido para história $storyId');
        }
      }
    } catch (e) {
      print('❌ Erro ao limpar desbloqueios expirados: $e');
    }
  }
  
  /// Incrementa contador de intersticial
  static void incrementInterstitialCounter() {
    _interstitialCounter++;
  }
  
  /// Verifica se deve mostrar intersticial
  static bool shouldShowInterstitial() {
    if (_isPremiumUser) return false;
    return _interstitialCounter >= _interstitialFrequency;
  }
  
  /// Reseta contador de intersticial
  static void resetInterstitialCounter() {
    _interstitialCounter = 0;
  }
  
  /// IDs dos anúncios
  static String get appId => _appId;
  static String get bannerAdId => _bannerAdId;
  static String get interstitialAdId => _interstitialAdId;
  static String get rewardedAdId => _rewardedAdId;
  
  /// Ativa usuário premium
  static Future<void> activatePremium() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_premium_user', true);
    _isPremiumUser = true;
    print('💎 Usuário premium ativado!');
  }
  
  /// Desativa usuário premium (para testes)
  static Future<void> deactivatePremium() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_premium_user', false);
    _isPremiumUser = false;
    print('💎 Usuário premium desativado!');
  }
}
