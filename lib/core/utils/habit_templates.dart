import 'package:atomic_habits_mobile/core/constants/colors.dart';
import 'package:atomic_habits_mobile/domain/models/habit.dart';

/// Templates d'habitudes prédéfinis
class HabitTemplates {
  static List<HabitTemplate> getAllTemplates() {
    return [
      // SANTÉ
      HabitTemplate(
        name: 'Boire 2L d\'eau',
        category: 'Santé',
        description: 'Rester bien hydraté tout au long de la journée',
        identityStatement: 'Je suis quelqu\'un qui prend soin de sa santé',
        twoMinuteVersion: 'Remplir ma bouteille d\'eau',
        cue: 'Placer une bouteille d\'eau remplie sur mon bureau',
        craving: 'Utiliser ma belle bouteille en verre préférée',
        response: 'Boire un grand verre toutes les heures',
        reward: 'Cocher chaque verre sur mon tracker',
        reminderTime: '09:00',
      ),

      HabitTemplate(
        name: 'Manger 5 fruits et légumes',
        category: 'Santé',
        description: 'Consommer suffisamment de fruits et légumes',
        identityStatement: 'Je suis quelqu\'un qui mange sainement',
        twoMinuteVersion: 'Couper un fruit',
        cue: 'Préparer des fruits la veille',
        craving: 'Choisir mes fruits préférés',
        response: 'Commencer la journée avec un fruit',
        reward: 'Me sentir énergisé et en forme',
        reminderTime: '08:00',
      ),

      HabitTemplate(
        name: 'Dormir 8 heures',
        category: 'Santé',
        description: 'Se coucher à une heure régulière',
        identityStatement: 'Je suis quelqu\'un qui prend soin de son sommeil',
        twoMinuteVersion: 'Éteindre mon téléphone',
        cue: 'Alarme de coucher à 22h30',
        craving: 'Lire dans mon lit',
        response: 'Commencer ma routine de coucher',
        reward: 'Me réveiller en forme',
        reminderTime: '22:30',
      ),

      // SPORT
      HabitTemplate(
        name: 'Faire 30 min de sport',
        category: 'Sport',
        description: 'Exercice cardiovasculaire ou musculation',
        identityStatement: 'Je suis un athlète',
        twoMinuteVersion: 'Mettre mes chaussures de sport',
        cue: 'Laisser mes affaires de sport près de mon lit',
        craving: 'Écouter ma playlist énergisante',
        response: 'Faire 5 pompes pour démarrer',
        reward: 'Prendre une photo de mes progrès',
        reminderTime: '07:00',
      ),

      HabitTemplate(
        name: '10 000 pas par jour',
        category: 'Sport',
        description: 'Marcher suffisamment chaque jour',
        identityStatement: 'Je suis quelqu\'un d\'actif',
        twoMinuteVersion: 'Faire 100 pas sur place',
        cue: 'Porter ma montre connectée',
        craving: 'Découvrir un nouveau quartier',
        response: 'Descendre 2 arrêts plus tôt',
        reward: 'Consulter mes statistiques',
        reminderTime: '18:00',
      ),

      HabitTemplate(
        name: 'Stretching matinal',
        category: 'Sport',
        description: '10 minutes d\'étirements',
        identityStatement: 'Je suis quelqu\'un de souple et en forme',
        twoMinuteVersion: 'Faire un étirement',
        cue: 'Dérouler mon tapis de yoga',
        craving: 'Mettre de la musique douce',
        response: 'Étirer chaque muscle progressivement',
        reward: 'Me sentir détendu et énergisé',
        reminderTime: '07:30',
      ),

      // MINDFULNESS
      HabitTemplate(
        name: 'Méditer 10 minutes',
        category: 'Mindfulness',
        description: 'Pratiquer la pleine conscience',
        identityStatement: 'Je suis quelqu\'un de calme et présent',
        twoMinuteVersion: 'Trois respirations profondes',
        cue: 'Alarme sur mon téléphone à 6h45',
        craving: 'M\'asseoir sur mon coussin préféré',
        response: 'Fermer les yeux et respirer',
        reward: 'Commencer la journée apaisé',
        reminderTime: '06:45',
      ),

      HabitTemplate(
        name: 'Journal de gratitude',
        category: 'Mindfulness',
        description: 'Noter 3 choses positives',
        identityStatement: 'Je suis quelqu\'un de reconnaissant',
        twoMinuteVersion: 'Écrire une chose',
        cue: 'Journal sur ma table de nuit',
        craving: 'Utiliser mon stylo préféré',
        response: 'Noter rapidement 3 éléments',
        reward: 'Ressentir la paix intérieure',
        reminderTime: '22:00',
      ),

      HabitTemplate(
        name: 'Pas d\'écrans avant de dormir',
        category: 'Mindfulness',
        description: '1h sans téléphone/tablette',
        identityStatement: 'Je suis quelqu\'un qui contrôle sa technologie',
        twoMinuteVersion: 'Mettre le téléphone en mode avion',
        cue: 'Alarme à 21h',
        craving: 'Lire un bon livre',
        response: 'Laisser le téléphone dans une autre pièce',
        reward: 'Mieux dormir',
        reminderTime: '21:00',
      ),

      // APPRENTISSAGE
      HabitTemplate(
        name: 'Lire 30 minutes',
        category: 'Apprentissage',
        description: 'Livres de développement personnel ou fiction',
        identityStatement: 'Je suis un lecteur assidu',
        twoMinuteVersion: 'Lire une page',
        cue: 'Livre ouvert sur mon bureau',
        craving: 'Me faire un thé',
        response: 'Lire juste le premier paragraphe',
        reward: 'Noter mes insights',
        reminderTime: '20:00',
      ),

      HabitTemplate(
        name: 'Apprendre une langue',
        category: 'Apprentissage',
        description: '15 minutes sur Duolingo/Babbel',
        identityStatement: 'Je suis quelqu\'un qui apprend constamment',
        twoMinuteVersion: 'Réviser 3 mots',
        cue: 'Ouvrir l\'app après le petit-déjeuner',
        craving: 'Gagner des points',
        response: 'Faire une leçon de 5 min minimum',
        reward: 'Voir ma progression',
        reminderTime: '08:30',
      ),

      HabitTemplate(
        name: 'Écouter un podcast',
        category: 'Apprentissage',
        description: 'Apprendre pendant les trajets',
        identityStatement: 'Je suis quelqu\'un de curieux',
        twoMinuteVersion: 'Lancer un épisode',
        cue: 'Monter dans ma voiture',
        craving: 'Découvrir de nouvelles idées',
        response: 'Écouter au moins 10 minutes',
        reward: 'Partager ce que j\'ai appris',
        reminderTime: '08:00',
      ),

      // PRODUCTIVITÉ
      HabitTemplate(
        name: 'Planifier ma journée',
        category: 'Productivité',
        description: 'Liste des 3 priorités',
        identityStatement: 'Je suis quelqu\'un d\'organisé',
        twoMinuteVersion: 'Noter une tâche',
        cue: 'Ouvrir mon planner le matin',
        craving: 'Utiliser des stickers colorés',
        response: 'Écrire mes 3 top priorités',
        reward: 'Me sentir en contrôle',
        reminderTime: '06:30',
      ),

      HabitTemplate(
        name: 'Session Pomodoro',
        category: 'Productivité',
        description: '25 min de travail concentré',
        identityStatement: 'Je suis quelqu\'un de concentré',
        twoMinuteVersion: 'Lancer le timer',
        cue: 'Bloquer un créneau dans l\'agenda',
        craving: 'Mode focus activé',
        response: 'Fermer toutes les distractions',
        reward: 'Pause de 5 minutes',
        reminderTime: '09:00',
      ),

      HabitTemplate(
        name: 'Ranger mon bureau',
        category: 'Productivité',
        description: '5 minutes de rangement',
        identityStatement: 'Je suis quelqu\'un d\'organisé',
        twoMinuteVersion: 'Ranger une chose',
        cue: 'À la fin de ma journée de travail',
        craving: 'Mettre de la musique',
        response: 'Tout remettre à sa place',
        reward: 'Bureau clean pour demain',
        reminderTime: '18:00',
      ),

      // SOCIAL
      HabitTemplate(
        name: 'Appeler un proche',
        category: 'Social',
        description: 'Garder le contact avec famille/amis',
        identityStatement: 'Je suis quelqu\'un qui cultive ses relations',
        twoMinuteVersion: 'Envoyer un message',
        cue: 'Rappel dans le calendrier',
        craving: 'Profiter d\'un moment de connexion',
        response: 'Appeler pendant ma pause',
        reward: 'Renforcer nos liens',
        reminderTime: '14:00',
      ),

      HabitTemplate(
        name: 'Complimenter quelqu\'un',
        category: 'Social',
        description: 'Faire un compliment sincère',
        identityStatement: 'Je suis quelqu\'un de bienveillant',
        twoMinuteVersion: 'Sourire à quelqu\'un',
        cue: 'Première interaction de la journée',
        craving: 'Faire plaisir',
        response: 'Trouver quelque chose de positif',
        reward: 'Voir la personne sourire',
        reminderTime: '10:00',
      ),

      // CRÉATIVITÉ
      HabitTemplate(
        name: 'Écrire 3 pages',
        category: 'Créativité',
        description: 'Morning pages ou journal créatif',
        identityStatement: 'Je suis quelqu\'un de créatif',
        twoMinuteVersion: 'Écrire une phrase',
        cue: 'Cahier ouvert sur mon bureau',
        craving: 'Boire mon café en écrivant',
        response: 'Écrire sans me censurer',
        reward: 'Clarifier mes pensées',
        reminderTime: '06:00',
      ),

      HabitTemplate(
        name: 'Dessiner 15 minutes',
        category: 'Créativité',
        description: 'Croquis, doodles ou dessin',
        identityStatement: 'Je suis un artiste',
        twoMinuteVersion: 'Faire un trait',
        cue: 'Matériel de dessin visible',
        craving: 'Mettre de la musique inspirante',
        response: 'Dessiner sans jugement',
        reward: 'Me détendre créativement',
        reminderTime: '19:00',
      ),

      // FINANCE
      HabitTemplate(
        name: 'Suivre mes dépenses',
        category: 'Finance',
        description: 'Noter chaque dépense du jour',
        identityStatement: 'Je suis quelqu\'un qui gère bien son argent',
        twoMinuteVersion: 'Ouvrir l\'app de budget',
        cue: 'À la fin de chaque journée',
        craving: 'Voir mes économies grandir',
        response: 'Catégoriser mes dépenses',
        reward: 'Être conscient de mes finances',
        reminderTime: '21:30',
      ),

      HabitTemplate(
        name: 'Économiser 5€ par jour',
        category: 'Finance',
        description: 'Mettre de l\'argent de côté',
        identityStatement: 'Je suis quelqu\'un d\'économe',
        twoMinuteVersion: 'Virement de 5€',
        cue: 'Notification bancaire',
        craving: 'Atteindre mon objectif d\'épargne',
        response: 'Virement automatique',
        reward: 'Voir mon compte épargne augmenter',
        reminderTime: '12:00',
      ),
    ];
  }

