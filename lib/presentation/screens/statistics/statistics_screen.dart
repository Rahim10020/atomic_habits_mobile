import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../application/providers/habit_provider.dart';
import '../../../domain/models/habit.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  String _selectedPeriod = '7 jours';
  final List<String> _periods = ['7 jours', '30 jours', '90 jours', '1 an'];

  int _periodToDays(String period) {
    switch (period) {
      case '7 jours':
        return 7;
      case '30 jours':
        return 30;
      case '90 jours':
        return 90;
      case '1 an':
        return 365;
      default:
        return 7;
    }
  }

  @override
  Widget build(BuildContext context) {
    final habitsAsync = ref.watch(habitsProvider);
    final statsAsync = ref.watch(dashboardStatsProvider);
    final completionsAsync = ref.watch(
      completionTrendProvider(_periodToDays(_selectedPeriod)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _selectedPeriod = value;
              });
            },
            itemBuilder: (context) => _periods
                .map(
                  (period) => PopupMenuItem(value: period, child: Text(period)),
                )
                .toList(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            ref.refresh(habitsProvider.future),
            ref.refresh(dashboardStatsProvider.future),
            ref.refresh(
              completionTrendProvider(_periodToDays(_selectedPeriod)).future,
            ),
          ]);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Global stats
              statsAsync.when(
                data: (stats) => _buildGlobalStats(stats),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: AppConstants.paddingLarge),

              // Habits breakdown
              habitsAsync.when(
                data: (habits) {
                  if (habits.isEmpty) {
                    return _buildEmptyState();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCompletionChart(habits),
                      const SizedBox(height: AppConstants.paddingLarge),
                      _buildCategoryBreakdown(habits),
                      const SizedBox(height: AppConstants.paddingLarge),
                      _buildStreakLeaderboard(habits),
                      const SizedBox(height: AppConstants.paddingLarge),
                      completionsAsync.when(
                        data: (completions) =>
                            _buildWeeklyProgress(habits, completions),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlobalStats(DashboardStats stats) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Column(
        children: [
          Text(
            'Vue d\'ensemble',
            style: AppTextStyles.headlineMedium.copyWith(color: Colors.white),
          ),
          const SizedBox(height: AppConstants.paddingLarge),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildGlobalStatItem(
                icon: Icons.check_circle,
                label: 'Complétées',
                value: '${stats.completedCount}',
              ),
              _buildGlobalStatItem(
                icon: Icons.pending,
                label: 'En attente',
                value: '${stats.pendingCount}',
              ),
              _buildGlobalStatItem(
                icon: Icons.trending_up,
                label: 'Taux',
                value: '${stats.completionRate.toInt()}%',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlobalStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.headlineLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletionChart(List<Habit> habits) {
    final totalHabits = habits.length;
    final habitsByCategory = <String, int>{};

    for (var habit in habits) {
      habitsByCategory[habit.category] =
          (habitsByCategory[habit.category] ?? 0) + 1;
    }

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Répartition par catégorie', style: AppTextStyles.headlineSmall),
          const SizedBox(height: AppConstants.paddingLarge),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 60,
                sections: habitsByCategory.entries.map((entry) {
                  final percentage = (entry.value / totalHabits) * 100;
                  final color =
                      AppColors.categoryColors[entry.key] ?? AppColors.primary;
                  return PieChartSectionData(
                    value: entry.value.toDouble(),
                    title: '${percentage.toInt()}%',
                    color: color,
                    radius: 50,
                    titleStyle: AppTextStyles.labelMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: habitsByCategory.entries.map((entry) {
              final color =
                  AppColors.categoryColors[entry.key] ?? AppColors.primary;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${entry.key} (${entry.value})',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdown(List<Habit> habits) {
    final habitsByCategory = <String, List<Habit>>{};

    for (var habit in habits) {
      if (!habitsByCategory.containsKey(habit.category)) {
        habitsByCategory[habit.category] = [];
      }
      habitsByCategory[habit.category]!.add(habit);
    }

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Détails par catégorie', style: AppTextStyles.headlineSmall),
          const SizedBox(height: AppConstants.paddingMedium),
          ...habitsByCategory.entries.map((entry) {
            final color =
                AppColors.categoryColors[entry.key] ?? AppColors.primary;
            final totalCompletions = entry.value.fold<int>(
              0,
              (sum, habit) => sum + habit.totalCompletions,
            );
            final avgStreak = entry.value.isEmpty
                ? 0
                : (entry.value.fold<int>(
                            0,
                            (sum, habit) => sum + habit.currentStreak,
                          ) /
                          entry.value.length)
                      .round();

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(entry.key, style: AppTextStyles.titleMedium),
                      const Spacer(),
                      Text(
                        '${entry.value.length} habitude${entry.value.length > 1 ? 's' : ''}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSmallStatCard(
                          label: 'Total',
                          value: '$totalCompletions',
                          icon: Icons.check_circle,
                          color: color,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildSmallStatCard(
                          label: 'Série moy.',
                          value: avgStreak.toInt().toString(),
                          icon: Icons.local_fire_department,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSmallStatCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTextStyles.titleMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStreakLeaderboard(List<Habit> habits) {
    final sortedHabits = List<Habit>.from(habits)
      ..sort((a, b) => b.currentStreak.compareTo(a.currentStreak));
    final top5 = sortedHabits.take(5).toList();

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events, color: AppColors.accent),
              const SizedBox(width: 8),
              Text('Top 5 séries', style: AppTextStyles.headlineSmall),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          ...top5.asMap().entries.map((entry) {
            final index = entry.key;
            final habit = entry.value;
            final color =
                AppColors.categoryColors[habit.category] ?? AppColors.primary;
            final medals = ['🥇', '🥈', '🥉', '4️⃣', '5️⃣'];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: index == 0
                      ? AppColors.accent.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: index == 0
                        ? AppColors.accent.withValues(alpha: 0.3)
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                ),
                child: Row(
                  children: [
                    Text(medals[index], style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Container(
                      width: 4,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            habit.name,
                            style: AppTextStyles.titleSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            habit.category,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.local_fire_department,
                              size: 16,
                              color: AppColors.error,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${habit.currentStreak}',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'jours',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildWeeklyProgress(
    List<Habit> habits,
    Map<DateTime, int> completions,
  ) {
    final days = completions.keys.toList()..sort();
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progrès - $_selectedPeriod',
            style: AppTextStyles.headlineSmall,
          ),
          const SizedBox(height: AppConstants.paddingLarge),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                maxY: habits.length.toDouble(),
                barGroups: List.generate(days.length, (index) {
                  final day = days[index];
                  final completedCount = completions[day] ?? 0;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: completedCount.toDouble(),
                        color: AppColors.primary,
                        width: 16,
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart_rounded,
              size: 64,
              color: AppColors.textSecondaryLight.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Text(
              'Aucune statistique',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              'Créez des habitudes pour voir vos statistiques',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
