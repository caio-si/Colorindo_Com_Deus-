import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../utils/app_colors.dart';
import '../utils/image_mapping.dart';
import '../data/desenhos_data.dart';
import '../models/desenho.dart';
import '../providers/drawing_provider.dart';
import '../services/ad_service.dart';
import '../widgets/drawing_unlock_widget.dart';
import '../widgets/interstitial_ad_service.dart';
import 'coloring_screen.dart';

class DrawingsSelectionScreen extends StatelessWidget {
  const DrawingsSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final desenhos = DesenhosData.obterDesenhos();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.selectDrawing),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary.withOpacity(0.1),
              AppColors.background,
            ],
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: desenhos.length,
          itemBuilder: (context, index) {
            return _DrawingCard(
              desenho: desenhos[index],
              onTap: () {
                _startNewDrawing(context, desenhos[index]);
              },
            );
          },
        ),
      ),
    );
  }

  void _startNewDrawing(BuildContext context, Desenho desenho) async {
    // Incrementar contador de intersticial
    AdService.incrementInterstitialCounter();
    
    final drawingProvider = Provider.of<DrawingProvider>(context, listen: false);
    
    // Limpar qualquer progresso existente para criar um novo desenho
    await drawingProvider.createNewDrawing(desenho);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ColoringScreen(desenho: desenho),
      ),
    );
    
    // Mostrar intersticial se necessário
    await InterstitialAdService.showAdIfNeeded();
  }
}

class _DrawingCard extends StatefulWidget {
  final Desenho desenho;
  final VoidCallback onTap;

  const _DrawingCard({
    required this.desenho,
    required this.onTap,
  });

  @override
  State<_DrawingCard> createState() => _DrawingCardState();
}

class _DrawingCardState extends State<_DrawingCard> {
  bool _isLocked = false;

  @override
  void initState() {
    super.initState();
    _checkLockStatus();
  }

  Future<void> _checkLockStatus() async {
    // Obter o ID da história correspondente ao desenho
    final historiaId = widget.desenho.id.replaceAll('desenho_', '');
    final isLocked = await AdService.isStoryLocked(historiaId);
    if (mounted) {
      setState(() {
        _isLocked = isLocked;
      });
    }
  }

  Widget _getDrawingImage() {
    // Obter o ID da história correspondente ao desenho
    final historiaId = widget.desenho.id.replaceAll('desenho_', '');
    final imagePath = ImageMapping.getDrawingImagePath(historiaId);
    
    if (imagePath != null) {
      return Image.asset(
        imagePath,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        gaplessPlayback: true,
        isAntiAlias: true,
        filterQuality: FilterQuality.low,
        errorBuilder: (context, error, stackTrace) {
          print('Erro ao carregar imagem: $imagePath - $error');
          // Fallback para ícone se a imagem não carregar
          return Container(
            color: AppColors.background,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image,
                    size: 60,
                    color: AppColors.primary.withOpacity(0.3),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.desenho.titulo,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
    
    // Fallback para ícone se não encontrar a imagem
    return Container(
      color: AppColors.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              size: 60,
              color: AppColors.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 8),
            Text(
              widget.desenho.titulo,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLocked) {
      // Widget de desbloqueio para desenhos bloqueados
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
        child: DrawingUnlockWidget(
          storyId: widget.desenho.id.replaceAll('desenho_', ''),
          drawingTitle: widget.desenho.titulo,
          onUnlocked: () {
            setState(() {
              _isLocked = false;
            });
          },
        ),
      );
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
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
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: _getDrawingImage(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                widget.desenho.titulo,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

