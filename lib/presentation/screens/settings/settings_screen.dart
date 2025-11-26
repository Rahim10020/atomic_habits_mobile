import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../application/providers/data_manager_provider.dart';

// Theme mode provider
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        children: [
          _buildSection('Apparence'),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Thème'),
            subtitle: Text(_getThemeModeText(themeMode)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemeDialog(context, ref),
          ),
          const Divider(),

          _buildSection('Données'),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Charger les habitudes d\'exemple'),
            subtitle: const Text('Ajouter 8 habitudes de démonstration'),
            onTap: () => _showLoadSampleDataDialog(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.refresh),
            title: const Text('Réinitialiser avec les exemples'),
            subtitle: const Text(
              'Supprimer toutes les données et charger les exemples',
            ),
            onTap: () => _showResetDataDialog(context, ref),
          ),
          ListTile(
            leading: Icon(Icons.delete_forever, color: AppColors.error),
            title: Text(
              'Supprimer toutes les données',
              style: TextStyle(color: AppColors.error),
            ),
            subtitle: const Text('Action irréversible'),
            onTap: () => _showDeleteAllDataDialog(context, ref),
          ),
          const Divider(),

          _buildSection('À propos'),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Version'),
            subtitle: Text(AppConstants.appVersion),
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Basé sur "Atomic Habits"'),
            subtitle: const Text('de James Clear'),
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('Développé avec Flutter'),
            subtitle: const Text('Architecture Clean + Riverpod'),
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '💡 Conseil: Pour de meilleurs résultats, concentrez-vous sur 2-3 habitudes à la fois.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondaryLight,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: AppTextStyles.titleMedium.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Clair';
      case ThemeMode.dark:
        return 'Sombre';
      case ThemeMode.system:
        return 'Automatique';
    }
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir un thème'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Clair'),
              value: ThemeMode.light,
              groupValue: ref.read(themeModeProvider),
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).state = value!;
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Sombre'),
              value: ThemeMode.dark,
              groupValue: ref.read(themeModeProvider),
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).state = value!;
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Automatique'),
              value: ThemeMode.system,
              groupValue: ref.read(themeModeProvider),
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).state = value!;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLoadSampleDataDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Charger les exemples'),
        content: const Text(
          'Voulez-vous ajouter 8 habitudes de démonstration à votre liste ? '
          'Cela n\'effacera pas vos habitudes existantes.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              final dataManager = ref.read(dataManagerProvider.notifier);
              await dataManager.loadSampleData();

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Habitudes d\'exemple chargées!'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Charger'),
          ),
        ],
      ),
    );
  }

  void _showResetDataDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Réinitialiser les données'),
        content: const Text(
          'Cette action va supprimer TOUTES vos habitudes actuelles et les remplacer '
          'par les habitudes d\'exemple. Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              // Montrer un indicateur de chargement
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) =>
                    const Center(child: CircularProgressIndicator()),
              );

              final dataManager = ref.read(dataManagerProvider.notifier);
              await dataManager.resetToSampleData();

              if (context.mounted) {
                Navigator.pop(context); // Fermer le loading
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Données réinitialisées!'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.warning),
            child: const Text('Réinitialiser'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllDataDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer toutes les données'),
        content: const Text(
          'Cette action va supprimer DÉFINITIVEMENT toutes vos habitudes et '
          'votre historique. Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              // Montrer un indicateur de chargement
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) =>
                    const Center(child: CircularProgressIndicator()),
              );

              final dataManager = ref.read(dataManagerProvider.notifier);
              await dataManager.clearAllData();

              if (context.mounted) {
                Navigator.pop(context); // Fermer le loading
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Toutes les données ont été supprimées',
                    ),
                    backgroundColor: AppColors.error,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Supprimer tout'),
          ),
        ],
      ),
    );
  }
}
