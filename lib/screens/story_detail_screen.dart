import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../utils/app_colors.dart';
import '../utils/audio_mapping.dart';
import '../data/desenhos_data.dart';
import '../models/historia.dart';
import '../providers/settings_provider.dart';
import '../services/audio_service.dart';
import 'coloring_screen.dart';

class StoryDetailScreen extends StatefulWidget {
  final Historia historia;

  const StoryDetailScreen({super.key, required this.historia});

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  bool _isPlaying = false;
  final AudioService _audioService = AudioService();

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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.historia.titulo),
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Botão de áudio
          IconButton(
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: _toggleNarration,
            tooltip: _isPlaying ? 'Pausar narração' : 'Reproduzir narração',
          ),
        ],
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagem completa da história
              Container(
                width: double.infinity,
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: widget.historia.imagemPath.isNotEmpty
                      ? Image.asset(
                          widget.historia.imagemPath,
                          width: double.infinity,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 200,
                              color: AppColors.secondary.withOpacity(0.1),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.menu_book,
                                      size: 60,
                                      color: AppColors.secondary.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Imagem não encontrada',
                                      style: TextStyle(
                                        color: AppColors.secondary.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          height: 200,
                          color: AppColors.secondary.withOpacity(0.1),
                          child: Center(
                            child: Icon(
                              Icons.menu_book,
                              size: 60,
                              color: AppColors.secondary.withOpacity(0.5),
                            ),
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Card com informações da história
              Container(
                width: double.infinity,
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
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título
                      Text(
                        widget.historia.titulo,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Referência bíblica
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.historia.referenciaBiblica,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Descrição completa
                      Text(
                        widget.historia.descricaoCompleta ?? widget.historia.descricao,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Botões de ação
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
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
                              },
                              icon: const Icon(Icons.palette),
                              label: Text(l10n.colorThisStory),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.secondary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(width: 12),
                          
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _toggleNarration,
                              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                              label: Text(_isPlaying ? 'Pausar' : 'Ouvir'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.secondary,
                                side: BorderSide(color: AppColors.secondary),
                                padding: const EdgeInsets.symmetric(vertical: 14),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
