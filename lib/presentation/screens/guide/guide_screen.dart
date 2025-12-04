import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../domain/models/four_laws.dart';
import 'widgets/concept_bottom_sheet.dart';
import 'widgets/custom_accordion.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final List<_LawGuideContent> _lawGuideContent;
  late final List<_PrincipleGuideContent> _principleGuideContent;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _lawGuideContent = _buildLawGuideContent();
    _principleGuideContent = _buildPrincipleGuideContent();
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
          _buildGlossaryTab(context),
        ],
      ),
    );
  }

  Widget _buildFourLawsTab() {
    return ListView.builder(
      key: const PageStorageKey('guide_laws_tab'),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      itemCount: _lawGuideContent.length,
      itemBuilder: (context, index) {
        final law = _lawGuideContent[index];
        return CustomAccordion(
          title: law.title,
          subtitle: law.subtitle,
          icon: law.icon,
          color: law.color,
          initiallyExpanded: index == 0,
          content: _buildLawContent(law),
        );
      },
    );
  }

  Widget _buildLawContent(_LawGuideContent law) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          decoration: BoxDecoration(
            color: law.color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(law.explanation.trim(), style: AppTextStyles.bodyMedium),
        ),
        const SizedBox(height: 16),
        Text(
          'Playbook 1%',
          style: AppTextStyles.titleSmall.copyWith(color: law.color),
        ),
        const SizedBox(height: 8),
        ...law.playbook.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle, size: 20, color: law.color),
                const SizedBox(width: 12),
                Expanded(child: Text(item, style: AppTextStyles.bodySmall)),
              ],
            ),
          ),
        ),
        const Divider(height: 24),
        Text(
          'Exemples concrets',
          style: AppTextStyles.labelLarge.copyWith(color: law.color),
        ),
        const SizedBox(height: 8),
        ...law.examples
            .take(3)
            .map(
              (example) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.arrow_right, size: 18, color: law.color),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(example, style: AppTextStyles.bodySmall),
                    ),
                  ],
                ),
              ),
            ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          decoration: BoxDecoration(
            color: law.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: law.color.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            law.identityShift,
            style: AppTextStyles.bodyMedium.copyWith(
              fontStyle: FontStyle.italic,
              color: law.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrinciplesTab() {
    return ListView.builder(
      key: const PageStorageKey('guide_principles_tab'),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      itemCount: _principleGuideContent.length,
      itemBuilder: (context, index) {
        final principle = _principleGuideContent[index];
        return CustomAccordion(
          title: principle.title,
          icon: principle.icon,
          color: principle.color,
          initiallyExpanded: index == 0,
          content: _buildPrincipleContent(principle),
        );
      },
    );
  }

  Widget _buildPrincipleContent(_PrincipleGuideContent principle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          decoration: BoxDecoration(
            color: principle.color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(principle.description, style: AppTextStyles.bodyMedium),
        ),
        if (principle.actionTips.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Passer à l'
            'action',
            style: AppTextStyles.labelLarge.copyWith(color: principle.color),
          ),
          const SizedBox(height: 8),
          ...principle.actionTips.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, size: 20, color: principle.color),
                  const SizedBox(width: 12),
                  Expanded(child: Text(tip, style: AppTextStyles.bodySmall)),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGlossaryTab(BuildContext context) {
    final entries = AtomicHabitsPrinciples.conceptExplanations.entries.toList();
    return ListView.builder(
      key: const PageStorageKey('guide_glossary_tab'),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      itemCount: entries.length,
      itemBuilder: (_, index) {
        final entry = entries[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
          child: ListTile(
            leading: Icon(Icons.menu_book, color: AppColors.primary),
            title: Text(entry.key, style: AppTextStyles.titleMedium),
            subtitle: Text(entry.value, style: AppTextStyles.bodySmall),
            trailing: IconButton(
              icon: const Icon(Icons.info_outline),
              color: AppColors.primary,
              onPressed: () {
                showConceptBottomSheet(
                  context: context,
                  title: entry.key,
                  description: entry.value,
                  color: AppColors.primary,
                  actionSteps: _glossaryActionSteps(entry.key),
                  identityShifts: _glossaryIdentityShifts(entry.key),
                  examples: const [],
                  ctaLabel: null,
                );
              },
            ),
          ),
        );
      },
    );
  }

  List<_LawGuideContent> _buildLawGuideContent() {
    return [
      _LawGuideContent(
        title: FourLaws.makeItObvious,
        subtitle: lawGuideData[FourLaws.makeItObvious]!.subtitle,
        explanation: FourLaws.detailedExplanations[FourLaws.makeItObvious]!,
        icon: Icons.visibility,
        color: AppColors.primary,
        playbook: lawGuideData[FourLaws.makeItObvious]!.playbook,
        examples: FourLawsExamples.cueExamples,
        identityShift:
            'Identité :\n• ${lawGuideData[FourLaws.makeItObvious]!.identityShifts.join('\n• ')}',
      ),
      _LawGuideContent(
        title: FourLaws.makeItAttractive,
        subtitle: lawGuideData[FourLaws.makeItAttractive]!.subtitle,
        explanation: FourLaws.detailedExplanations[FourLaws.makeItAttractive]!,
        icon: Icons.favorite,
        color: AppColors.accent,
        playbook: lawGuideData[FourLaws.makeItAttractive]!.playbook,
        examples: FourLawsExamples.cravingExamples,
        identityShift:
            'Identité :\n• ${lawGuideData[FourLaws.makeItAttractive]!.identityShifts.join('\n• ')}',
      ),
      _LawGuideContent(
        title: FourLaws.makeItEasy,
        subtitle: lawGuideData[FourLaws.makeItEasy]!.subtitle,
        explanation: FourLaws.detailedExplanations[FourLaws.makeItEasy]!,
        icon: Icons.speed,
        color: AppColors.secondary,
        playbook: lawGuideData[FourLaws.makeItEasy]!.playbook,
        examples: FourLawsExamples.responseExamples,
        identityShift:
            'Identité :\n• ${lawGuideData[FourLaws.makeItEasy]!.identityShifts.join('\n• ')}',
      ),
      _LawGuideContent(
        title: FourLaws.makeItSatisfying,
        subtitle: lawGuideData[FourLaws.makeItSatisfying]!.subtitle,
        explanation: FourLaws.detailedExplanations[FourLaws.makeItSatisfying]!,
        icon: Icons.star,
        color: AppColors.success,
        playbook: lawGuideData[FourLaws.makeItSatisfying]!.playbook,
        examples: FourLawsExamples.rewardExamples,
        identityShift:
            'Identité :\n• ${lawGuideData[FourLaws.makeItSatisfying]!.identityShifts.join('\n• ')}',
      ),
    ];
  }

  List<_PrincipleGuideContent> _buildPrincipleGuideContent() {
    return [
      _PrincipleGuideContent(
        title: '1% d’amélioration chaque jour = 37x mieux en un an',
        description:
            'Les micro-progrès forment un intérêt composé. La constance bat l’intensité et permet de franchir le plateau du potentiel latent.',
        actionTips: [
          'Planifie une micro-victoire quotidienne (2 minutes minimum).',
          'Enregistre ton progrès dans un tracker pour rendre la chaîne visible.',
          'Fais une revue hebdo : qu’est-ce qui t’a rapproché de +1% ?',
        ],
        icon: Icons.trending_up,
        color: AppColors.success,
      ),
      _PrincipleGuideContent(
        title: 'Vous tombez au niveau de vos systèmes',
        description:
            'Les objectifs fixent une direction, mais seuls les systèmes quotidiens créent la transformation durable.',
        actionTips: [
          'Liste tes habitudes actuelles (+ / - / =).',
          'Construit un système simple (signal → routine → récompense).',
          'Optimise ton environnement avant de chercher plus de discipline.',
        ],
        icon: Icons.hub,
        color: AppColors.primary,
      ),
      _PrincipleGuideContent(
        title: 'Chaque action est un vote pour ton identité',
        description:
            'Le changement durable part de qui tu veux devenir, pas de ce que tu veux obtenir.',
        actionTips: [
          'Écris “Je suis quelqu’un qui…” pour l’identité ciblée.',
          'Associe chaque habitude à ce vote (même minuscule).',
          'Rappelle-toi que la perfection n’est pas requise : accumule les votes positifs.',
        ],
        icon: Icons.verified_user,
        color: AppColors.accent,
      ),
      _PrincipleGuideContent(
        title: 'La vallée de la déception',
        description:
            'Les progrès semblent invisibles jusqu’au seuil critique. Reste sur le système jusqu’au plateau du potentiel latent.',
        actionTips: [
          'Mesure le processus (minutes, répétitions) pas uniquement le résultat.',
          'Documente tes apprentissages quand rien ne semble bouger.',
          'Prépare une récompense différée pour célébrer la persévérance.',
        ],
        icon: Icons.terrain,
        color: AppColors.secondary,
      ),
      _PrincipleGuideContent(
        title: 'Habitudes = intérêt composé de l’amélio. personnelle',
        description:
            'Ce que tu répètes devient ta nouvelle ligne de base. Les micro-choix se cumulent dans les deux sens.',
        actionTips: [
          'Associe chaque habitude à un bénéfice long terme clair.',
          'Supprime les habitudes neutres (=) qui n’ajoutent aucun intérêt.',
          'Planifie un audit trimestriel des systèmes.',
        ],
        icon: Icons.repeat,
        color: AppColors.info,
      ),
      _PrincipleGuideContent(
        title: 'Ne manque jamais deux fois',
        description:
            'Manquer une fois est un accident. Le rattrapage immédiat préserve la chaîne et la confiance identitaire.',
        actionTips: [
          'Crée un plan “si je rate, alors je fais …” avant de commencer.',
          'Garde une version de secours (micro-routine) pour les journées chargées.',
          'Célèbre le rebond plus fort que la performance parfaite.',
        ],
        icon: Icons.auto_fix_high,
        color: AppColors.warning,
      ),
      _PrincipleGuideContent(
        title: 'Les professionnels respectent l’emploi du temps',
        description:
            'La motivation suit l’action. S’engager sur un créneau protège des aléas et de l’ennui.',
        actionTips: [
          'Bloque un rendez-vous non négociable avec ta nouvelle habitude.',
          'Prépare ton matériel juste après la séance pour réduire la friction future.',
          'Utilise un rappel contextuel (alarme + note) pour automatiser le démarrage.',
        ],
        icon: Icons.schedule,
        color: AppColors.secondary,
      ),
      _PrincipleGuideContent(
        title: 'Tombe amoureux de l’ennui',
        description:
            'Le véritable avantage concurrentiel vient de la capacité à répéter même quand l’émotion n’est pas là.',
        actionTips: [
          'Définis des standards minimums à respecter quoi qu’il arrive.',
          'Varie le contexte ou la playlist, pas la routine cœur.',
          'Note comment tu te sens avant/après pour prouver que l’action change l’état.',
        ],
        icon: Icons.favorite_border,
        color: AppColors.accent,
      ),
    ];
  }

  List<String> _glossaryActionSteps(String concept) {
    final map = <String, List<String>>{
      'Amélioration de 1%': [
        'Choisis un indicateur simple (minutes, pages, répétitions).',
        'Enregistre quotidiennement tes votes positifs.',
        'Planifie une révision mensuelle pour observer l’intérêt composé.',
      ],
      'Habitudes basées sur l\'identité': [
        'Complète la phrase : “Je suis quelqu’un qui…”.',
        'Associe chaque action à cette identité.',
        'Élimine les routines contradictoires (votes négatifs).',
      ],
      'Les systèmes battent les objectifs': [
        'Décompose ton objectif en boucle signal → envie → réponse → récompense.',
        'Optimise l’environnement avant de demander plus de volonté.',
        'Documente le processus pour le répliquer.',
      ],
      'Règle des 2 minutes': [
        'Réduis la nouvelle habitude jusqu’à ce qu’elle prenne 120 secondes.',
        'Prépare une version “mode secours” pour les journées chargées.',
        'Une fois la version mini masterisée, allonge graduellement.',
      ],
      'Empilement d\'habitudes': [
        'Liste tes routines automatiques actuelles.',
        'Associe la nouvelle habitude juste après un déclencheur stable.',
        'Répète la formule : “Après [routine], je vais [habitude 2 min]”.',
      ],
    };
    return map[concept] ??
        [
          'Note une action concrète à tester cette semaine.',
          'Observe comment ton environnement influence le comportement.',
          'Fais une revue vendredi pour ajuster ton système.',
        ];
  }

  List<String> _glossaryIdentityShifts(String concept) {
    final map = <String, List<String>>{
      'Amélioration de 1%': [
        'Je suis quelqu’un qui s’améliore même quand la progression est invisible.',
      ],
      'Habitudes basées sur l\'identité': [
        'Je décide d’abord qui je suis, puis j’agis en conséquence.',
      ],
      'Les systèmes battent les objectifs': [
        'Je suis un designer de systèmes, pas un chasseur d’objectifs.',
      ],
      'Règle des 2 minutes': [
        'Je suis quelqu’un qui se présente, même pour une version ridiculement simple.',
      ],
      'Empilement d\'habitudes': [
        'Je suis quelqu’un qui transforme ses routines actuelles en tremplin vers de meilleures versions de moi-même.',
      ],
    };
    return map[concept] ??
        ['Je suis une personne qui construit consciemment ses comportements.'];
  }
}

class _LawGuideContent {
  final String title;
  final String subtitle;
  final String explanation;
  final List<String> playbook;
  final List<String> examples;
  final String identityShift;
  final IconData icon;
  final Color color;

  const _LawGuideContent({
    required this.title,
    required this.subtitle,
    required this.explanation,
    required this.playbook,
    required this.examples,
    required this.identityShift,
    required this.icon,
    required this.color,
  });
}

class _PrincipleGuideContent {
  final String title;
  final String description;
  final List<String> actionTips;
  final IconData icon;
  final Color color;

  const _PrincipleGuideContent({
    required this.title,
    required this.description,
    required this.actionTips,
    required this.icon,
    required this.color,
  });
}
