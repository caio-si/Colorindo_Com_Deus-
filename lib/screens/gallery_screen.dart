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

class _GalleryScreenState extends State<GalleryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GalleryProvider>(context, listen: false).carregarGaleria();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final galleryProvider = Provider.of<GalleryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myGallery),
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.finishedDrawings),
            Tab(text: l10n.inProgress),
          ],
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.accent.withOpacity(0.1),
              AppColors.background,
            ],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildGalleryGrid(
              context,
              galleryProvider.desenhosFinalizados,
              l10n,
            ),
            _buildGalleryGrid(
              context,
              galleryProvider.desenhosEmProgresso,
              l10n,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGalleryGrid(
    BuildContext context,
    List<ProgressoUsuario> desenhos,
    AppLocalizations l10n,
  ) {
    if (desenhos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 80,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noDrawings,
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.startColoringNow,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: desenhos.length,
      itemBuilder: (context, index) {
        return _GalleryItem(
          progresso: desenhos[index],
        );
      },
    );
  }
}

class _GalleryItem extends StatelessWidget {
  final ProgressoUsuario progresso;

  const _GalleryItem({required this.progresso});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final galleryProvider = Provider.of<GalleryProvider>(context, listen: false);

    return GestureDetector(
      onTap: () => _showOptions(context, l10n, galleryProvider),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: _buildDrawingPreview(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    progresso.desenhoId,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(progresso.dataModificacao),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildDrawingPreview() {
    // Debug: verificar se há linhas de desenho
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
      orElse: () => throw Exception('Desenho não encontrado'),
    );
    
    // Navegar para a tela de colorir
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ColoringScreen(desenho: desenho),
      ),
    );
  }

  void _showOptions(
    BuildContext context,
    AppLocalizations l10n,
    GalleryProvider galleryProvider,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share),
              title: Text(l10n.share),
              onTap: () {
                Navigator.pop(context);
                // Implementar compartilhamento
              },
            ),
            ListTile(
              leading: const Icon(Icons.palette),
              title: Text(l10n.recolor),
              onTap: () {
                Navigator.pop(context);
                _recolorirDesenho(context, progresso);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
              onTap: () async {
                await galleryProvider.excluirDesenho(progresso.id);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
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
    double maxX = -double.infinity;
    double minY = double.infinity;
    double maxY = -double.infinity;

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
      print('DEBUG: No valid positions found');
      return;
    }

    // Calcular dimensões do desenho
    final drawingWidth = maxX - minX;
    final drawingHeight = maxY - minY;
    
    print('DEBUG: Drawing dimensions - width: $drawingWidth, height: $drawingHeight');
    
    if (drawingWidth <= 0 || drawingHeight <= 0) {
      print('DEBUG: Invalid drawing dimensions');
      return;
    }

    // Calcular escala para ajustar ao tamanho da prévia
    final scaleX = (size.width - 32) / drawingWidth; // 32px de padding
    final scaleY = (size.height - 32) / drawingHeight;
    final scale = (scaleX < scaleY ? scaleX : scaleY) * 0.9; // 90% do tamanho disponível

    print('DEBUG: Scale - scaleX: $scaleX, scaleY: $scaleY, final scale: $scale');

    // Calcular offset para centralizar
    final offsetX = (size.width - drawingWidth * scale) / 2;
    final offsetY = (size.height - drawingHeight * scale) / 2;

    print('DEBUG: Offset - offsetX: $offsetX, offsetY: $offsetY');

    // Aplicar transformações
    canvas.save();
    canvas.translate(offsetX - minX * scale, offsetY - minY * scale);
    canvas.scale(scale);

    // Desenhar cada linha
    for (int lineIndex = 0; lineIndex < drawingLines.lines.length; lineIndex++) {
      final line = drawingLines.lines[lineIndex];
      if (line.isEmpty) continue;

      print('DEBUG: Drawing line $lineIndex with ${line.length} points');

      final paint = Paint()
        ..color = line.first.color ?? Colors.black
        ..strokeWidth = (line.first.brushSize ?? 8.0) * 0.5 / scale // Ajustar tamanho baseado na escala
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      // Desenhar pontos conectados
      for (int i = 0; i < line.length - 1; i++) {
        final current = line[i];
        final next = line[i + 1];
        
        if (current.position != null && next.position != null) {
          canvas.drawLine(
            current.position!,
            next.position!,
            paint,
          );
        }
      }
    }

    canvas.restore();
    print('DEBUG: Finished drawing');
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is _DrawingPreviewPainter && 
           oldDelegate.drawingLines != drawingLines;
  }
}

