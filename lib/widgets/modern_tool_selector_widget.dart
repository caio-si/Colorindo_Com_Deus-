import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/painting_tools.dart';
import '../providers/drawing_provider.dart';
import '../utils/app_colors.dart';

class ModernToolSelectorWidget extends StatefulWidget {
  const ModernToolSelectorWidget({Key? key}) : super(key: key);

  @override
  State<ModernToolSelectorWidget> createState() => _ModernToolSelectorWidgetState();
}

class _ModernToolSelectorWidgetState extends State<ModernToolSelectorWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    
    // Animação de pulsação
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Animação de brilho
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    _shimmerAnimation = Tween<double>(begin: -1, end: 1).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawingProvider>(
      builder: (context, drawingProvider, child) {
        return Container(
          constraints: BoxConstraints(
            minHeight: drawingProvider.selectedTool == PaintingTool.eraser ? 200 : 120,
            maxHeight: drawingProvider.selectedTool == PaintingTool.eraser ? 250 : 150,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
              const BoxShadow(
                color: Colors.white,
                offset: Offset(-2, -2),
                blurRadius: 8,
              ),
            ],
            border: Border.all(
              color: AppColors.primary.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                // Título da seção
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.brush,
                          color: AppColors.primary,
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Ferramentas',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Grid de ferramentas
                Expanded(
                  child: Row(
                    children: PaintingTool.values.map((tool) {
                      final isSelected = drawingProvider.selectedTool == tool;
                      return Expanded(
                        child: _ModernToolButton(
                          tool: tool,
                          isSelected: isSelected,
                          pulseAnimation: _pulseAnimation,
                          shimmerAnimation: _shimmerAnimation,
                          onTap: () => drawingProvider.setSelectedTool(tool),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                
                // Slider para tamanho da borracha (apenas quando selecionada)
                if (drawingProvider.selectedTool == PaintingTool.eraser)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.linear_scale,
                              color: AppColors.primary,
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Tamanho da Borracha',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor: AppColors.primary.withOpacity(0.3),
                            thumbColor: AppColors.primary,
                            overlayColor: AppColors.primary.withOpacity(0.2),
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                            trackHeight: 3,
                          ),
                          child: Slider(
                            value: drawingProvider.eraserSize,
                            min: 5.0,
                            max: 30.0,
                            divisions: 10,
                            onChanged: (value) {
                              drawingProvider.setEraserSize(value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }
}

class _ModernToolButton extends StatelessWidget {
  final PaintingTool tool;
  final bool isSelected;
  final Animation<double> pulseAnimation;
  final Animation<double> shimmerAnimation;
  final VoidCallback onTap;

  const _ModernToolButton({
    Key? key,
    required this.tool,
    required this.isSelected,
    required this.pulseAnimation,
    required this.shimmerAnimation,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([pulseAnimation, shimmerAnimation]),
      builder: (context, child) {
        return GestureDetector(
          onTap: onTap,
          child: Transform.scale(
            scale: isSelected ? pulseAnimation.value : 1.0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.transparent, // Fundo transparente
                borderRadius: BorderRadius.circular(15),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ] : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ícone da ferramenta
                  _buildAssetToolIcon(tool, isSelected),
                  
                  const SizedBox(height: 4),
                  
                  // Nome da ferramenta
                  Text(
                    tool.displayName,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomToolIcon(PaintingTool tool, Color color, double size, bool isSelected) {
    switch (tool) {
      case PaintingTool.thinBrush:
        return _buildModernBrushIcon(color, size, 2, isSelected);
      case PaintingTool.mediumBrush:
        return _buildModernBrushIcon(color, size, 4, isSelected);
      case PaintingTool.thickBrush:
        return _buildModernBrushIcon(color, size, 6, isSelected);
      case PaintingTool.eraser:
        return _buildModernEraserIcon(color, size, isSelected);
    }
  }

  Widget _buildModernBrushIcon(Color color, double size, double brushWidth, bool isSelected) {
    return CustomPaint(
      size: Size(size, size),
      painter: ModernBrushPainter(
        color: color,
        brushWidth: brushWidth,
        isSelected: isSelected,
      ),
    );
  }

  Widget _buildModernEraserIcon(Color color, double size, bool isSelected) {
    return CustomPaint(
      size: Size(size, size),
      painter: ModernEraserPainter(
        color: color,
        isSelected: isSelected,
      ),
    );
  }

  Widget _buildAssetToolIcon(PaintingTool tool, bool isSelected) {
    String assetPath;
    
    switch (tool) {
      case PaintingTool.thinBrush:
      case PaintingTool.mediumBrush:
      case PaintingTool.thickBrush:
        assetPath = 'assets/icon/Pincel.png';
        break;
      case PaintingTool.eraser:
        assetPath = 'assets/icon/Borracha.png';
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      transform: Matrix4.identity()
        ..translate(0.0, isSelected ? -8.0 : 0.0), // Animação de "subido"
      child: Container(
        width: tool.isEraser ? 32 : 40, // Ícones maiores para melhor visibilidade
        height: tool.isEraser ? 32 : 40,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(assetPath),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

// 🎨 Pintor para ícone de pincel moderno
class ModernBrushPainter extends CustomPainter {
  final Color color;
  final double brushWidth;
  final bool isSelected;

  ModernBrushPainter({
    required this.color,
    required this.brushWidth,
    required this.isSelected,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = brushWidth
      ..strokeCap = StrokeCap.round;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Desenhar o cabo do pincel (linha diagonal)
    final handleStart = Offset(centerX - size.width * 0.3, centerY + size.height * 0.3);
    final handleEnd = Offset(centerX + size.width * 0.3, centerY - size.height * 0.3);
    
    canvas.drawLine(handleStart, handleEnd, paint);

    // Desenhar a ponta do pincel (círculo)
    final tipRadius = brushWidth * 0.8;
    canvas.drawCircle(
      Offset(centerX + size.width * 0.25, centerY - size.height * 0.25),
      tipRadius,
      paint,
    );

    // Desenhar as cerdas do pincel (linhas pequenas)
    if (isSelected) {
      final bristlePaint = Paint()
        ..color = color.withOpacity(0.7)
        ..strokeWidth = 1
        ..strokeCap = StrokeCap.round;

      for (int i = 0; i < 3; i++) {
        final bristleStart = Offset(
          centerX + size.width * 0.25 - tipRadius + (i * tipRadius),
          centerY - size.height * 0.25 - tipRadius,
        );
        final bristleEnd = Offset(
          centerX + size.width * 0.25 - tipRadius + (i * tipRadius),
          centerY - size.height * 0.25 - tipRadius - 2,
        );
        canvas.drawLine(bristleStart, bristleEnd, bristlePaint);
      }
    }

    // Desenhar um ponto de brilho se selecionado
    if (isSelected) {
      final highlightPaint = Paint()
        ..color = Colors.white.withOpacity(0.8)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(centerX + size.width * 0.2, centerY - size.height * 0.2),
        brushWidth * 0.3,
        highlightPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 🧽 Pintor para ícone de borracha moderno
class ModernEraserPainter extends CustomPainter {
  final Color color;
  final bool isSelected;

  ModernEraserPainter({
    required this.color,
    required this.isSelected,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Desenhar o corpo da borracha (retângulo arredondado)
    final eraserRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: size.width * 0.6,
        height: size.height * 0.4,
      ),
      const Radius.circular(2),
    );
    canvas.drawRRect(eraserRect, paint);

    // Desenhar a borda da borracha
    final borderPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRRect(eraserRect, borderPaint);

    // Desenhar linhas de "limpeza" se selecionado
    if (isSelected) {
      final cleanPaint = Paint()
        ..color = Colors.white.withOpacity(0.6)
        ..strokeWidth = 1
        ..strokeCap = StrokeCap.round;

      for (int i = 0; i < 2; i++) {
        final lineStart = Offset(
          centerX - size.width * 0.2,
          centerY - size.height * 0.1 + (i * size.height * 0.1),
        );
        final lineEnd = Offset(
          centerX + size.width * 0.2,
          centerY - size.height * 0.1 + (i * size.height * 0.1),
        );
        canvas.drawLine(lineStart, lineEnd, cleanPaint);
      }
    }

    // Desenhar um ponto de brilho se selecionado
    if (isSelected) {
      final highlightPaint = Paint()
        ..color = Colors.white.withOpacity(0.8)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(centerX - size.width * 0.15, centerY - size.height * 0.1),
        size.width * 0.08,
        highlightPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
