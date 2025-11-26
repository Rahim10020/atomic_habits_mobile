import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../application/providers/habit_provider.dart';

class DailySummary extends StatelessWidget {
  final DashboardStats stats;

  const DailySummary({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Aujourd\'hui', style: AppTextStyles.headlineSmall),
              _buildCompletionBadge(),
            ],
          ),
          const SizedBox(height: AppConstants.paddingLarge),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: stats.totalHabits > 0
                  ? stats.completedCount / stats.totalHabits
                  : 0,
              minHeight: 12,
              backgroundColor: AppColors.borderLight,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getProgressColor(stats.completionRate),
              ),
            ),
          ),

          const SizedBox(height: AppConstants.paddingMedium),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.check_circle_rounded,
                label: 'Complétées',
                value: '${stats.completedCount}',
                color: AppColors.success,
              ),
              _buildStatItem(
                icon: Icons.pending_rounded,
                label: 'En attente',
                value: '${stats.pendingCount}',
                color: AppColors.warning,
              ),
              _buildStatItem(
                icon: Icons.auto_awesome_rounded,
                label: 'Total',
                value: '${stats.totalHabits}',
                color: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionBadge() {
    final percentage = stats.completionRate.toInt();
    final color = _getProgressColor(stats.completionRate);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getProgressIcon(stats.completionRate), size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            '$percentage%',
            style: AppTextStyles.labelMedium.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.headlineMedium.copyWith(
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
    );
  }

  Color _getProgressColor(double percentage) {
    if (percentage >= 80) return AppColors.success;
    if (percentage >= 50) return AppColors.warning;
    return AppColors.error;
  }

  IconData _getProgressIcon(double percentage) {
    if (percentage >= 80) return Icons.celebration_rounded;
    if (percentage >= 50) return Icons.trending_up_rounded;
    return Icons.rocket_launch_rounded;
  }
}
