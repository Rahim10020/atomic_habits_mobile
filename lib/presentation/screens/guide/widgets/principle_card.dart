import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/text_styles.dart';

class PrincipleCard extends StatelessWidget {
  final String title;
  final String description;
  final List<String> actionTips;
  final IconData icon;
  final Color color;

  const PrincipleCard({
    super.key,
    required this.title,
    required this.description,
    required this.actionTips,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(description, style: AppTextStyles.bodyMedium),
            if (actionTips.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Passer à l’action',
                style: AppTextStyles.labelLarge.copyWith(color: color),
              ),
              const SizedBox(height: 6),
              ...actionTips.map(
                (tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check, size: 16, color: color),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(tip, style: AppTextStyles.bodySmall),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
