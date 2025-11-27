import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../domain/models/four_laws.dart';
import '../../screens/guide/widgets/concept_bottom_sheet.dart';

class HabitLawsFields extends StatelessWidget {
  final TextEditingController cueController;
  final TextEditingController cravingController;
  final TextEditingController responseController;
  final TextEditingController rewardController;
  final bool showExamples;

  static const Map<String, List<String>> _lawActionSteps = {
    FourLaws.makeItObvious: [
      'Rédige ton intention d’implémentation (quoi, quand, où).',
      'Empile cette habitude sur une routine déjà automatique.',
      'Optimise l’environnement : rends le signal visible et frictionless.',
    ],
    FourLaws.makeItAttractive: [
      'Associe la routine à un plaisir immédiat (temptation bundling).',
      'Rejoins une communauté qui valorise ce comportement.',
      'Reformule mentalement : transforme “je dois” en “je vote pour mon identité”.',
    ],
    FourLaws.makeItEasy: [
      'Applique la règle des 2 minutes pour garantir le démarrage.',
      'Prépare ton matériel la veille afin de réduire la friction.',
      'Automatise ou planifie un rappel pour rendre l’action inévitable.',
    ],
    FourLaws.makeItSatisfying: [
      'Prévois une récompense instantanée après l’habitude.',
      'Suis ta progression (ne brise pas la chaîne).',
      'Cherche un partenaire ou un contrat d’habitudes pour la responsabilité.',
    ],
  };

  static const Map<String, List<String>> _lawIdentityShifts = {
    FourLaws.makeItObvious: [
      'Je suis l’architecte de mon environnement.',
      'Je rends les bons signaux impossible à ignorer.',
    ],
    FourLaws.makeItAttractive: [
      'Je rends mes routines irrésistibles.',
      'Je choisis des communautés qui tirent le meilleur de moi.',
    ],
    FourLaws.makeItEasy: [
      'Je suis quelqu’un qui se présente chaque jour, même 2 minutes.',
      'Je simplifie avant d’optimiser.',
    ],
    FourLaws.makeItSatisfying: [
      'Je célèbre chaque vote pour mon futur moi.',
      'Je protège ma chaîne de progression : jamais deux jours manqués.',
    ],
  };

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
          actionSteps: _lawActionSteps[FourLaws.makeItObvious]!,
          identityShifts: _lawIdentityShifts[FourLaws.makeItObvious]!,
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
          actionSteps: _lawActionSteps[FourLaws.makeItAttractive]!,
          identityShifts: _lawIdentityShifts[FourLaws.makeItAttractive]!,
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
          actionSteps: _lawActionSteps[FourLaws.makeItEasy]!,
          identityShifts: _lawIdentityShifts[FourLaws.makeItEasy]!,
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
          actionSteps: _lawActionSteps[FourLaws.makeItSatisfying]!,
          identityShifts: _lawIdentityShifts[FourLaws.makeItSatisfying]!,
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
    required List<String> actionSteps,
    required List<String> identityShifts,
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
                      IconButton(
                        icon: Icon(
                          Icons.info_outline,
                          size: 18,
                          color: color.withValues(alpha: 0.7),
                        ),
                        onPressed: () => showConceptBottomSheet(
                          context: context,
                          title: law,
                          description: description,
                          color: color,
                          actionSteps: actionSteps,
                          identityShifts: identityShifts,
                          examples: examples,
                          ctaLabel: 'Explorer le guide complet',
                          onCtaPressed: () => context.push('/guide'),
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
}
