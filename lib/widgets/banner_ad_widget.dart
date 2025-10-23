import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import '../services/ad_service.dart';

class BannerAdWidget extends StatefulWidget {
  final bool isVisible;
  
  const BannerAdWidget({
    super.key,
    this.isVisible = true,
  });

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  bool _isAdFailed = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    // Não carrega anúncio se usuário é premium
    if (AdService.isPremiumUser) {
      setState(() {
        _isAdLoaded = false;
      });
      return;
    }
    
    // AdMob não funciona na web
    if (kIsWeb) {
      setState(() {
        _isAdLoaded = false;
      });
      return;
    }

    _bannerAd = BannerAd(
      adUnitId: AdService.bannerAdId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
            _isAdFailed = false;
          });
          print('📱 Banner ad carregado');
        },
        onAdFailedToLoad: (ad, error) {
          setState(() {
            _isAdFailed = true;
            _isAdLoaded = false;
          });
          print('❌ Banner ad falhou: $error');
          ad.dispose();
        },
        onAdOpened: (ad) => print('📱 Banner ad aberto'),
        onAdClosed: (ad) => print('📱 Banner ad fechado'),
      ),
    );

    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Não mostra se usuário é premium
    if (AdService.isPremiumUser) {
      return const SizedBox.shrink();
    }

    // Não mostra se não está visível
    if (!widget.isVisible) {
      return const SizedBox.shrink();
    }

    // Não mostra se anúncio falhou
    if (_isAdFailed) {
      return const SizedBox.shrink();
    }

    // Mostra loading ou anúncio
    if (!_isAdLoaded) {
      return Container(
        height: 50,
        color: Colors.grey[200],
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return Container(
      height: 50,
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
