import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/text_styles.dart';

Future<void> showConceptBottomSheet({
  required BuildContext context,
  required String title,
  required String description,
  required Color color,
  List<String> actionSteps = const [],
  List<String> identityShifts = const [],
  List<String> examples = const [],
  String? ctaLabel,
  VoidCallback? onCtaPressed,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      return DraggableScrollableSheet(
        expand: false,
        minChildSize: 0.4,
        initialChildSize: 0.65,
        maxChildSize: 0.95,
        builder: (_, controller) {
          return ConceptBottomSheet(
            title: title,
            description: description,
            color: color,
            actionSteps: actionSteps,
            identityShifts: identityShifts,
            examples: examples,
            ctaLabel: ctaLabel,
            onCtaPressed: () {
              Navigator.of(sheetContext).pop();
              onCtaPressed?.call();
            },
            scrollController: controller,
          );
        },
      );
    },
  );
}

class ConceptBottomSheet extends StatelessWidget {
  final String title;
  final String description;
  final Color color;
  final List<String> actionSteps;
  final List<String> identityShifts;
  final List<String> examples;
  final String? ctaLabel;
  final VoidCallback? onCtaPressed;
  final ScrollController? scrollController;

  const ConceptBottomSheet({
    super.key,
    required this.title,
    required this.description,
    required this.color,
    required this.actionSteps,
    required this.identityShifts,
    required this.examples,
    this.ctaLabel,
    this.onCtaPressed,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
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
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.lightbulb, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: AppTextStyles.headlineSmall)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Pourquoi ça compte',
            style: AppTextStyles.titleMedium.copyWith(color: color),
          ),
          const SizedBox(height: 8),
          Text(
            '$description\n\nLes habitudes fonctionnent comme l’intérêt composé de l’amélioration personnelle : minuscules maintenant, exponentielles plus tard. Persévérez au-delà de la vallée de la déception pour atteindre le plateau du potentiel latent.',
            style: AppTextStyles.bodyMedium,
          ),
          if (actionSteps.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              'Playbook 1% (systèmes > objectifs)',
              style: AppTextStyles.titleMedium.copyWith(color: color),
            ),
            const SizedBox(height: 8),
            ..._buildBulletList(actionSteps, Icons.check_circle, color),
          ],
          if (identityShifts.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              'Identité à ancrer',
              style: AppTextStyles.titleMedium.copyWith(color: color),
            ),
            const SizedBox(height: 8),
            ..._buildBulletList(identityShifts, Icons.person, color),
          ],
          if (examples.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              'Exemples concrets',
              style: AppTextStyles.titleMedium.copyWith(color: color),
            ),
            const SizedBox(height: 8),
            ..._buildBulletList(examples.take(5).toList(), Icons.bolt, color),
          ],
          if (ctaLabel != null) ...[
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onCtaPressed,
                icon: const Icon(Icons.menu_book),
                label: Text(ctaLabel!),
                style: FilledButton.styleFrom(
                  backgroundColor: color.withValues(alpha: 0.15),
                  foregroundColor: color,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildBulletList(
    List<String> values,
    IconData icon,
    Color color,
  ) {
    return values
        .map(
          (value) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 18, color: color.withValues(alpha: 0.9)),
                const SizedBox(width: 8),
                Expanded(child: Text(value, style: AppTextStyles.bodyMedium)),
              ],
            ),
          ),
        )
        .toList();
  }
}
