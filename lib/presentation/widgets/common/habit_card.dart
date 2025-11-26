import 'package:atomic_habits_mobile/presentation/widgets/animations/check_animation.dart';
import 'package:atomic_habits_mobile/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vibration/vibration.dart' show Vibration;
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../domain/models/habit.dart';
import '../../../application/providers/habit_provider.dart';

class HabitCard extends ConsumerStatefulWidget {
  final Habit habit;

  const HabitCard({super.key, required this.habit});

  @override
  ConsumerState<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends ConsumerState<HabitCard> {
  bool _isAnimating = false;

  @override
  Widget build(BuildContext context) {
    final completionAsync = ref.watch(todayCompletionProvider(widget.habit.id));

    return completionAsync.when(
      data: (isCompleted) => _buildCard(isCompleted),
      loading: () => _buildCard(false),
      error: (_, __) => _buildCard(false),
    );
  }

  Widget _buildCard(bool isCompleted) {
    final categoryColor =
        AppColors.categoryColors[widget.habit.category] ?? AppColors.primary;

    return GestureDetector(
      onTap: () => context.push('/habit-detail/${widget.habit.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(
            color: isCompleted
                ? categoryColor.withValues(alpha: 0.3)
                : AppColors.borderLight,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          child: Stack(
            children: [
              // Color indicator on the left
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(width: 6, color: categoryColor),
              ),

              // Main content
              Padding(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Row(
                  children: [
                    const SizedBox(width: 10),

                    // Check button
                    GestureDetector(
                      onTap: () => _toggleCompletion(isCompleted),
                      child: CheckAnimation(
                        isChecked: isCompleted,
                        isAnimating: _isAnimating,
                        color: categoryColor,
                        size: 48,
                      ),
                    ),

                    const SizedBox(width: AppConstants.paddingMedium),

                    // Habit details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.habit.name,
                            style: AppTextStyles.titleLarge.copyWith(
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: isCompleted
                                  ? AppColors.textSecondaryLight
                                  : AppColors.textPrimaryLight,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          if (widget.habit.description != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              widget.habit.description!,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondaryLight,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],

                          const SizedBox(height: 8),

                          // Category and streak
                          Row(
                            children: [
                              _buildChip(
                                icon: Icons.category_rounded,
                                label: widget.habit.category,
                                color: categoryColor,
                              ),
                              const SizedBox(width: 8),
                              if (widget.habit.currentStreak > 0)
                                _buildChip(
                                  icon: Icons.local_fire_department_rounded,
                                  label: '${widget.habit.currentStreak} jours',
                                  color: AppColors.getStreakColor(
                                    widget.habit.currentStreak,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Arrow icon
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textSecondaryLight,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleCompletion(bool isCompleted) async {
    if (_isAnimating) return;

    // Ajout d'un feedback haptique
    final hasVibrator = await Vibration.hasVibrator() ?? false;
    if (hasVibrator) {
      if (!isCompleted) {
        Vibration.vibrate(duration: 50); // Complétion
      } else {
        Vibration.vibrate(duration: 30); // Annulation
      }
    }

    setState(() {
      _isAnimating = true;
    });

    try {
      final controller = ref.read(habitControllerProvider.notifier);

      if (isCompleted) {
        await controller.uncompleteHabit(widget.habit.id, DateTime.now());
      } else {
        await controller.completeHabit(widget.habit.id);

        // Verification de milestone
        final updatedHabit = await ref.read(
          habitProvider(widget.habit.id).future,
        );
        if (updatedHabit != null) {
          _checkMilestone(updatedHabit);
        }
      }

      ref.invalidate(todayCompletionProvider(widget.habit.id));
      ref.invalidate(dashboardStatsProvider);
      ref.invalidate(habitsProvider);

      await Future.delayed(const Duration(milliseconds: 500));
    } finally {
      if (mounted) {
        setState(() {
          _isAnimating = false;
        });
      }
    }
  }

  // Méthode pour les milestones
  void _checkMilestone(Habit habit) {
    if (AppConstants.milestones.contains(habit.currentStreak)) {
      final message = AppConstants.milestoneMessages[habit.currentStreak];
      if (message != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Notification de milestone
        NotificationService().showMilestoneNotification(
          habitId: habit.id,
          habitName: habit.name,
          streak: habit.currentStreak,
          message: message,
        );
      }
    }
  }
}
