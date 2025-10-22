import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import '../l10n/app_localizations.dart';
import '../utils/app_colors.dart';
import '../widgets/animated_button.dart';
import '../services/audio_service.dart';
import 'drawings_selection_screen.dart';
import 'stories_screen.dart';
import 'gallery_screen.dart';
import 'settings_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final AudioService _audioService = AudioService();
  bool _hasUserInteracted = false;
  bool _isMusicPlaying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Debug para verificar plataforma
    print('🔍 Plataforma detectada: ${kIsWeb ? "Web" : "Mobile"}');
    
    // No Android, tocar música imediatamente
    // No Web, aguardar interação do usuário
    if (kIsWeb) {
      print('🌐 Executando no Web - aguardando interação do usuário');
      _waitForUserInteraction();
    } else {
      print('📱 Executando no Android - tocando música imediatamente');
      _startStartupMusic();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioService.stopStartupMusic();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (kIsWeb) {
        // No Web, só tocar se usuário já interagiu
        if (_hasUserInteracted) {
          _startStartupMusic();
        }
      } else {
        // No Android, tocar sempre que voltar ao foco
        _startStartupMusic();
      }
    }
  }

  void _waitForUserInteraction() {
    // Aguardar a primeira interação do usuário
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Adicionar listener para detectar primeira interação
      _addInteractionListener();
    });
  }

  void _addInteractionListener() {
    // Detectar primeira interação do usuário
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasUserInteracted) {
        _hasUserInteracted = true;
        _startStartupMusic();
      }
    });
  }

  void _startStartupMusic() {
    if (_isMusicPlaying) {
      print('🎵 Música já está tocando, ignorando...');
      return;
    }
    
    // Aguardar um pouco para garantir que a tela carregou
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!_isMusicPlaying) {
        print('🎵 Iniciando música de início na tela inicial...');
        _isMusicPlaying = true;
        _audioService.playStartupMusic().then((_) {
          print('🎵 Música de início iniciada com sucesso!');
        }).catchError((error) {
          print('❌ Erro ao iniciar música: $error');
          _isMusicPlaying = false;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          // Gradiente celestial (céu divino)
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE3F2FD), // Azul céu claro
              Color(0xFFF3E5F5), // Roxo claro celestial
              Color(0xFFE8F5E8), // Verde claro esperança
              Colors.white, // Branco puro
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Efeito de estrelas/padrão sutil
            Positioned.fill(
              child: CustomPaint(
                painter: CelestialBackgroundPainter(),
              ),
            ),
            
            // Conteúdo principal
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    
                    // Logo e Título
                    _buildHeader(context, l10n),
                
                const SizedBox(height: 60),
                
                // Botões de Navegação
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Botão Começar a Colorir - Azul Celestial
                      AnimatedButton(
                        text: l10n.startColoring,
                        icon: null, // Removido ícone padrão
                        customIcon: 'assets/icon/Paleta.png', // Ícone personalizado
                        color: AppColors.primary,
                        onTap: () {
                          _isMusicPlaying = false;
                          _audioService.stopStartupMusic();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DrawingsSelectionScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      
                      // Botão Histórias Bíblicas - Dourado Real
                      AnimatedButton(
                        text: l10n.stories,
                        icon: null, // Removido ícone padrão
                        customIcon: 'assets/icon/Biblia.png', // Ícone personalizado
                        color: AppColors.secondary,
                        onTap: () {
                          _isMusicPlaying = false;
                          _audioService.stopStartupMusic();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const StoriesScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      
                      // Botão Galeria - Roxo Real
                      AnimatedButton(
                        text: l10n.gallery,
                        icon: Icons.photo_library,
                        color: AppColors.accent,
                        onTap: () {
                          _isMusicPlaying = false;
                          _audioService.stopStartupMusic();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const GalleryScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      
                      Row(
                        children: [
                          // Botão Configurações - Azul Cristalino
                          Expanded(
                            child: AnimatedButton(
                              text: l10n.settings,
                              icon: Icons.settings,
                              color: AppColors.info,
                              onTap: () {
                                _isMusicPlaying = false;
                                _audioService.stopStartupMusic();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SettingsScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Botão Sobre - Verde Esperança
                          Expanded(
                            child: AnimatedButton(
                              text: l10n.about,
                              icon: Icons.info,
                              color: AppColors.success,
                              onTap: () {
                                _isMusicPlaying = false;
                                _audioService.stopStartupMusic();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AboutScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        // Logo personalizada
        Container(
          width: 320,
          height: 320,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 25,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/icon/logo.png',
              width: 320,
              height: 320,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Debug: mostrar erro
                print('Erro ao carregar logo: $error');
                return Container(
                  width: 320,
                  height: 320,
                  color: Colors.red.withOpacity(0.3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 40),
                      Text('Logo não encontrado', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Subtítulo
        Text(
          l10n.homeTitle,
          style: TextStyle(
            fontSize: 20,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// 🎨 Pintor para fundo celestial
class CelestialBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Estrelas pequenas - mais visíveis
    final starPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    // Estrelas maiores - mais brilhantes
    final bigStarPaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    // Estrelas douradas para contraste
    final goldStarPaint = Paint()
      ..color = Color(0xFFFFD700).withOpacity(0.7)
      ..style = PaintingStyle.fill;

    // Estrelas pequenas
    _drawStar(canvas, starPaint, size.width * 0.2, size.height * 0.15, 4);
    _drawStar(canvas, starPaint, size.width * 0.8, size.height * 0.25, 3);
    _drawStar(canvas, starPaint, size.width * 0.1, size.height * 0.4, 3.5);
    _drawStar(canvas, starPaint, size.width * 0.9, size.height * 0.5, 4);
    _drawStar(canvas, starPaint, size.width * 0.3, size.height * 0.7, 3);
    _drawStar(canvas, starPaint, size.width * 0.7, size.height * 0.8, 3.5);

    // Estrelas maiores (mais brilhantes)
    _drawStar(canvas, bigStarPaint, size.width * 0.15, size.height * 0.1, 6);
    _drawStar(canvas, bigStarPaint, size.width * 0.85, size.height * 0.2, 5);
    _drawStar(canvas, bigStarPaint, size.width * 0.5, size.height * 0.3, 7);
    _drawStar(canvas, bigStarPaint, size.width * 0.25, size.height * 0.6, 5);
    _drawStar(canvas, bigStarPaint, size.width * 0.75, size.height * 0.9, 6);

    // Estrelas douradas especiais
    _drawStar(canvas, goldStarPaint, size.width * 0.4, size.height * 0.2, 5);
    _drawStar(canvas, goldStarPaint, size.width * 0.6, size.height * 0.4, 4);
    _drawStar(canvas, goldStarPaint, size.width * 0.2, size.height * 0.8, 4.5);

    // Efeito de brilho suave no centro - mais visível
    final glowPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.3),
      size.width * 0.4,
      glowPaint,
    );
  }

  void _drawStar(Canvas canvas, Paint paint, double x, double y, double size) {
    final path = Path();
    final spikes = 5;
    final outerRadius = size;
    final innerRadius = size * 0.4;

    for (int i = 0; i < spikes * 2; i++) {
      final angle = (i * math.pi) / spikes;
      final radius = i.isEven ? outerRadius : innerRadius;
      final dx = x + radius * math.cos(angle - math.pi / 2);
      final dy = y + radius * math.sin(angle - math.pi / 2);
      
      if (i == 0) {
        path.moveTo(dx, dy);
      } else {
        path.lineTo(dx, dy);
      }
    }
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

