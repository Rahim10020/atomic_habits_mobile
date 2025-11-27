import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../domain/models/four_laws.dart';

class GuideScreen extends ConsumerStatefulWidget {
  const GuideScreen({super.key});

  @override
  ConsumerState<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends ConsumerState<GuideScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guide Atomic Habits'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.book), text: 'Les 4 Lois'),
            Tab(icon: Icon(Icons.lightbulb), text: 'Principes'),
            Tab(icon: Icon(Icons.school), text: 'Glossaire'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFourLawsTab(),
          _buildPrinciplesTab(),
          _buildGlossaryTab(),
        ],
      ),
    );
  }

  Widget _buildFourLawsTab() {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      children: [
        _buildLawCard(
          title: FourLaws.makeItObvious,
          description: FourLaws.makeItObviousDescription,
          icon: Icons.visibility,
          color: AppColors.primary,
          examples: FourLawsExamples.cueExamples,
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        _buildLawCard(
          title: FourLaws.makeItAttractive,
          description: FourLaws.makeItAttractiveDescription,
          icon: Icons.favorite,
          color: AppColors.accent,
          examples: FourLawsExamples.cravingExamples,
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        _buildLawCard(
          title: FourLaws.makeItEasy,
          description: FourLaws.makeItEasyDescription,
          icon: Icons.speed,
          color: AppColors.secondary,
          examples: FourLawsExamples.responseExamples,
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        _buildLawCard(
          title: FourLaws.makeItSatisfying,
          description: FourLaws.makeItSatisfyingDescription,
          icon: Icons.star,
          color: AppColors.success,
          examples: FourLawsExamples.rewardExamples,
        ),
      ],
    );
  }

  Widget _buildPrinciplesTab() {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      children: AtomicHabitsPrinciples.keyPrinciples.map((principle) {
        return Card(
          margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(principle, style: AppTextStyles.bodyMedium),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGlossaryTab() {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      children: AtomicHabitsPrinciples.conceptExplanations.entries.map((entry) {
        return ExpansionTile(
          title: Text(entry.key, style: AppTextStyles.titleMedium),
          leading: Icon(Icons.menu_book, color: AppColors.primary),
          children: [
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Text(entry.value, style: AppTextStyles.bodyMedium),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildLawCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required List<String> examples,
  }) {
    return Card(
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title, style: AppTextStyles.titleMedium),
        subtitle: Text(description, style: AppTextStyles.bodySmall),
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Exemples concrets :',
                  style: AppTextStyles.labelMedium.copyWith(color: color),
                ),
                const SizedBox(height: 8),
                ...examples
                    .take(3)
                    .map(
                      (example) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.arrow_right, size: 16, color: color),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                example,
                                style: AppTextStyles.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
