import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../utils/app_colors.dart';
import '../utils/audio_mapping.dart';
import '../data/historias_data.dart';
import '../data/desenhos_data.dart';
import '../models/historia.dart';
import '../providers/settings_provider.dart';
import '../services/audio_service.dart';
import '../services/ad_service.dart';
import '../widgets/story_unlock_widget.dart';
import '../widgets/interstitial_ad_service.dart';
import 'coloring_screen.dart';
import 'story_detail_screen.dart';

class StoriesScreen extends StatelessWidget {
  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final historias = HistoriasData.obterHistorias(l10n);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.biblicalStories),
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.secondary.withOpacity(0.1),
              AppColors.background,
            ],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: historias.length,
          itemBuilder: (context, index) {
            return _StoryCard(historia: historias[index]);
          },
        ),
      ),
    );
  }
}

class _StoryCard extends StatefulWidget {
  final Historia historia;

  const _StoryCard({required this.historia});

  @override
  State<_StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<_StoryCard> {
  bool _isPlaying = false;
  bool _isLocked = false;
  final AudioService _audioService = AudioService();

  @override
  void initState() {
    super.initState();
    _checkLockStatus();
  }

  Future<void> _checkLockStatus() async {
    final isLocked = await AdService.isStoryLocked(widget.historia.id);
    if (mounted) {
      setState(() {
        _isLocked = isLocked;
      });
    }
  }

  Future<void> _toggleNarration() async {
    if (!Provider.of<SettingsProvider>(context, listen: false).narrationEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Narração desabilitada nas configurações'),
          backgroundColor: AppColors.secondary,
        ),
      );
      return;
    }

    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      // Para qualquer narração que esteja tocando
      await _audioService.stopNarration();
      
      // Toca a narração da história atual
      final audioPath = AudioMapping.getAudioPath(widget.historia.id);
      if (audioPath != null) {
        await _audioService.playNarration(audioPath);
      }
    } else {
      await _audioService.stopNarration();
    }
  }

  @override
  void dispose() {
    _audioService.stopNarration();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Widget de desbloqueio se estiver bloqueada
          if (_isLocked) ...[
            StoryUnlockWidget(
              storyId: widget.historia.id,
              storyTitle: widget.historia.titulo,
              onUnlocked: () {
                setState(() {
                  _isLocked = false;
                });
              },
            ),
          ] else ...[
          // Imagem de capa
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: widget.historia.imagemPath.isNotEmpty
                  ? Image.asset(
                      widget.historia.imagemPath,
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback para ícone se a imagem não carregar
                        return Center(
                          child: Icon(
                            Icons.menu_book,
                            size: 60,
                            color: AppColors.secondary.withOpacity(0.5),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Icon(
                        Icons.menu_book,
                        size: 60,
                        color: AppColors.secondary.withOpacity(0.5),
                      ),
                    ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título com ícone de áudio
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.historia.titulo,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Ícone de áudio
                    GestureDetector(
                      onTap: _toggleNarration,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _isPlaying 
                            ? AppColors.secondary 
                            : AppColors.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: _isPlaying 
                            ? Colors.white 
                            : AppColors.secondary,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Referência bíblica
                Text(
                  widget.historia.referenciaBiblica,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Descrição
                Text(
                  widget.historia.descricao,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Botões de ação
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          // Incrementar contador de intersticial
                          AdService.incrementInterstitialCounter();
                          
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => StoryDetailScreen(historia: widget.historia),
                            ),
                          );
                          
                          // Mostrar intersticial se necessário
                          await InterstitialAdService.showAdIfNeeded();
                        },
                        icon: const Icon(Icons.visibility),
                        label: const Text('Ver História'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.secondary,
                          side: BorderSide(color: AppColors.secondary),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          // Incrementar contador de intersticial
                          AdService.incrementInterstitialCounter();
                          
                          final desenho = DesenhosData.obterDesenhoPorId(
                            widget.historia.desenhoId,
                          );
                          if (desenho != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ColoringScreen(desenho: desenho),
                              ),
                            );
                          }
                          
                          // Mostrar intersticial se necessário
                          await InterstitialAdService.showAdIfNeeded();
                        },
                        icon: const Icon(Icons.palette),
                        label: Text(l10n.colorThisStory),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ],
        ],
      ),
    );
  }
}

