import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import '../services/ad_service.dart';

class InterstitialAdService {
  static InterstitialAd? _interstitialAd;
  static bool _isAdLoaded = false;
  static int _loadAttempts = 0;
  static const int _maxLoadAttempts = 3;

  /// Carrega um anúncio intersticial
  static Future<void> loadAd() async {
    if (AdService.isPremiumUser) return;
    if (_isAdLoaded) return;
    if (kIsWeb) return; // AdMob não funciona na web

    try {
      await InterstitialAd.load(
        adUnitId: AdService.interstitialAdId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            _isAdLoaded = true;
            _loadAttempts = 0;
            print('📱 InterstitialAd carregado com sucesso');
          },
          onAdFailedToLoad: (LoadAdError error) {
            _interstitialAd = null;
            _isAdLoaded = false;
            _loadAttempts++;
            print('❌ Erro ao carregar InterstitialAd: $error');
            
            // Tentar carregar novamente se não excedeu o limite
            if (_loadAttempts < _maxLoadAttempts) {
              Future.delayed(const Duration(seconds: 2), () {
                loadAd();
              });
            }
          },
        ),
      );
    } catch (e) {
      print('❌ Erro ao carregar InterstitialAd: $e');
    }
  }

  /// Exibe o anúncio intersticial se estiver carregado
  static Future<void> showAd() async {
    if (AdService.isPremiumUser) return;
    if (kIsWeb) return; // AdMob não funciona na web
    if (!_isAdLoaded || _interstitialAd == null) {
      print('⚠️ InterstitialAd não está carregado');
      return;
    }

    try {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          print('📱 InterstitialAd dispensado');
          ad.dispose();
          _isAdLoaded = false;
          _interstitialAd = null;
          // Carregar próximo anúncio
          loadAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          print('❌ Erro ao exibir InterstitialAd: $error');
          ad.dispose();
          _isAdLoaded = false;
          _interstitialAd = null;
          // Carregar próximo anúncio
          loadAd();
        },
      );

      await _interstitialAd!.show();
      print('📱 InterstitialAd exibido');
    } catch (e) {
      print('❌ Erro ao exibir InterstitialAd: $e');
    }
  }

  /// Verifica se deve mostrar intersticial e exibe se necessário
  static Future<void> showAdIfNeeded() async {
    if (AdService.shouldShowInterstitial()) {
      await showAd();
      AdService.resetInterstitialCounter();
    }
  }

  /// Força o carregamento de um novo anúncio
  static Future<void> forceLoadAd() async {
    _isAdLoaded = false;
    _interstitialAd?.dispose();
    _interstitialAd = null;
    await loadAd();
  }

  /// Limpa recursos
  static void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isAdLoaded = false;
  }
}