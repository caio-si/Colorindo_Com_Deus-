import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/drawing_provider.dart';
import '../models/desenho.dart';
import '../utils/image_mapping.dart';
import '../utils/paint_modes.dart';

class DrawingCanvas extends StatefulWidget {
  const DrawingCanvas({super.key});

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  TransformationController _transformationController = TransformationController();

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final drawingProvider = Provider.of<DrawingProvider>(context);
    final desenho = drawingProvider.currentDesenho;

    if (desenho == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Obter o caminho da imagem do desenho
    final historiaId = desenho.id.replaceAll('desenho_', '');
    final imagePath = ImageMapping.getDrawingImagePath(historiaId);

    return InteractiveViewer(
      transformationController: _transformationController,
      minScale: 0.5,
      maxScale: 4.0,
      child: Center(
        child: GestureDetector(
          onTapUp: (details) {
            final renderBox = context.findRenderObject() as RenderBox;
            final localPosition = renderBox.globalToLocal(details.globalPosition);
            _handleTap(localPosition, desenho, drawingProvider);
          },
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
              maxHeight: MediaQuery.of(context).size.height - 200,
            ),
            child: Stack(
              children: [
                // Fundo branco para evitar o padrão quadriculado
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: double.infinity,
                ),
                
                // Imagem de fundo do desenho
                if (imagePath != null)
                  Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      print('Erro ao carregar imagem: $imagePath - $error');
                      return Container(
                        color: Colors.white,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image,
                                size: 60,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Imagem não encontrada',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                
                // Camada de colorir (áreas clicáveis)
                CustomPaint(
                  size: Size.infinite,
                  painter: DrawingPainter(
                    desenho: desenho,
                    selectedAreaId: drawingProvider.selectedAreaId,
                    paintMode: drawingProvider.paintMode,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap(Offset position, Desenho desenho, DrawingProvider provider) {
    // Encontrar área tocada
    for (var area in desenho.areas) {
      if (area.bounds.contains(position)) {
        provider.colorirArea(area.id);
        break;
      }
    }
  }
}

class DrawingPainter extends CustomPainter {
  final Desenho desenho;
  final String? selectedAreaId;
  final PaintMode paintMode;

  DrawingPainter({
    required this.desenho,
    this.selectedAreaId,
    required this.paintMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Desenhar cada área
    for (var area in desenho.areas) {
      // Desenhar área colorida (se tiver cor)
      if (area.corPreenchida != null) {
        final paint = Paint()
          ..style = PaintingStyle.fill
          ..color = area.corPreenchida!.withOpacity(0.8); // Cor sólida quando pintada

        canvas.drawPath(area.path, paint);
      }

      // Destacar área selecionada no modo guiado
      if (selectedAreaId == area.id && paintMode == PaintMode.guided) {
        final highlightPaint = Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.blue
          ..strokeWidth = 3.0;

        canvas.drawPath(area.path, highlightPaint);
      }

      // NÃO desenhar bordas das áreas não coloridas para manter a imagem limpa
      // As bordas só aparecem quando a área é selecionada no modo guiado
    }
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) {
    return selectedAreaId != oldDelegate.selectedAreaId ||
           paintMode != oldDelegate.paintMode;
  }
}

