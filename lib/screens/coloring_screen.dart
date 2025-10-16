import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../utils/app_colors.dart';
import '../utils/paint_modes.dart';
import '../models/desenho.dart';
import '../providers/drawing_provider.dart';
import '../widgets/color_palette_widget.dart';
import '../widgets/free_drawing_canvas.dart';
import '../widgets/tool_selector_widget.dart';

class ColoringScreen extends StatefulWidget {
  final Desenho desenho;

  const ColoringScreen({super.key, required this.desenho});

  @override
  State<ColoringScreen> createState() => _ColoringScreenState();
}

class _ColoringScreenState extends State<ColoringScreen> {
  final GlobalKey<FreeDrawingCanvasState> _freeDrawingKey = GlobalKey<FreeDrawingCanvasState>();
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DrawingProvider>(context, listen: false)
          .loadDesenho(widget.desenho);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final drawingProvider = Provider.of<DrawingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.desenho.titulo),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: drawingProvider.canUndo
                ? () => drawingProvider.undo()
                : null,
            tooltip: l10n.undo,
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: drawingProvider.canRedo
                ? () => drawingProvider.redo()
                : null,
            tooltip: l10n.redo,
          ),
                 IconButton(
                   icon: Icon(
                     drawingProvider.isMoveMode ? Icons.brush : Icons.pan_tool,
                     color: drawingProvider.isMoveMode ? AppColors.primary : Colors.white,
                   ),
                   onPressed: () {
                     drawingProvider.toggleMoveMode();
                   },
                   tooltip: drawingProvider.isMoveMode ? 'Modo Pintura' : 'Modo Movimento',
                   style: IconButton.styleFrom(
                     backgroundColor: drawingProvider.isMoveMode ? Colors.white : AppColors.primary,
                   ),
                 ),
                 IconButton(
                   icon: const Icon(Icons.save),
                   onPressed: () async {
                     await drawingProvider.salvarProgresso();
                     if (context.mounted) {
                       ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(
                           content: Text(l10n.save),
                           duration: const Duration(seconds: 2),
                         ),
                       );
                     }
                   },
                   tooltip: l10n.save,
                 ),
                 ElevatedButton.icon(
                   onPressed: () => _finalizarDesenho(context, drawingProvider, l10n),
                   icon: const Icon(Icons.check),
                   label: Text(l10n.finish),
                   style: ElevatedButton.styleFrom(
                     backgroundColor: AppColors.success,
                     foregroundColor: Colors.white,
                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                   ),
                 ),
        ],
      ),
      body: Column(
        children: [
                 // Área de Desenho
                 Expanded(
                   child: Container(
                     color: Colors.white,
                     child: FreeDrawingCanvas(key: _freeDrawingKey),
                   ),
                 ),
          
                 // Barra de informações
                 Container(
                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                   color: AppColors.background,
                   child: Row(
                     children: [
                       Icon(
                         drawingProvider.isMoveMode ? Icons.pan_tool : Icons.brush,
                         color: drawingProvider.isMoveMode ? AppColors.textSecondary : AppColors.primary,
                         size: 20,
                       ),
                       const SizedBox(width: 8),
                       Expanded(
                         child: Text(
                           drawingProvider.isMoveMode 
                             ? 'Modo Movimento - Arraste para mover e use dois dedos para zoom'
                             : 'Modo Pintura - Arraste para pintar',
                           style: TextStyle(
                             color: drawingProvider.isMoveMode ? AppColors.textSecondary : AppColors.primary,
                             fontSize: 12,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                       ),
                       if (drawingProvider.isMoveMode)
                         Icon(Icons.zoom_in, color: AppColors.primary, size: 16),
                     ],
                   ),
                 ),
          
          // Seletor de Ferramentas
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: const ToolSelectorWidget(),
          ),
          
          // Paleta de Cores
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: const ColorPaletteWidget(),
          ),
        ],
      ),
    );
  }

  Future<void> _finalizarDesenho(
    BuildContext context,
    DrawingProvider provider,
    AppLocalizations l10n,
  ) async {
    await provider.finalizarDesenho();
    
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.star, color: AppColors.goldMedal, size: 32),
              const SizedBox(width: 8),
              Text(l10n.congratulations),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.drawingCompleted),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '"Tudo posso naquele que me fortalece."\nFilipenses 4:13',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    // Não podemos acessar context após o widget ser desmontado
    // O provider será limpo quando apropriado
    super.dispose();
  }
}

