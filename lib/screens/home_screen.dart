import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../utils/app_colors.dart';
import '../widgets/animated_button.dart';
import 'drawings_selection_screen.dart';
import 'stories_screen.dart';
import 'gallery_screen.dart';
import 'settings_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),
                
                // Logo e Título
                _buildHeader(context, l10n),
                
                const SizedBox(height: 60),
                
                // Botões de Navegação
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      AnimatedButton(
                        text: l10n.startColoring,
                        icon: Icons.palette,
                        color: AppColors.primary,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DrawingsSelectionScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      
                      AnimatedButton(
                        text: l10n.stories,
                        icon: Icons.menu_book,
                        color: AppColors.secondary,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const StoriesScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      
                      AnimatedButton(
                        text: l10n.gallery,
                        icon: Icons.photo_library,
                        color: AppColors.accent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const GalleryScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      
                      Row(
                        children: [
                          Expanded(
                            child: AnimatedButton(
                              text: l10n.settings,
                              icon: Icons.settings,
                              color: AppColors.info,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SettingsScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AnimatedButton(
                              text: l10n.about,
                              icon: Icons.info,
                              color: AppColors.success,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AboutScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        // Logo personalizada
        Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'icon/logo.png',
              width: 280,
              height: 280,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback caso a imagem não carregue
                return Icon(
                  Icons.brush,
                  size: 60,
                  color: AppColors.primary,
                );
              },
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Subtítulo
        Text(
          l10n.homeTitle,
          style: TextStyle(
            fontSize: 20,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

