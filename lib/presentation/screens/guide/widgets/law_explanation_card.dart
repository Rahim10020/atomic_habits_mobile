import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/text_styles.dart';

class LawExplanationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String explanation;
  final List<String> playbook;
  final List<String> examples;
  final String identityShift;
  final IconData icon;
  final Color color;

  const LawExplanationCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.explanation,
    required this.playbook,
    required this.examples,
    required this.identityShift,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.titleLarge.copyWith(color: color),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(subtitle, style: AppTextStyles.bodySmall),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(explanation.trim(), style: AppTextStyles.bodyMedium),
            ),
            const SizedBox(height: 12),
            Text(
              'Playbook 1%',
              style: AppTextStyles.titleSmall.copyWith(color: color),
            ),
            const SizedBox(height: 6),
            ...playbook.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle, size: 18, color: color),
                    const SizedBox(width: 8),
                    Expanded(child: Text(item, style: AppTextStyles.bodySmall)),
                  ],
                ),
              ),
            ),
            const Divider(height: 24),
            Text(
              'Exemples concrets',
              style: AppTextStyles.labelLarge.copyWith(color: color),
            ),
            const SizedBox(height: 6),
            ...examples
                .take(3)
                .map(
                  (example) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.arrow_right, size: 16, color: color),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(example, style: AppTextStyles.bodySmall),
                        ),
                      ],
                    ),
                  ),
                ),
            const SizedBox(height: 12),
            Text(
              identityShift,
              style: AppTextStyles.bodyMedium.copyWith(
                fontStyle: FontStyle.italic,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
