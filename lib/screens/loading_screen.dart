import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../utils/app_colors.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _colorController;
  late AnimationController _logoController;
  late Animation<double> _colorAnimation;
  late Animation<double> _logoAnimation;
  late Animation<double> _fadeAnimation;

  final List<Color> divineColors = [
    AppColors.primary,     // Azul celestial
    AppColors.secondary,   // Dourado real
    AppColors.accent,      // Roxo real
    AppColors.success,     // Verde esperança
    AppColors.info,        // Azul cristalino
    Color(0xFFFFD700),     // Dourado brilhante
  ];

  @override
  void initState() {
    super.initState();
    
    // Animação das cores (rotação)
    _colorController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _colorAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _colorController, curve: Curves.linear),
    );

    // Animação da logo (pulsação)
    _logoController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _logoAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    // Simular carregamento por 4 segundos
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  void dispose() {
    _colorController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          // Gradiente celestial para loading
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
            // Estrelas de fundo
            Positioned.fill(
              child: CustomPaint(
                painter: LoadingStarsPainter(),
              ),
            ),
            
            // Conteúdo principal
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo animada
                  AnimatedBuilder(
                    animation: _logoAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoAnimation.value,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.4),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    colors: [
                                      Color(0xFFFFD700), // Dourado angelical
                                      Color(0xFFFFA500), // Laranja dourado
                                      Color(0xFFFF8C00), // Dourado escuro
                                    ],
                                    stops: [0.0, 0.5, 1.0],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/icon/logo.png',
                                    width: 160,
                                    height: 160,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.brush,
                                        size: 80,
                                        color: Colors.white,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Paleta de cores animada
                  AnimatedBuilder(
                    animation: _colorAnimation,
                    builder: (context, child) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        constraints: const BoxConstraints(maxWidth: 350),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 15,
                          runSpacing: 15,
                          children: divineColors.asMap().entries.map((entry) {
                            final index = entry.key;
                            final color = entry.value;
                            final rotation = _colorAnimation.value * 2 * math.pi;
                            final delay = index * 0.1;
                            final adjustedRotation = rotation + delay;
                            
                            return Transform.rotate(
                              angle: adjustedRotation * 0.1,
                              child: Transform.scale(
                                scale: 0.8 + 0.2 * math.sin(adjustedRotation),
                                child: _DivineColorBubble(
                                  color: color,
                                  isGlowing: math.sin(adjustedRotation) > 0.5,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Texto de carregamento
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          'Colorindo com Deus',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Carregando...',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Indicador de progresso
                        Container(
                          width: 200,
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          child: AnimatedBuilder(
                            animation: _colorAnimation,
                            builder: (context, child) {
                              return FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: _colorAnimation.value,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.primary,
                                        AppColors.secondary,
                                        AppColors.accent,
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DivineColorBubble extends StatelessWidget {
  final Color color;
  final bool isGlowing;

  const _DivineColorBubble({
    Key? key,
    required this.color,
    required this.isGlowing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.6),
            blurRadius: isGlowing ? 15 : 8,
            spreadRadius: isGlowing ? 2 : 0,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            blurRadius: 5,
            offset: const Offset(-2, -2),
          ),
        ],
      ),
    );
  }
}

// Pintor para estrelas de fundo no loading
class LoadingStarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final starPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final bigStarPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    // Estrelas pequenas
    _drawStar(canvas, starPaint, size.width * 0.2, size.height * 0.15, 3);
    _drawStar(canvas, starPaint, size.width * 0.8, size.height * 0.25, 2);
    _drawStar(canvas, starPaint, size.width * 0.1, size.height * 0.4, 2.5);
    _drawStar(canvas, starPaint, size.width * 0.9, size.height * 0.5, 3);
    _drawStar(canvas, starPaint, size.width * 0.3, size.height * 0.7, 2);
    _drawStar(canvas, starPaint, size.width * 0.7, size.height * 0.8, 2.5);

    // Estrelas maiores
    _drawStar(canvas, bigStarPaint, size.width * 0.15, size.height * 0.1, 5);
    _drawStar(canvas, bigStarPaint, size.width * 0.85, size.height * 0.2, 4);
    _drawStar(canvas, bigStarPaint, size.width * 0.5, size.height * 0.3, 6);
    _drawStar(canvas, bigStarPaint, size.width * 0.25, size.height * 0.6, 4);
    _drawStar(canvas, bigStarPaint, size.width * 0.75, size.height * 0.9, 5);
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
