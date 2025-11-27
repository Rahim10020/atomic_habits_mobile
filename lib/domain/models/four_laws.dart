// Four Laws of Behavior Change from Atomic Habits by James Clear

class FourLaws {
  static const String makeItObvious = 'Rendre évident';
  static const String makeItAttractive = 'Rendre attrayant';
  static const String makeItEasy = 'Rendre facile';
  static const String makeItSatisfying = 'Rendre satisfaisant';

  // Inversions for breaking bad habits
  static const String makeItInvisible = 'Rendre invisible';
  static const String makeItUnattractive = 'Rendre peu attrayant';
  static const String makeItDifficult = 'Rendre difficile';
  static const String makeItUnsatisfying = 'Rendre insatisfaisant';

  // Descriptions
  static const String makeItObviousDescription =
      'Créez des signaux visuels clairs pour déclencher votre habitude';
  static const String makeItAttractiveDescription =
      'Associez votre habitude à quelque chose que vous aimez';
  static const String makeItEasyDescription =
      'Réduisez la friction et rendez l\'habitude aussi simple que possible';
  static const String makeItSatisfyingDescription =
      'Célébrez vos victoires et rendez l\'habitude gratifiante';

  // NOUVEAU: Descriptions détaillées pour l'UI
  static const Map<String, String> detailedExplanations = {
    makeItObvious: '''
La première loi consiste à rendre vos signaux évidents et impossibles à ignorer.

Votre cerveau détecte constamment des indices dans votre environnement qui lui indiquent quoi faire ensuite. En rendant ces signaux plus visibles, vous facilitez le démarrage de votre habitude.

Stratégies clés :
• Design d'environnement : Placer des objets liés à votre habitude bien en vue
• Intention d'implémentation : "Je vais [COMPORTEMENT] à [HEURE] dans [LIEU]"
• Habit stacking : Lier votre nouvelle habitude à une habitude existante
''',

    makeItAttractive: '''
La deuxième loi vise à rendre votre habitude irrésistible en l'associant à des expériences positives.

Votre cerveau est câblé pour rechercher des récompenses. En rendant l'habitude attrayante, vous augmentez les chances de la répéter.

Stratégies clés :
• Temptation bundling : Associer l'habitude à quelque chose que vous aimez
• Rejoindre une culture : S'entourer de personnes qui incarnent l'identité que vous visez
• Recadrage mental : Voir l'habitude comme une opportunité, pas une obligation
''',

    makeItEasy: '''
La troisième loi consiste à réduire la friction et simplifier au maximum le démarrage.

La loi du moindre effort : nous graviterons naturellement vers l'option qui nécessite le moins de travail. Rendez votre habitude si simple qu'il serait difficile de dire non.

Stratégies clés :
• Règle des 2 minutes : Réduire l'habitude à une version de 2 minutes
• Préparer l'environnement : Réduire les étapes entre vous et l'habitude
• Automatisation : Utiliser la technologie pour rendre l'habitude automatique
''',

    makeItSatisfying: '''
La quatrième loi vise à rendre l'habitude gratifiante pour augmenter les chances de répétition.

Le cerveau humain privilégie les récompenses immédiates. En ajoutant une satisfaction instantanée à votre habitude, vous créez un sentiment de succès qui encourage la répétition.

Stratégies clés :
• Tracking visuel : Marquer chaque jour complété (effet "ne brisez pas la chaîne")
• Célébration immédiate : Se féliciter après chaque exécution
• Accountability partner : Partager sa progression avec quelqu'un
''',
  };
}

class FourLawsExamples {
  // Law 1: Make it Obvious
  static const List<String> cueExamples = [
    'Mettre mes chaussures de sport à côté de mon lit',
    'Placer mon livre sur mon oreiller',
    'Laisser une bouteille d\'eau sur mon bureau',
    'Afficher mon objectif sur mon écran de verrouillage',
    'Préparer mes affaires de sport la veille',
  ];

  // Law 2: Make it Attractive
  static const List<String> cravingExamples = [
    'Écouter ma musique préférée pendant l\'exercice',
    'Me récompenser avec un café après ma séance de lecture',
    'Faire l\'habitude avec un ami',
    'Rejoindre un groupe qui partage cette habitude',
    'Visualiser les bénéfices de cette habitude',
  ];

  // Law 3: Make it Easy
  static const List<String> responseExamples = [
    'Commencer par 2 minutes seulement',
    'Préparer mon environnement à l\'avance',
    'Réduire les étapes nécessaires',
    'Utiliser la règle des 2 minutes',
    'Automatiser autant que possible',
  ];

  // Law 4: Make it Satisfying
  static const List<String> rewardExamples = [
    'Marquer un X sur mon calendrier',
    'Célébrer mes petites victoires',
    'Suivre ma progression visuellement',
    'Me féliciter à voix haute',
    'Partager ma réussite avec quelqu\'un',
  ];
}

class HabitStackingTemplate {
  final String currentHabit;
  final String newHabit;

  HabitStackingTemplate({required this.currentHabit, required this.newHabit});

  String get template => 'Après $currentHabit, je vais $newHabit';

