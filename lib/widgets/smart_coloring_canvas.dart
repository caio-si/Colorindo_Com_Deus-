import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/drawing_provider.dart';
import '../models/desenho.dart';
import '../utils/image_mapping.dart';
import '../utils/paint_modes.dart';

class SmartColoringCanvas extends StatefulWidget {
  const SmartColoringCanvas({super.key});

  @override
  State<SmartColoringCanvas> createState() => _SmartColoringCanvasState();
}

class _SmartColoringCanvasState extends State<SmartColoringCanvas> {
  TransformationController _transformationController = TransformationController();
  
  // Mapa de coordenadas para cada área (baseado na posição da imagem)
  final Map<String, Rect> _areaBounds = {
    'sol': const Rect.fromLTWH(50, 50, 80, 80),
    'nuvem1': const Rect.fromLTWH(150, 80, 60, 60),
    'nuvem2': const Rect.fromLTWH(200, 70, 60, 60),
    'arco_iris': const Rect.fromLTWH(100, 120, 120, 20),
    'arca_corpo': const Rect.fromLTWH(80, 200, 180, 100),
    'arca_cabana': const Rect.fromLTWH(120, 180, 100, 40),
    'janela': const Rect.fromLTWH(140, 190, 20, 20),
    'elefante': const Rect.fromLTWH(90, 210, 40, 60),
    'macaco': const Rect.fromLTWH(130, 200, 30, 40),
    'girafa': const Rect.fromLTWH(160, 190, 20, 50),
    'leao': const Rect.fromLTWH(270, 250, 40, 50),
    'zebra': const Rect.fromLTWH(270, 300, 40, 50),
    'ovelha': const Rect.fromLTWH(270, 350, 40, 40),
    'agua': const Rect.fromLTWH(50, 320, 300, 30),
    'passaro': const Rect.fromLTWH(180, 150, 15, 15),
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

    // Obter o caminho da imagem do desenho
    final historiaId = desenho.id.replaceAll('desenho_', '');
    final imagePath = ImageMapping.getDrawingImagePath(historiaId);

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
              
              // Camada de detecção de toques
              GestureDetector(
                onTapDown: (details) {
                  final renderBox = context.findRenderObject() as RenderBox;
                  final localPosition = renderBox.globalToLocal(details.globalPosition);
                  
                  // Encontrar qual área foi tocada
                  final tappedArea = _findTappedArea(localPosition);
                  if (tappedArea != null) {
                    _handleAreaTap(tappedArea, desenho, drawingProvider);
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.transparent,
                ),
              ),
              
              // Camada de cores aplicadas e área selecionada
              CustomPaint(
                size: Size.infinite,
                painter: SmartColoringPainter(
                  desenho: desenho,
                  selectedAreaId: drawingProvider.selectedAreaId,
                  paintMode: drawingProvider.paintMode,
                  areaBounds: _areaBounds,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _findTappedArea(Offset position) {
    // Encontrar a área que contém a posição tocada
    for (final entry in _areaBounds.entries) {
      if (entry.value.contains(position)) {
        return entry.key;
      }
    }
    return null;
  }

  void _handleAreaTap(String areaName, Desenho desenho, DrawingProvider provider) {
    final areaId = '${desenho.id}_$areaName';
    
    // Verificar se a área existe no desenho
    try {
      final area = desenho.areas.firstWhere((a) => a.id == areaId);
      provider.colorirArea(area.id);
    } catch (e) {
      print('Área não encontrada: $areaId');
    }
  }
}

class SmartColoringPainter extends CustomPainter {
  final Desenho desenho;
  final String? selectedAreaId;
  final PaintMode paintMode;
  final Map<String, Rect> areaBounds;

  SmartColoringPainter({
    required this.desenho,
    this.selectedAreaId,
    required this.paintMode,
    required this.areaBounds,
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
    }

    // Desenhar área selecionada no modo guiado
    if (selectedAreaId != null && paintMode == PaintMode.guided) {
      final areaName = selectedAreaId!.replaceAll(RegExp(r'.*_'), '');
      final bounds = areaBounds[areaName];
      
      if (bounds != null) {
        final highlightPaint = Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.blue
          ..strokeWidth = 3.0;

        canvas.drawRect(bounds, highlightPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant SmartColoringPainter oldDelegate) {
    return selectedAreaId != oldDelegate.selectedAreaId ||
           paintMode != oldDelegate.paintMode;
  }
}
