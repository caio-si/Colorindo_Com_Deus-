import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../utils/app_colors.dart';
import '../providers/gallery_provider.dart';
import '../models/progresso_usuario.dart';
import '../models/drawing_lines.dart';
import '../data/desenhos_data.dart';
import '../utils/image_mapping.dart';
import '../widgets/free_drawing_canvas.dart';
import '../utils/painting_tools.dart';
import 'coloring_screen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.myGallery,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: l10n.finishedDrawings),
            Tab(text: l10n.inProgress),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFinishedDrawingsTab(),
          _buildInProgressTab(),
        ],
      ),
    );
  }

  Widget _buildFinishedDrawingsTab() {
    return Consumer<GalleryProvider>(
      builder: (context, galleryProvider, child) {
        final finishedDrawings = galleryProvider.getFinishedDrawings();
        
        if (finishedDrawings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 80,
                  color: AppColors.accent.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context).noFinishedDrawings,
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return _buildDrawingsGrid(finishedDrawings, isFinished: true);
      },
    );
  }

  Widget _buildInProgressTab() {
    return Consumer<GalleryProvider>(
      builder: (context, galleryProvider, child) {
        final inProgressDrawings = galleryProvider.getInProgressDrawings();
        
        if (inProgressDrawings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.brush_outlined,
                  size: 80,
                  color: AppColors.accent.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context).noInProgressDrawings,
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return _buildDrawingsGrid(inProgressDrawings, isFinished: false);
      },
    );
  }

  Widget _buildDrawingsGrid(List<ProgressoUsuario> drawings, {required bool isFinished}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: drawings.length,
        itemBuilder: (context, index) {
          final progresso = drawings[index];
          return _buildDrawingCard(progresso, isFinished);
        },
      ),
    );
  }

  Widget _buildDrawingCard(ProgressoUsuario progresso, bool isFinished) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Preview do desenho
          Expanded(
            flex: 3,
            child: _buildDrawingPreview(progresso),
          ),
          
          // Informações do desenho
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    progresso.desenhoId,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(progresso.dataModificacao),
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Botões de ação
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _recolorirDesenho(context, progresso),
                    icon: const Icon(Icons.brush, size: 16),
                    label: Text(
                      AppLocalizations.of(context).recolor,
                      style: const TextStyle(fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (!isFinished)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _finalizarDesenho(context, progresso),
                      icon: const Icon(Icons.check, size: 16),
                      label: Text(
                        AppLocalizations.of(context).finish,
                        style: const TextStyle(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawingPreview(ProgressoUsuario progresso) {
    print('DEBUG: progresso.drawingLines: ${progresso.drawingLines}');
    if (progresso.drawingLines != null) {
      print('DEBUG: drawingLines.lines.length: ${progresso.drawingLines!.lines.length}');
      if (progresso.drawingLines!.lines.isNotEmpty) {
        print('DEBUG: Primeira linha tem ${progresso.drawingLines!.lines.first.length} pontos');
      }
    }
    
    // Buscar o desenho base
    final desenhos = DesenhosData.obterDesenhos();
    final desenho = desenhos.firstWhere(
      (d) => d.id == progresso.desenhoId,
      orElse: () => desenhos.first,
    );
    
    // Obter o caminho correto da imagem usando o historiaId
    final imagePath = ImageMapping.getDrawingImagePath(desenho.historiaId) ?? desenho.imagemPath;
    
    // Se há linhas de desenho livre, mostrar a prévia com imagem base
    if (progresso.drawingLines != null && progresso.drawingLines!.lines.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Imagem base do desenho
              Positioned.fill(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.image,
                        color: Colors.grey[400],
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
              // Rabiscos sobrepostos
              Positioned.fill(
                child: CustomPaint(
                  painter: _DrawingPreviewPainter(progresso.drawingLines!),
                  size: Size.infinite,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    // Se não há linhas de desenho, mostrar apenas a imagem base
    return Container(
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Icon(
                Icons.image,
                size: 60,
                color: AppColors.accent.withOpacity(0.3),
              ),
            );
          },
        ),
      ),
    );
  }

  void _recolorirDesenho(BuildContext context, ProgressoUsuario progresso) async {
    // Buscar o desenho correspondente
    final desenhos = DesenhosData.obterDesenhos();
    final desenho = desenhos.firstWhere(
      (d) => d.id == progresso.desenhoId,
      orElse: () => desenhos.first,
    );

    // Navegar para a tela de colorir com o progresso carregado
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ColoringScreen(
          desenho: desenho,
          progressoExistente: progresso,
        ),
      ),
    );
  }

  void _finalizarDesenho(BuildContext context, ProgressoUsuario progresso) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).finishDrawing),
        content: Text(AppLocalizations.of(context).finishDrawingConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () {
              // Marcar como finalizado
              final galleryProvider = Provider.of<GalleryProvider>(context, listen: false);
              galleryProvider.finalizarDesenho(progresso.id);
              
              Navigator.pop(context);
              
              // Mostrar confirmação
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context).drawingFinished),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            child: Text(AppLocalizations.of(context).finish),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _DrawingPreviewPainter extends CustomPainter {
  final DrawingLines drawingLines;

  _DrawingPreviewPainter(this.drawingLines);

  @override
  void paint(Canvas canvas, Size size) {
    print('DEBUG: _DrawingPreviewPainter.paint - size: $size');
    print('DEBUG: drawingLines.lines.length: ${drawingLines.lines.length}');
    
    if (drawingLines.lines.isEmpty) {
      print('DEBUG: No lines to draw');
      return;
    }

    // Calcular os limites do desenho
    double minX = double.infinity;
    double maxX = double.negativeInfinity;
    double minY = double.infinity;
    double maxY = double.negativeInfinity;

    for (final line in drawingLines.lines) {
      for (final point in line) {
        if (point.position != null) {
          minX = minX < point.position!.dx ? minX : point.position!.dx;
          maxX = maxX > point.position!.dx ? maxX : point.position!.dx;
          minY = minY < point.position!.dy ? minY : point.position!.dy;
          maxY = maxY > point.position!.dy ? maxY : point.position!.dy;
        }
      }
    }

    print('DEBUG: Bounds - minX: $minX, maxX: $maxX, minY: $minY, maxY: $maxY');

    if (minX == double.infinity) {
      print('DEBUG: No valid points found');
      return;
    }

    final drawingWidth = maxX - minX;
    final drawingHeight = maxY - minY;
    print('DEBUG: Drawing dimensions - width: $drawingWidth, height: $drawingHeight');

    if (drawingWidth <= 0 || drawingHeight <= 0) {
      print('DEBUG: Invalid drawing dimensions');
      return;
    }

    // Calcular escala para caber no preview
    final scaleX = (size.width - 32) / drawingWidth; // 32px de padding
    final scaleY = (size.height - 32) / drawingHeight;
    final scale = (scaleX < scaleY ? scaleX : scaleY) * 0.9; // 90% do tamanho disponível

    print('DEBUG: Scale - scaleX: $scaleX, scaleY: $scaleY, final scale: $scale');

    // Calcular offset para centralizar
    final offsetX = (size.width - drawingWidth * scale) / 2;
    final offsetY = (size.height - drawingHeight * scale) / 2;

    print('DEBUG: Offset - offsetX: $offsetX, offsetY: $offsetY');

    canvas.save();
    canvas.translate(offsetX - minX * scale, offsetY - minY * scale);
    canvas.scale(scale);

    // Desenhar as linhas
    for (int lineIndex = 0; lineIndex < drawingLines.lines.length; lineIndex++) {
      final line = drawingLines.lines[lineIndex];
      if (line.isEmpty) continue;

      print('DEBUG: Drawing line $lineIndex with ${line.length} points');

      final paint = Paint()
        ..color = line.first.color ?? Colors.black
        ..strokeWidth = (line.first.brushSize ?? 8.0) * 0.5 / scale // Ajustar tamanho baseado na escala
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      for (int i = 0; i < line.length - 1; i++) {
        final current = line[i];
        final next = line[i + 1];
        if (current.position != null && next.position != null) {
          canvas.drawLine(current.position!, next.position!, paint);
        }
      }
    }

    canvas.restore();
    print('DEBUG: Finished drawing');
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}




