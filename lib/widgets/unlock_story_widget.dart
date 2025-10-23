import 'package:flutter/material.dart';
import '../services/ad_service.dart';
import '../utils/app_colors.dart';
import 'rewarded_ad_service.dart';

class UnlockStoryWidget extends StatefulWidget {
  final String storyId;
  final String storyTitle;
  final VoidCallback? onUnlocked;

  const UnlockStoryWidget({
    super.key,
    required this.storyId,
    required this.storyTitle,
    this.onUnlocked,
  });

  @override
  State<UnlockStoryWidget> createState() => _UnlockStoryWidgetState();
}

class _UnlockStoryWidgetState extends State<UnlockStoryWidget> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pré-carrega o anúncio
    RewardedAdService.preloadNextAd();
  }

  Future<void> _unlockWithAd() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Mostra anúncio rewarded
      final success = await RewardedAdService.showRewardedAd();
      
      if (success) {
        // Aqui você pode implementar a lógica de desbloqueio
        // Por exemplo, salvar no SharedPreferences que a história foi desbloqueada
        await _unlockStory();
        
        if (widget.onUnlocked != null) {
          widget.onUnlocked!();
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 ${widget.storyTitle} desbloqueada!'),
            backgroundColor: AppColors.secondary,
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Anúncio não disponível. Tente novamente.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Erro: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _unlockStory() async {
    // Implementar lógica de desbloqueio
    // Por exemplo, salvar no SharedPreferences
    print('🔓 História ${widget.storyId} desbloqueada!');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ícone de cadeado
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock,
              size: 30,
              color: AppColors.secondary,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Título
          Text(
            'Desbloquear História',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Descrição
          Text(
            'Assista a um anúncio para desbloquear "${widget.storyTitle}"',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Botão de desbloqueio
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _unlockWithAd,
              icon: _isLoading 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.play_arrow),
              label: Text(_isLoading ? 'Carregando...' : 'Assistir Anúncio'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Opção premium
          TextButton(
            onPressed: () {
              // Navegar para tela de premium
              _showPremiumDialog();
            },
            child: const Text(
              'Ou compre Premium (R\$ 12,99)',
              style: TextStyle(
                color: AppColors.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPremiumDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('💎 Premium'),
        content: const Text(
          'Com Premium você tem acesso a:\n\n'
          '• Todas as histórias desbloqueadas\n'
          '• Sem anúncios\n'
          '• Cores especiais\n'
          '• Ferramentas avançadas\n\n'
          'Apenas R\$ 12,99/mês',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implementar compra premium
              _purchasePremium();
            },
            child: const Text('Comprar Premium'),
          ),
        ],
      ),
    );
  }

  void _purchasePremium() {
    // Implementar lógica de compra
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('💎 Funcionalidade de compra em desenvolvimento'),
        backgroundColor: AppColors.secondary,
      ),
    );
  }
}
