import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../application/providers/habit_provider.dart';
import '../../../domain/models/habit.dart';
import '../../widgets/common/habit_calendar.dart';

class HabitDetailScreen extends ConsumerWidget {
  final int habitId;

  const HabitDetailScreen({super.key, required this.habitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitAsync = ref.watch(habitProvider(habitId));
    final statsAsync = ref.watch(habitStatisticsProvider(habitId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de l\'habitude'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/edit-habit/$habitId'),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showDeleteDialog(context, ref),
          ),
        ],
      ),
      body: habitAsync.when(
        data: (Habit? habit) {
          if (habit == null) {
            return const Center(child: Text('Habitude introuvable'));
          }

          final categoryColor =
              AppColors.categoryColors[habit.category] ?? AppColors.primary;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                Container(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        categoryColor,
                        categoryColor.withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadius,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit.name,
                        style: AppTextStyles.displaySmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      if (habit.description != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          habit.description!,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                      const SizedBox(height: AppConstants.paddingMedium),

                      Row(
                        children: [
                          _buildStatChip(
                            icon: Icons.local_fire_department_rounded,
                            label: '${habit.currentStreak} jours',
                            subtitle: 'Série actuelle',
                          ),
                          const SizedBox(width: 12),
                          _buildStatChip(
                            icon: Icons.emoji_events_rounded,
                            label: '${habit.longestStreak} jours',
                            subtitle: 'Meilleure série',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.paddingLarge),

                // Stats Section
                statsAsync.when(
                  data: (stats) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Statistiques', style: AppTextStyles.headlineSmall),
                      const SizedBox(height: AppConstants.paddingMedium),

                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              title: 'Total',
                              value: '${stats.totalCompletions}',
                              icon: Icons.check_circle,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              title: 'Taux',
                              value: '${stats.completionRate.toInt()}%',
                              icon: Icons.trending_up,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.paddingLarge),

                      Text('Calendrier', style: AppTextStyles.headlineSmall),
                      const SizedBox(height: AppConstants.paddingMedium),

                      HabitCalendar(
                        completionHistory: stats.completionHistory,
                        color: categoryColor,
                      ),
                    ],
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(height: AppConstants.paddingLarge),

                // Identity Statement
                if (habit.identityStatement != null)
                  _buildSection(
                    title: 'Identité',
                    icon: Icons.person,
                    color: AppColors.primary,
                    content: habit.identityStatement!,
                  ),

                // Two Minute Version
                if (habit.twoMinuteVersion != null)
                  _buildSection(
                    title: 'Version 2 minutes',
                    icon: Icons.bolt,
                    color: AppColors.accent,
                    content: habit.twoMinuteVersion!,
                  ),

                // Four Laws
                const SizedBox(height: AppConstants.paddingMedium),
                Text('Les 4 Lois', style: AppTextStyles.headlineSmall),
                const SizedBox(height: AppConstants.paddingMedium),

                if (habit.cue != null)
                  _buildLawCard(
                    title: 'Rendre évident',
                    content: habit.cue!,
                    icon: Icons.visibility,
                    color: AppColors.primary,
                  ),

                if (habit.craving != null)
                  _buildLawCard(
                    title: 'Rendre attrayant',
                    content: habit.craving!,
                    icon: Icons.favorite,
                    color: AppColors.accent,
                  ),

                if (habit.response != null)
                  _buildLawCard(
                    title: 'Rendre facile',
                    content: habit.response!,
                    icon: Icons.speed,
                    color: AppColors.secondary,
                  ),

                if (habit.reward != null)
                  _buildLawCard(
                    title: 'Rendre satisfaisant',
                    content: habit.reward!,
                    icon: Icons.star,
                    color: AppColors.success,
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erreur: $error')),
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required String subtitle,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.headlineLarge.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelMedium.copyWith(color: color),
                  ),
                  const SizedBox(height: 4),
                  Text(content, style: AppTextStyles.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLawCard({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(content, style: AppTextStyles.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    final parentContext = context;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Supprimer l\'habitude'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer cette habitude ? Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              try {
                final controller = ref.read(habitControllerProvider.notifier);
                await controller.deleteHabit(habitId);

                // Invalidate all relevant providers to ensure full refresh
                ref
                  ..invalidate(habitsProvider)
                  ..invalidate(dashboardStatsProvider)
                  ..invalidate(habitLogsProvider(habitId))
                  ..invalidate(todayCompletionProvider(habitId))
                  ..invalidate(completionTrendProvider(7))
                  ..invalidate(completionTrendProvider(30));

                if (parentContext.mounted) {
                  Navigator.pop(dialogContext);
                  parentContext.pop();
                }
              } catch (error) {
                // Handle any unexpected errors
                if (parentContext.mounted) {
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(parentContext).showSnackBar(
                    SnackBar(
                      content: Text('Erreur lors de la suppression: $error'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
