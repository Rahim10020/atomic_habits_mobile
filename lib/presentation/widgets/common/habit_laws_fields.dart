import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../domain/models/four_laws.dart';

class HabitLawsFields extends StatelessWidget {
  final TextEditingController cueController;
  final TextEditingController cravingController;
  final TextEditingController responseController;
  final TextEditingController rewardController;
  final bool showExamples;

  const HabitLawsFields({
    super.key,
    required this.cueController,
    required this.cravingController,
    required this.responseController,
    required this.rewardController,
    this.showExamples = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildLawSection(
          context: context,
          law: FourLaws.makeItObvious,
          description: FourLaws.makeItObviousDescription,
          controller: cueController,
          hint: 'Ex: Mettre mes chaussures près du lit',
          icon: Icons.visibility_rounded,
          color: AppColors.primary,
          examples: showExamples
              ? FourLawsExamples.cueExamples.take(3).toList()
              : [],
        ),
        const SizedBox(height: AppConstants.paddingLarge),

        _buildLawSection(
          context: context,
          law: FourLaws.makeItAttractive,
          description: FourLaws.makeItAttractiveDescription,
          controller: cravingController,
          hint: 'Ex: Écouter ma musique préférée',
          icon: Icons.favorite_rounded,
          color: AppColors.accent,
          examples: showExamples
              ? FourLawsExamples.cravingExamples.take(3).toList()
              : [],
        ),
        const SizedBox(height: AppConstants.paddingLarge),

        _buildLawSection(
          context: context,
          law: FourLaws.makeItEasy,
          description: FourLaws.makeItEasyDescription,
          controller: responseController,
          hint: 'Ex: Commencer par 2 minutes',
          icon: Icons.speed_rounded,
          color: AppColors.secondary,
          examples: showExamples
              ? FourLawsExamples.responseExamples.take(3).toList()
              : [],
        ),
        const SizedBox(height: AppConstants.paddingLarge),

        _buildLawSection(
          context: context,
          law: FourLaws.makeItSatisfying,
          description: FourLaws.makeItSatisfyingDescription,
          controller: rewardController,
          hint: 'Ex: Marquer un X sur mon calendrier',
          icon: Icons.star_rounded,
          color: AppColors.success,
          examples: showExamples
              ? FourLawsExamples.rewardExamples.take(3).toList()
              : [],
        ),
      ],
    );
  }

  Widget _buildLawSection({
    required String law,
    required String description,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Color color,
    required List<String> examples,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
                  Row(
                    children: [
                      Text(
                        law,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      // IconButton info
                      IconButton(
                        icon: Icon(
                          Icons.info_outline,
                          size: 18,
                          color: color.withValues(alpha: 0.7),
                        ),
                        onPressed: () => _showConceptExplanation(
                          context,
                          law,
                          description,
                          examples,
                          color,
                        ),
                        tooltip: 'En savoir plus',
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  Text(
                    description,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: color),
          ),
        ),
        if (examples.isNotEmpty) ...[
          const SizedBox(height: 8),
          ExpansionTile(
            title: Text(
              'Voir des exemples',
              style: AppTextStyles.bodySmall.copyWith(color: color),
            ),
            tilePadding: EdgeInsets.zero,
            childrenPadding: const EdgeInsets.only(left: 16, bottom: 8),
            children: examples.map((example) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.circle, size: 6, color: color),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        example,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  // methode pour les explications
  void _showConceptExplanation(
    BuildContext context,
    String title,
    String description,
    List<String> examples,
    Color color,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.lightbulb, color: color, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(title, style: AppTextStyles.headlineSmall),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(description, style: AppTextStyles.bodyLarge),
              const SizedBox(height: 24),
              Text(
                'Exemples concrets :',
                style: AppTextStyles.titleMedium.copyWith(color: color),
              ),
              const SizedBox(height: 12),
              ...examples
                  .take(5)
                  .map(
                    (example) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check_circle, size: 16, color: color),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              example,
                              style: AppTextStyles.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    context.push('/guide');
                  },
                  icon: const Icon(Icons.book),
                  label: const Text('Voir le guide complet'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: color,
                    side: BorderSide(color: color),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