  static List<String> examples = [
    'Après avoir bu mon café du matin, je méditerai pendant 2 minutes',
    'Après m\'être brossé les dents, je ferai 10 pompes',
    'Après avoir déjeuné, je lirai pendant 15 minutes',
    'Après être rentré du travail, je me changerai en tenue de sport',
    'Après avoir dîné, j\'écrirai 3 choses pour lesquelles je suis reconnaissant',
  ];
}

class IdentityBasedHabit {
  final String identity; // "Je suis quelqu'un qui..."
  final String habitAction; // L'action concrète
  final String category;

  IdentityBasedHabit({
    required this.identity,
    required this.habitAction,
    required this.category,
  });

  static Map<String, List<String>> identityExamples = {
    'Santé': [
      'Je suis quelqu\'un qui prend soin de sa santé',
      'Je suis quelqu\'un qui fait de l\'exercice régulièrement',
      'Je suis quelqu\'un qui mange sainement',
    ],
    'Productivité': [
      'Je suis quelqu\'un d\'organisé',
      'Je suis quelqu\'un qui respecte ses engagements',
      'Je suis quelqu\'un qui termine ce qu\'il commence',
    ],
    'Apprentissage': [
      'Je suis quelqu\'un qui apprend constamment',
      'Je suis un lecteur assidu',
      'Je suis quelqu\'un de curieux',
    ],
    'Social': [
      'Je suis quelqu\'un de présent pour mes proches',
      'Je suis quelqu\'un qui cultive ses amitiés',
      'Je suis quelqu\'un de bienveillant',
    ],
    'Créativité': [
      'Je suis quelqu\'un de créatif',
      'Je suis un artiste',
      'Je suis quelqu\'un qui s\'exprime',
    ],
    'Finance': [
      'Je suis quelqu\'un qui gère bien son argent',
      'Je suis quelqu\'un d\'économe',
      'Je suis quelqu\'un qui investit dans son futur',
    ],
    'Sport': [
      'Je suis un athlète',
      'Je suis quelqu\'un de sportif',
      'Je suis quelqu\'un qui aime le mouvement',
    ],
    'Mindfulness': [
      'Je suis quelqu\'un de présent',
      'Je suis quelqu\'un de calme',
      'Je suis quelqu\'un qui pratique la pleine conscience',
    ],
  };
}

class TwoMinuteRule {
  final String fullHabit;
  final String twoMinuteVersion;

  TwoMinuteRule({required this.fullHabit, required this.twoMinuteVersion});

  static List<TwoMinuteRule> examples = [
    TwoMinuteRule(
      fullHabit: 'Faire du sport 30 minutes',
      twoMinuteVersion: 'Mettre mes chaussures de sport',
    ),
    TwoMinuteRule(
      fullHabit: 'Lire un livre',
      twoMinuteVersion: 'Lire une page',
    ),
    TwoMinuteRule(
      fullHabit: 'Méditer 20 minutes',
      twoMinuteVersion: 'Prendre trois respirations profondes',
    ),
    TwoMinuteRule(
      fullHabit: 'Écrire un article',
      twoMinuteVersion: 'Écrire une phrase',
    ),
    TwoMinuteRule(
      fullHabit: 'Faire du yoga',
      twoMinuteVersion: 'Dérouler mon tapis de yoga',
    ),
  ];
}

class AtomicHabitsPrinciples {
  static const List<String> keyPrinciples = [
    '1% d\'amélioration chaque jour = 37x mieux en un an',
    'Vous n\'atteignez pas le niveau de vos objectifs, vous tombez au niveau de vos systèmes',
    'Chaque action est un vote pour le type de personne que vous voulez devenir',
    'La qualité de votre vie dépend de la qualité de vos habitudes',
    'Les habitudes sont l\'intérêt composé de l\'amélioration personnelle',
    'Le changement véritable vient de l\'identité, pas des résultats',
    'Un objectif sans système est juste un souhait',
    'Ne vous concentrez pas sur ce que vous voulez accomplir, concentrez-vous sur qui vous voulez devenir',
  ];

  static const Map<String, String> conceptExplanations = {
    'Amélioration de 1%':
        'Si vous améliorez quelque chose de 1% chaque jour pendant un an, vous finirez 37 fois mieux. '
        'Les petites améliorations s\'accumulent de manière exponentielle.',

    'Habitudes basées sur l\'identité':
        'Au lieu de vous concentrer sur ce que vous voulez accomplir (résultat), concentrez-vous sur qui vous voulez devenir (identité). '
        'Chaque habitude renforce votre identité.',

    'Les systèmes battent les objectifs':
        'Les objectifs sont bons pour donner une direction, mais les systèmes sont meilleurs pour faire des progrès. '
        'Un système est un processus que vous suivez indépendamment du résultat.',

    'Règle des 2 minutes':
        'Quand vous commencez une nouvelle habitude, elle ne devrait pas prendre plus de deux minutes. '
        'Le but est de rendre l\'habitude aussi facile que possible à commencer.',

    'Empilement d\'habitudes':
        'Après [HABITUDE ACTUELLE], je vais [NOUVELLE HABITUDE]. '
        'Utilisez vos habitudes actuelles comme déclencheurs pour de nouvelles habitudes.',
  };
}
