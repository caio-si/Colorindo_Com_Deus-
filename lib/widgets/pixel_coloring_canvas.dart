import 'package:flutter/material.dart';
import 'package:image_pixels/image_pixels.dart';
import 'package:provider/provider.dart';
import '../providers/drawing_provider.dart';
import '../models/desenho.dart';
import '../utils/image_mapping.dart';
import '../utils/paint_modes.dart';

class PixelColoringCanvas extends StatefulWidget {
  const PixelColoringCanvas({super.key});

  @override
  State<PixelColoringCanvas> createState() => _PixelColoringCanvasState();
}

class _PixelColoringCanvasState extends State<PixelColoringCanvas> {
  TransformationController _transformationController = TransformationController();
  int? _selectedAreaIndex; // Índice da área selecionada
  
  // Mapa de cores SIMPLIFICADO - UMA COR PARA TODAS AS ÁREAS
  // Agora você só precisa pintar cada área distinta com a mesma cor!
  final Map<Color, String> _colorAreaMap = {
    const Color(0xFF00FF00): 'area_colorivel', // Verde para TODAS as áreas coloríveis
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

    return Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height - 200,
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) {
              print('Toque detectado - modo sem máscara');
              _handleAreaColorir('area_colorivel', desenho, drawingProvider);
            },
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
                  InteractiveViewer(
                    transformationController: _transformationController,
                    minScale: 0.5,
                    maxScale: 4.0,
                    panEnabled: true,
                    scaleEnabled: true,
                    child: Image.asset(
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
                  ),
                
                // Camada de detecção de cores usando image_pixels
                if (maskPath != null)
                  Positioned.fill(
                    child: ImagePixels(
                      imageProvider: AssetImage(maskPath),
                      builder: (context, img) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapDown: (details) {
                            final renderBox = context.findRenderObject() as RenderBox;
                            final localPosition = renderBox.globalToLocal(details.globalPosition);
                            
                            print('=== DETECÇÃO DE TOQUE ===');
                            print('Posição: (${localPosition.dx}, ${localPosition.dy})');
                            print('Tamanho da máscara: ${img.width} x ${img.height}');
                            
                            // Verificar se o toque está dentro dos limites da imagem
                            if (localPosition.dx < 0 || localPosition.dx >= img.width ||
                                localPosition.dy < 0 || localPosition.dy >= img.height) {
                              print('Toque fora dos limites da máscara');
                              return;
                            }
                            
                            // Converter para int e verificar se img.pixelColorAt não é null
                            if (img.pixelColorAt != null) {
                              final x = localPosition.dx.round();
                              final y = localPosition.dy.round();
                              
                              final pixelColor = img.pixelColorAt!(x, y);
                              
                              if (pixelColor != null) {
                                print('Cor do pixel em ($x, $y): 0x${pixelColor.value.toRadixString(16).padLeft(8, '0')}');
                                print('RGB: R=${pixelColor.red}, G=${pixelColor.green}, B=${pixelColor.blue}');
                                
                                // Encontrar a área correspondente à cor
                                final areaName = _findAreaByColor(pixelColor);
                                print('Área encontrada: $areaName');
                                
                                if (areaName != null) {
                                  _handleAreaColorir(areaName, desenho, drawingProvider);
                                } else {
                                  print('Área não reconhecida - cor não mapeada');
                                  print('Cor esperada: 0x${const Color(0xFF00FF00).value.toRadixString(16)}');
                                }
                              } else {
                                print('pixelColor é null');
                              }
                            } else {
                              print('img.pixelColorAt é null');
                            }
                            print('========================');
                          },
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.transparent,
                          ),
                        );
                      },
                    ),
                  ),
                
                // Camada de cores aplicadas
                CustomPaint(
                  size: Size.infinite,
                  painter: PixelColoringPainter(
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
    // Mapeamento específico para máscaras
    final maskMapping = {
      '2': 'assets/images/masks/Arca de Noe_Mask.png', // Arca de Noé
      // Adicione outros desenhos conforme você criar as máscaras
    };
    
    final maskPath = maskMapping[historiaId];
    print('Máscara para história $historiaId: $maskPath');
    return maskPath;
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

  bool _colorsAreSimilar(Color color1, Color color2, {int tolerance = 30}) {
    final rDiff = (color1.red - color2.red).abs();
    final gDiff = (color1.green - color2.green).abs();
    final bDiff = (color1.blue - color2.blue).abs();
    
    // Para verde puro (#00FF00), ser mais estrito
    if (color2.value == 0xFF00FF00) {
      return rDiff <= tolerance && gDiff <= tolerance && bDiff <= tolerance;
    }
    
    return rDiff <= tolerance && gDiff <= tolerance && bDiff <= tolerance;
  }

  void _handleAreaColorir(String areaName, Desenho desenho, DrawingProvider provider) {
    print('_handleAreaColorir chamado para: $areaName');
    
    // Se a máscara detectou uma área colorível (verde)
    if (areaName == 'area_colorivel') {
      // No modo guiado, precisamos de uma área selecionada primeiro
      if (provider.paintMode == PaintMode.guided) {
        if (provider.selectedAreaId != null) {
          print('Colorindo área selecionada: ${provider.selectedAreaId}');
          provider.colorirAreaSelecionada();
        } else {
          // Se não há área selecionada, mostrar menu
          print('Nenhuma área selecionada, mostrando menu');
          _showAreaSelectionMenu(desenho, provider);
        }
      } else {
        // Modo livre - mostrar menu para escolher qual área colorir
        print('Modo livre - mostrando menu de áreas');
        _showAreaSelectionMenu(desenho, provider);
      }
    }
  }
  
  void _showAreaSelectionMenu(Desenho desenho, DrawingProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecione uma área para colorir'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: desenho.areas.length,
            itemBuilder: (context, index) {
              final area = desenho.areas[index];
              final areaName = area.id.replaceAll('${desenho.id}_', '');
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text('${index + 1}'),
                ),
                title: Text(areaName),
                subtitle: Text('Área ${index + 1}'),
                trailing: area.corPreenchida != null
                    ? Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedAreaIndex = index;
                  });
                  print('Área selecionada: ${area.id}');
                  provider.colorirArea(area.id);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }
}

class PixelColoringPainter extends CustomPainter {
  final Desenho desenho;
  final String? selectedAreaId;
  final PaintMode paintMode;

  PixelColoringPainter({
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
  bool shouldRepaint(covariant PixelColoringPainter oldDelegate) {
    return selectedAreaId != oldDelegate.selectedAreaId ||
           paintMode != oldDelegate.paintMode;
  }
}
