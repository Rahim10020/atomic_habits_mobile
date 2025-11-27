import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/utils/date_utils.dart' as app_date_utils;

class HabitCalendar extends StatelessWidget {
  final Map<DateTime, bool> completionHistory;
  final Color color;

  const HabitCalendar({
    super.key,
    required this.completionHistory,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weeksToShow = 6;
    final daysToShow = weeksToShow * 7;

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
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
          // Weekday headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['L', 'M', 'M', 'J', 'V', 'S', 'D'].map((day) {
              return SizedBox(
                width: 32,
                child: Center(
                  child: Text(
                    day,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // Calendar grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: daysToShow,
            itemBuilder: (context, index) {
              final date = app_date_utils.DateUtils.startOfDay(
                now,
              ).subtract(Duration(days: daysToShow - 1 - index));
              final isCompleted = completionHistory[date] ?? false;
              final isToday = app_date_utils.DateUtils.isToday(date);

              return _buildDayCell(date, isCompleted, isToday, context);
            },
          ),
          const SizedBox(height: 16),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Fait', color),
              const SizedBox(width: 16),
              _buildLegendItem(
                'Pas fait',
                Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              const SizedBox(width: 16),
              _buildLegendItem('Aujourd\'hui', AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDayCell(
    DateTime date,
    bool isCompleted,
    bool isToday,
    BuildContext context,
  ) {
    Color backgroundColor;
    Color borderColor;

    if (isToday) {
      backgroundColor = isCompleted ? color : Colors.transparent;
      borderColor = AppColors.primary;
    } else if (isCompleted) {
      backgroundColor = color.withValues(alpha: 0.8);
      borderColor = color;
    } else {
      backgroundColor = Theme.of(context).colorScheme.surfaceContainerHighest;
      borderColor = Colors.transparent;
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: isToday ? 2 : 0),
      ),
      child: Center(
        child: Text(
          '${date.day}',
          style: AppTextStyles.bodySmall.copyWith(
            color: isCompleted ? Colors.white : AppColors.textSecondaryLight,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}
