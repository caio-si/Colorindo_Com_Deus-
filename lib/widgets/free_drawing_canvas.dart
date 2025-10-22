import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/drawing_provider.dart';
import '../models/desenho.dart';
import '../utils/image_mapping.dart';
import '../utils/painting_tools.dart';

class FreeDrawingCanvas extends StatefulWidget {
  const FreeDrawingCanvas({super.key});

  @override
  State<FreeDrawingCanvas> createState() => FreeDrawingCanvasState();
}

class FreeDrawingCanvasState extends State<FreeDrawingCanvas> {
  final TransformationController transformationController = TransformationController();
  
  // Para controle de undo/redo
  List<DrawingPoint> _currentLine = [];
  bool _isDrawing = false;
  
  @override
  void initState() {
    super.initState();
    // Inicializar com zoom menor e centralizado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final screenSize = MediaQuery.of(context).size;
        final scale = 0.4; // Zoom menor para ver toda a imagem
        
        // Centralizar a imagem
        transformationController.value = Matrix4.identity()..scale(scale);
      }
    });
  }
  
  @override
  void dispose() {
    transformationController.dispose();
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

    final historiaId = desenho.id.replaceAll('desenho_', '');
    final imagePath = ImageMapping.getDrawingImagePath(historiaId);

    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.98,
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
               child: Listener(
                 behavior: HitTestBehavior.opaque,
                 onPointerDown: (details) {
                   // Se está no modo movimento, não pinta
                   if (drawingProvider.isMoveMode) return;
                   
                   _isDrawing = true;
                   
                   // Converte coordenadas do InteractiveViewer para coordenadas da imagem
                   final transformedPosition = transformationController.toScene(details.localPosition);
                   
                   // Inicia uma nova linha
                   _currentLine = [
                     DrawingPoint(
                       position: transformedPosition,
                       color: drawingProvider.selectedTool.isEraser 
                         ? Colors.transparent 
                         : drawingProvider.selectedColor,
                       tool: drawingProvider.selectedTool,
                       brushSize: drawingProvider.selectedTool == PaintingTool.eraser 
                           ? drawingProvider.eraserSize 
                           : drawingProvider.selectedTool.brushSize,
                     ),
                   ];
                   
                   // Força atualização imediata
                   setState(() {});
                 },
                 onPointerMove: (details) {
                   // Se está no modo movimento, não pinta
                   if (drawingProvider.isMoveMode || !_isDrawing) return;
                   
                   // Converte coordenadas do InteractiveViewer para coordenadas da imagem
                   final transformedPosition = transformationController.toScene(details.localPosition);
                   
                   // Adiciona ponto à linha atual
                   final newPoint = DrawingPoint(
                     position: transformedPosition,
                     color: drawingProvider.selectedTool.isEraser 
                       ? Colors.transparent 
                       : drawingProvider.selectedColor,
                     tool: drawingProvider.selectedTool,
                     brushSize: drawingProvider.selectedTool == PaintingTool.eraser 
                         ? drawingProvider.eraserSize 
                         : drawingProvider.selectedTool.brushSize,
                   );
                   _currentLine.add(newPoint);
                   
                   // Força atualização imediata
                   setState(() {});
                 },
                 onPointerUp: (details) {
                   _isDrawing = false;
                   
                   // Finaliza a linha atual e salva no provider para undo/redo
                   if (_currentLine.isNotEmpty) {
                     drawingProvider.addDrawingLine(_currentLine);
                     _currentLine = []; // Limpa a linha atual
                   }
                   
                   setState(() {});
                 },
                 child: InteractiveViewer(
                   transformationController: transformationController,
                   panEnabled: drawingProvider.isMoveMode, // Só permite pan no modo movimento
                   scaleEnabled: drawingProvider.isMoveMode, // Só permite zoom no modo movimento
                   minScale: 0.3, // Zoom menor para ver toda a imagem
                   maxScale: 3.0,
                   boundaryMargin: EdgeInsets.all(20),
                   constrained: false,
                   child: Stack(
                     children: [
                       // Imagem de fundo
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
                       
                       // Camada de desenho livre
                       Positioned.fill(
                         child: CustomPaint(
                           painter: FreeDrawingPainter(
                             currentLine: _currentLine,
                             providerLines: drawingProvider.drawingLines,
                           ),
                         ),
                       ),
                     ],
                   ),
                 ),
               ),
      ),
    );
  }
}

class DrawingPoint {
  final Offset? position;
  final Color? color;
  final PaintingTool tool;
  final double brushSize;

  DrawingPoint({
    this.position, 
    this.color, 
    this.tool = PaintingTool.mediumBrush,
    this.brushSize = 8.0,
  });
}

class FreeDrawingPainter extends CustomPainter {
  final List<DrawingPoint> currentLine;
  final List<List<DrawingPoint>> providerLines;

  FreeDrawingPainter({required this.currentLine, required this.providerLines});

  @override
  void paint(Canvas canvas, Size size) {
    // Verificar se há pontos de borracha para otimizar performance
    final hasEraser = providerLines.any((line) => line.any((p) => p.tool.isEraser)) ||
                      currentLine.any((p) => p.tool.isEraser);

    // ⚠️ Cria uma camada para permitir BlendMode.clear no Android
    if (hasEraser) {
      canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
    }

    // Desenhar todas as linhas do provider (salvas e undo/redo)
    for (final line in providerLines) {
      _drawLine(canvas, line);
    }
    
    // Desenhar linha atual (linha sendo desenhada no momento)
    if (currentLine.isNotEmpty) {
      _drawLine(canvas, currentLine);
    }

    // Finaliza a layer se foi criada
    if (hasEraser) {
      canvas.restore();
    }
  }

  void _drawLine(Canvas canvas, List<DrawingPoint> points) {
    if (points.isEmpty) return;
    
    // Criar objetos Paint reutilizáveis para melhor performance
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final eraserPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..blendMode = BlendMode.clear; // Borracha
    
    for (int i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];

      if (current.position == null || next.position == null) continue;

      if (current.tool.isEraser) {
        eraserPaint
          ..strokeWidth = current.brushSize
          ..color = Colors.transparent;

        // Borracha — desenha linha + círculo para cobertura
        canvas.drawLine(current.position!, next.position!, eraserPaint);
        canvas.drawCircle(current.position!, current.brushSize / 2, eraserPaint);
      } else {
        paint
          ..color = current.color ?? Colors.black
          ..strokeWidth = current.brushSize;

        canvas.drawLine(current.position!, next.position!, paint);
      }
    }

    // Garante o último ponto da borracha
    if (points.last.tool.isEraser && points.last.position != null) {
      eraserPaint
        ..strokeWidth = points.last.brushSize
        ..color = Colors.transparent;
      canvas.drawCircle(points.last.position!, points.last.brushSize / 2, eraserPaint);
    }
  }

  @override
  bool shouldRepaint(covariant FreeDrawingPainter oldDelegate) {
    // Sempre repinta para garantir renderização imediata
    return true;
  }
}

