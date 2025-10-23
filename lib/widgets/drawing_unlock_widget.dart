import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import '../l10n/app_localizations.dart';
import '../utils/app_colors.dart';
import '../services/ad_service.dart';

class DrawingUnlockWidget extends StatefulWidget {
  final String storyId;
  final String drawingTitle;
  final VoidCallback onUnlocked;

  const DrawingUnlockWidget({
    super.key,
    required this.storyId,
    required this.drawingTitle,
    required this.onUnlocked,
  });

  @override
  State<DrawingUnlockWidget> createState() => _DrawingUnlockWidgetState();
}

class _DrawingUnlockWidgetState extends State<DrawingUnlockWidget> {
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
          print('🎬 RewardedAd carregado para desbloqueio de desenho');
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
        _unlockDrawing();
      },
    );
  }

  void _unlockDrawing() async {
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
            content: Text('${widget.drawingTitle} desbloqueado por 12 horas!'),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('❌ Erro ao desbloquear desenho: $e');
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Erro ao desbloquear desenho');
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Área de imagem bloqueada
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  // Ícone de cadeado centralizado
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
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
                        Text(
                          'Desenho Bloqueado',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Overlay escuro
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Área de informações e botão
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Título do desenho
                  Text(
                    widget.drawingTitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  // Status de desbloqueio
                  if (_remainingHours > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.success.withOpacity(0.3)),
                      ),
                      child: Text(
                        '⏰ ${_remainingHours}h restantes',
                        style: TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  
                  // Botão de desbloqueio
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isAdLoaded && !_isLoading ? _showUnlockAd : null,
                      icon: _isLoading 
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.play_circle_outline, size: 16),
                      label: Text(
                        _isLoading 
                          ? 'Carregando...'
                          : _isAdLoaded 
                            ? 'Assistir Anúncio'
                            : 'Carregando...',
                        style: const TextStyle(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
