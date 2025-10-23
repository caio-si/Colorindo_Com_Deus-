import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import '../l10n/app_localizations.dart';
import '../utils/app_colors.dart';
import '../services/ad_service.dart';

class StoryUnlockWidget extends StatefulWidget {
  final String storyId;
  final String storyTitle;
  final VoidCallback onUnlocked;

  const StoryUnlockWidget({
    super.key,
    required this.storyId,
    required this.storyTitle,
    required this.onUnlocked,
  });

  @override
  State<StoryUnlockWidget> createState() => _StoryUnlockWidgetState();
}

class _StoryUnlockWidgetState extends State<StoryUnlockWidget> {
  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;
  bool _isLoading = false;
  int _remainingHours = 0;

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
    _checkRemainingTime();
  }

  void _loadRewardedAd() {
    if (AdService.isPremiumUser) return;
    if (kIsWeb) return; // AdMob não funciona na web

    RewardedAd.load(
      adUnitId: AdService.rewardedAdId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          setState(() {
            _isAdLoaded = true;
          });
          print('🎬 RewardedAd carregado para desbloqueio');
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('❌ Erro ao carregar RewardedAd: $error');
          setState(() {
            _isAdLoaded = false;
          });
        },
      ),
    );
  }

  void _checkRemainingTime() async {
    final hours = await AdService.getRemainingUnlockHours(widget.storyId);
    if (mounted) {
      setState(() {
        _remainingHours = hours;
      });
    }
  }

  void _showUnlockAd() async {
    if (_isLoading || !_isAdLoaded || _rewardedAd == null) return;

    setState(() {
      _isLoading = true;
    });

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        ad.dispose();
        _loadRewardedAd(); // Carregar novo anúncio
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        ad.dispose();
        _loadRewardedAd(); // Carregar novo anúncio
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Erro ao exibir anúncio');
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
        print('🎁 Usuário ganhou recompensa: ${rewardItem.amount} ${rewardItem.type}');
        _unlockStory();
      },
    );
  }

  void _unlockStory() async {
    try {
      await AdService.unlockStoryTemporarily(widget.storyId);
      setState(() {
        _isLoading = false;
        _remainingHours = 12; // 12 horas de desbloqueio
      });
      
      widget.onUnlocked();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.storyTitle} desbloqueada por 12 horas!'),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('❌ Erro ao desbloquear história: $e');
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Erro ao desbloquear história');
    }
  }

  void _showErrorDialog(String message) {
    if (!mounted) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accent.withOpacity(0.1),
            AppColors.primary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ícone de cadeado
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock,
              size: 40,
              color: AppColors.accent,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Título
          Text(
            'Conteúdo Bloqueado',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Descrição
          Text(
            '${widget.storyTitle} está bloqueada. Assista a um anúncio para desbloqueá-la por 12 horas!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          
          if (_remainingHours > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.success.withOpacity(0.3)),
              ),
              child: Text(
                '⏰ Desbloqueada por mais ${_remainingHours}h',
                style: TextStyle(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
          
          const SizedBox(height: 20),
          
          // Botão de desbloqueio
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isAdLoaded && !_isLoading ? _showUnlockAd : null,
              icon: _isLoading 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.play_circle_outline),
              label: Text(
                _isLoading 
                  ? 'Carregando...'
                  : _isAdLoaded 
                    ? 'Assistir Anúncio para Desbloquear'
                    : 'Carregando Anúncio...',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Informação adicional
          Text(
            'O desbloqueio dura 12 horas. Após esse período, você precisará assistir a um novo anúncio.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary.withOpacity(0.7),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
