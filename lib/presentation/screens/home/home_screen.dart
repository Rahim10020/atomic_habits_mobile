import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../application/providers/habit_provider.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../widgets/common/habit_card.dart';
import 'widgets/daily_summary.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Timer? _quoteTimer;
  int _quoteIndex = 0;

  @override
  void initState() {
    super.initState();
    _quoteIndex = DateTime.now().minute % AppConstants.quotes.length;
    _startQuoteTimer();
  }

  void _startQuoteTimer() {
    _quoteTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        _quoteIndex = (_quoteIndex + 1) % AppConstants.quotes.length;
      });
    });
  }

  @override
  void dispose() {
    _quoteTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final habitsAsync = ref.watch(habitsProvider);
    final dashboardStatsAsync = ref.watch(dashboardStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('EEEE', 'fr_FR').format(DateTime.now()),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
            Text(
              DateFormat('d MMMM yyyy', 'fr_FR').format(DateTime.now()),
              style: AppTextStyles.headlineMedium,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            onPressed: () => context.push('/statistics'),
            tooltip: 'Statistiques',
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => context.push('/settings'),
            tooltip: 'Paramètres',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            ref.refresh(habitsProvider.future),
            ref.refresh(dashboardStatsProvider.future),
          ]);
        },
        child: CustomScrollView(
          slivers: [
            // Daily Summary
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: dashboardStatsAsync.when(
                  data: (stats) => DailySummary(stats: stats),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => const SizedBox.shrink(),
                ),
              ),
            ),

            // Motivational Quote
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                  vertical: AppConstants.paddingSmall,
                ),
                child: _buildQuoteCard(),
              ),
            ),

            // Section Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppConstants.paddingMedium,
                  AppConstants.paddingLarge,
                  AppConstants.paddingMedium,
                  AppConstants.paddingSmall,
                ),
                child: Text(
                  'Mes habitudes',
                  style: AppTextStyles.headlineMedium,
                ),
              ),
            ),

            // Habits List
            habitsAsync.when(
              data: (habits) {
                if (habits.isEmpty) {
                  return SliverFillRemaining(
                    child: EmptyStateWidget(
                      icon: Icons.auto_awesome_rounded,
                      title: 'Aucune habitude',
                      message: 'Commencez par créer votre première habitude',
                      actionLabel: 'Créer une habitude',
                      onAction: () => context.push('/create-habit'),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingMedium,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final habit = habits[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppConstants.paddingMedium,
                        ),
                        child: HabitCard(habit: habit),
                      );
                    }, childCount: habits.length),
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stack) => SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      Text(
                        'Erreur lors du chargement',
                        style: AppTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      TextButton(
                        onPressed: () {
                          ref.invalidate(habitsProvider);
                        },
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom spacing
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/create-habit'),
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle habitude'),
      ),
    );
  }

  Widget _buildQuoteCard() {
    final quote = AppConstants.quotes[_quoteIndex];

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Row(
        children: [
          const Icon(Icons.format_quote, color: Colors.white, size: 32),
          const SizedBox(width: AppConstants.paddingMedium),
          Expanded(
            child: Text(
              quote,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