  /// Récupère les templates par catégorie
  static List<HabitTemplate> getTemplatesByCategory(String category) {
    return getAllTemplates().where((t) => t.category == category).toList();
  }

  /// Convertit un template en Habit
  static Habit templateToHabit(HabitTemplate template) {
    final categoryColor = AppColors.categoryColors[template.category];

    return Habit(
      id: 0, // Sera assigné par la DB
      name: template.name,
      description: template.description,
      category: template.category,
      frequency: 'Quotidien',
      identityStatement: template.identityStatement,
      twoMinuteVersion: template.twoMinuteVersion,
      cue: template.cue,
      craving: template.craving,
      response: template.response,
      reward: template.reward,
      reminderEnabled: template.reminderTime != null,
      reminderTime: template.reminderTime,
      color: categoryColor?.toARGB32(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

/// Modèle de template d'habitude
class HabitTemplate {
  final String name;
  final String category;
  final String description;
  final String identityStatement;
  final String twoMinuteVersion;
  final String cue;
  final String craving;
  final String response;
  final String reward;
  final String? reminderTime;

  const HabitTemplate({
    required this.name,
    required this.category,
    required this.description,
    required this.identityStatement,
    required this.twoMinuteVersion,
    required this.cue,
    required this.craving,
    required this.response,
    required this.reward,
    this.reminderTime,
  });
}
