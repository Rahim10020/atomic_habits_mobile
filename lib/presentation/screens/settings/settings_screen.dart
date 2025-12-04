import 'package:atomic_habits_mobile/application/providers/habit_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../application/providers/data_manager_provider.dart';
import '../../../application/providers/theme_mode_provider.dart';

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

          _buildSection('Apprendre'),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('Guide Atomic Habits'),
            subtitle: const Text('Comprendre les concepts du livre'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/guide'),
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
        content: RadioGroup<ThemeMode>(
          groupValue: ref.read(themeModeProvider),
          onChanged: (value) {
            ref.read(themeModeProvider.notifier).state = value!;
            Navigator.pop(context);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              RadioListTile<ThemeMode>(
                title: Text('Clair'),
                value: ThemeMode.light,
              ),
              RadioListTile<ThemeMode>(
                title: Text('Sombre'),
                value: ThemeMode.dark,
              ),
              RadioListTile<ThemeMode>(
                title: Text('Automatique'),
                value: ThemeMode.system,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLoadSampleDataDialog(BuildContext context, WidgetRef ref) {
    final parentContext = context;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Charger les exemples'),
        content: const Text(
          'Voulez-vous ajouter 8 habitudes de démonstration à votre liste ? '
          'Cela n\'effacera pas vos habitudes existantes.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              if (!parentContext.mounted) return;

              final messenger = ScaffoldMessenger.of(parentContext);
              try {
                final dataManager = ref.read(dataManagerProvider.notifier);
                await dataManager.loadSampleData();
                ref
                  ..invalidate(habitsProvider)
                  ..invalidate(dashboardStatsProvider)
                  ..invalidate(completionTrendProvider(7))
                  ..invalidate(completionTrendProvider(30));
                messenger.showSnackBar(
                  SnackBar(
                    content: const Text('Habitudes d\'exemple chargées !'),
                    backgroundColor: AppColors.success,
                  ),
                );
              } catch (error) {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text('Échec du chargement : $error'),
                    backgroundColor: AppColors.error,
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
      builder: (dialogContext) => AlertDialog(
        title: const Text('Réinitialiser les données'),
        content: const Text(
          'Cette action va supprimer TOUTES vos habitudes actuelles et les remplacer '
          'par les habitudes d\'exemple. Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);

              // Montrer un indicateur de chargement
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) =>
                    const Center(child: CircularProgressIndicator()),
              );

              try {
                final dataManager = ref.read(dataManagerProvider.notifier);
                await dataManager.resetToSampleData();

                // Invalidate all providers to refresh the app state
                ref
                  ..invalidate(habitsProvider)
                  ..invalidate(dashboardStatsProvider)
                  ..invalidate(completionTrendProvider(7))
                  ..invalidate(completionTrendProvider(30));

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
              } catch (error) {
                if (context.mounted) {
                  Navigator.pop(context); // Fermer le loading
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Erreur lors de la réinitialisation: $error',
                      ),
                      backgroundColor: AppColors.error,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
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
      builder: (dialogContext) => AlertDialog(
        title: const Text('Supprimer toutes les données'),
        content: const Text(
          'Cette action va supprimer DÉFINITIVEMENT toutes vos habitudes et '
          'votre historique. Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);

              // Montrer un indicateur de chargement
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) =>
                    const Center(child: CircularProgressIndicator()),
              );

              try {
                final dataManager = ref.read(dataManagerProvider.notifier);
                await dataManager.clearAllData();
                ref.invalidate(firstLaunchProvider);

                // Invalidate all providers to refresh the app state
                ref
                  ..invalidate(habitsProvider)
                  ..invalidate(dashboardStatsProvider)
                  ..invalidate(completionTrendProvider(7))
                  ..invalidate(completionTrendProvider(30));

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
              } catch (error) {
                if (context.mounted) {
                  Navigator.pop(context); // Fermer le loading
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur lors de la suppression: $error'),
                      backgroundColor: AppColors.error,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
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
