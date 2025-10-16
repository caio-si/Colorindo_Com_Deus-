import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../utils/app_colors.dart';
import '../providers/gallery_provider.dart';
import '../models/progresso_usuario.dart';
import '../data/desenhos_data.dart';
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
                child: Center(
                  child: Icon(
                    Icons.image,
                    size: 60,
                    color: AppColors.accent.withOpacity(0.3),
                  ),
                ),
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

