import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/ad_service.dart';

class RewardedAdService {
  static RewardedAd? _rewardedAd;
  static bool _isAdLoaded = false;

  /// Carrega anúncio rewarded
  static Future<void> loadRewardedAd() async {
    // Não carrega se usuário é premium
    if (AdService.isPremiumUser) return;

    try {
      _rewardedAd = RewardedAd(
        adUnitId: AdService.rewardedAdId,
        request: const AdRequest(),
        listener: RewardedAdListener(
          onAdLoaded: (ad) {
            _isAdLoaded = true;
            print('📱 Rewarded ad carregado');
          },
          onAdFailedToLoad: (ad, error) {
            _isAdLoaded = false;
            print('❌ Rewarded ad falhou: $error');
            ad.dispose();
          },
          onAdOpened: (ad) => print('📱 Rewarded ad aberto'),
          onAdClosed: (ad) {
            print('📱 Rewarded ad fechado');
            ad.dispose();
            _isAdLoaded = false;
            _rewardedAd = null;
          },
          onUserEarnedReward: (ad, reward) {
            print('🎁 Recompensa ganha: ${reward.amount} ${reward.type}');
            // Aqui você pode implementar a lógica de desbloqueio
            _onRewardEarned();
          },
        ),
      );

      await _rewardedAd?.load();
    } catch (e) {
      print('❌ Erro ao carregar rewarded: $e');
    }
  }

  /// Mostra anúncio rewarded se disponível
  static Future<bool> showRewardedAd() async {
    // Não mostra se usuário é premium
    if (AdService.isPremiumUser) return false;

    // Não mostra se anúncio não está carregado
    if (!_isAdLoaded || _rewardedAd == null) {
      print('⚠️ Rewarded ad não disponível');
      return false;
    }

    try {
      await _rewardedAd?.show();
      print('📱 Rewarded ad exibido');
      return true;
    } catch (e) {
      print('❌ Erro ao mostrar rewarded: $e');
      return false;
    }
  }

  /// Callback quando usuário ganha recompensa
  static void _onRewardEarned() {
    // Implementar lógica de desbloqueio aqui
    print('🎁 História desbloqueada!');
  }

  /// Verifica se anúncio está carregado
  static bool get isAdLoaded => _isAdLoaded;

  /// Força carregar novo anúncio
  static Future<void> preloadNextAd() async {
    if (!AdService.isPremiumUser) {
      await loadRewardedAd();
    }
  }
}
