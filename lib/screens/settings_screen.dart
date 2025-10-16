import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../utils/app_colors.dart';
import '../providers/settings_provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        backgroundColor: AppColors.info,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.info.withOpacity(0.1),
              AppColors.background,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSection(
              context,
              l10n.language,
              [
                _buildLanguageTile(
                  context,
                  'Português',
                  const Locale('pt', 'BR'),
                  settingsProvider,
                ),
                _buildLanguageTile(
                  context,
                  'English',
                  const Locale('en', 'US'),
                  settingsProvider,
                ),
                _buildLanguageTile(
                  context,
                  'Español',
                  const Locale('es', 'ES'),
                  settingsProvider,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            _buildSection(
              context,
              'Áudio',
              [
                SwitchListTile(
                  title: Text(l10n.sounds),
                  subtitle: const Text('Efeitos sonoros ao pintar'),
                  value: settingsProvider.soundsEnabled,
                  onChanged: (_) => settingsProvider.toggleSounds(),
                  activeColor: AppColors.primary,
                ),
                SwitchListTile(
                  title: Text(l10n.narration),
                  subtitle: const Text('Narração das histórias'),
                  value: settingsProvider.narrationEnabled,
                  onChanged: (_) => settingsProvider.toggleNarration(),
                  activeColor: AppColors.primary,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            _buildSection(
              context,
              'Aparência',
              [
                SwitchListTile(
                  title: Text(l10n.darkMode),
                  subtitle: const Text('Tema escuro'),
                  value: themeProvider.themeMode == ThemeMode.dark,
                  onChanged: (_) => themeProvider.toggleTheme(),
                  activeColor: AppColors.primary,
                ),
              ],
            ),
            
            
            const SizedBox(height: 24),
            
            _buildSection(
              context,
              'Armazenamento',
              [
                ListTile(
                  title: Text(l10n.clearStorage),
                  subtitle: const Text('Apagar todos os desenhos salvos'),
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  onTap: () => _showClearStorageDialog(context, settingsProvider, l10n),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _buildLanguageTile(
    BuildContext context,
    String title,
    Locale locale,
    SettingsProvider provider,
  ) {
    final isSelected = provider.currentLocale.languageCode == locale.languageCode;
    
    return ListTile(
      title: Text(title),
      trailing: isSelected ? const Icon(Icons.check, color: AppColors.primary) : null,
      onTap: () => provider.setLocale(locale),
    );
  }


  void _showClearStorageDialog(
    BuildContext context,
    SettingsProvider provider,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearStorage),
        content: const Text(
          'Tem certeza que deseja apagar todos os desenhos salvos? Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await provider.clearStorage();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Armazenamento limpo com sucesso'),
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Apagar'),
          ),
        ],
      ),
    );
  }
}

