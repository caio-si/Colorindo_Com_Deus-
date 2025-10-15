import 'package:flutter/material.dart';
import 'package:flutter_image_pixels/flutter_image_pixels.dart';
import 'package:provider/provider.dart';
import '../providers/drawing_provider.dart';
import '../models/desenho.dart';
import '../utils/image_mapping.dart';
import '../utils/paint_modes.dart';

class ColorMapCanvas extends StatefulWidget {
  const ColorMapCanvas({super.key});

  @override
  State<ColorMapCanvas> createState() => _ColorMapCanvasState();
}

class _ColorMapCanvasState extends State<ColorMapCanvas> {
  TransformationController _transformationController = TransformationController();
  
  // Mapa de cores para cada área (você precisará criar essas imagens)
  final Map<Color, String> _colorAreaMap = {
    const Color(0xFFFF0000): 'sol',        // Vermelho para o sol
    const Color(0xFF0000FF): 'nuvem1',     // Azul para nuvem 1
    const Color(0xFF00FF00): 'nuvem2',     // Verde para nuvem 2
    const Color(0xFFFFFF00): 'arco_iris',  // Amarelo para arco-íris
    const Color(0xFFFF00FF): 'arca_corpo', // Magenta para corpo da arca
    const Color(0xFF00FFFF): 'arca_cabana', // Ciano para cabana da arca
    const Color(0xFF800080): 'janela',     // Roxo para janela
    const Color(0xFF800000): 'elefante',   // Marrom escuro para elefante
    const Color(0xFF808000): 'macaco',     // Verde oliva para macaco
    const Color(0xFF008080): 'girafa',     // Verde azulado para girafa
    const Color(0xFF800080): 'leao',       // Roxo escuro para leão
    const Color(0xFF000080): 'zebra',      // Azul escuro para zebra
    const Color(0xFF808080): 'ovelha',     // Cinza para ovelha
    const Color(0xFF000000): 'agua',       // Preto para água
    const Color(0xFFC0C0C0): 'passaro',    // Prata para pássaro
  };

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

    // Obter o caminho da imagem do desenho e do mapa de cores
    final historiaId = desenho.id.replaceAll('desenho_', '');
    final imagePath = ImageMapping.getDrawingImagePath(historiaId);
    final maskPath = _getMaskPath(historiaId);

    return InteractiveViewer(
      transformationController: _transformationController,
      minScale: 0.5,
      maxScale: 4.0,
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height - 200,
          ),
          child: Stack(
            children: [
              // Fundo branco
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
              
              // Camada de detecção de cores
              if (maskPath != null)
                FlutterImagePixels(
                  imageProvider: AssetImage(maskPath),
                  builder: (context, img) {
                    return GestureDetector(
                      onTapDown: (details) {
                        final renderBox = context.findRenderObject() as RenderBox;
                        final localPosition = renderBox.globalToLocal(details.globalPosition);
                        
                        // Obter a cor do pixel tocado
                        final pixelColor = img.pixelColorAt(
                          localPosition.dx, 
                          localPosition.dy
                        );
                        
                        if (pixelColor != null) {
                          // Encontrar a área correspondente à cor
                          final areaName = _findAreaByColor(pixelColor);
                          if (areaName != null) {
                            _handleAreaTap(areaName, desenho, drawingProvider);
                          }
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        // Container invisível para capturar toques
                        color: Colors.transparent,
                      ),
                    );
                  },
                ),
              
              // Camada de cores aplicadas
              CustomPaint(
                size: Size.infinite,
                painter: ColorOverlayPainter(
                  desenho: desenho,
                  selectedAreaId: drawingProvider.selectedAreaId,
                  paintMode: drawingProvider.paintMode,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _getMaskPath(String historiaId) {
    // Retorna o caminho para a imagem de mapa de cores
    // Por enquanto, vamos usar a mesma imagem, mas você deve criar as imagens de máscara
    return ImageMapping.getDrawingImagePath(historiaId);
  }

  String? _findAreaByColor(Color pixelColor) {
    // Encontrar a área correspondente à cor do pixel
    // Tolerância para pequenas variações de cor
    for (final entry in _colorAreaMap.entries) {
      if (_colorsAreSimilar(pixelColor, entry.key)) {
        return entry.value;
      }
    }
    return null;
  }

  bool _colorsAreSimilar(Color color1, Color color2, {double tolerance = 50}) {
    final rDiff = (color1.red - color2.red).abs();
    final gDiff = (color1.green - color2.green).abs();
    final bDiff = (color1.blue - color2.blue).abs();
    
    return rDiff <= tolerance && gDiff <= tolerance && bDiff <= tolerance;
  }

  void _handleAreaTap(String areaName, Desenho desenho, DrawingProvider provider) {
    final areaId = '${desenho.id}_$areaName';
    
    // Verificar se a área existe no desenho
    final area = desenho.areas.firstWhere(
      (a) => a.id == areaId,
      orElse: () => throw StateError('Área não encontrada: $areaId'),
    );
    
    provider.colorirArea(area.id);
  }
}

class ColorOverlayPainter extends CustomPainter {
  final Desenho desenho;
  final String? selectedAreaId;
  final PaintMode paintMode;

  ColorOverlayPainter({
    required this.desenho,
    this.selectedAreaId,
    required this.paintMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Desenhar áreas coloridas
    for (var area in desenho.areas) {
      if (area.corPreenchida != null) {
        final paint = Paint()
          ..style = PaintingStyle.fill
          ..color = area.corPreenchida!.withOpacity(0.8);

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
    }
  }

  @override
  bool shouldRepaint(covariant ColorOverlayPainter oldDelegate) {
    return selectedAreaId != oldDelegate.selectedAreaId ||
           paintMode != oldDelegate.paintMode;
  }
}
