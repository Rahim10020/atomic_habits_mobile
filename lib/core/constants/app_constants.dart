class AppConstants {
  // App Info
  static const String appName = 'Atomic Habits';
  static const String appVersion = '1.0.0';
  
  // Database
  static const String databaseName = 'atomic_habits.db';
  static const int databaseVersion = 1;
  
  // Notification
  static const String notificationChannelId = 'habit_reminders';
  static const String notificationChannelName = 'Rappels d\'habitudes';
  static const String notificationChannelDescription = 'Notifications pour vos habitudes quotidiennes';
  
  // Four Laws of Behavior Change (from Atomic Habits)
  static const List<String> fourLaws = [
    'Rendre évident',
    'Rendre attrayant',
    'Rendre facile',
    'Rendre satisfaisant',
  ];
  
  static const List<String> fourLawsDescriptions = [
    'Créez des signaux visuels clairs pour déclencher votre habitude',
    'Associez votre habitude à quelque chose que vous aimez',
    'Réduisez la friction et rendez l\'habitude aussi simple que possible',
    'Célébrez vos victoires et rendez l\'habitude gratifiante',
  ];
  
  static const List<String> fourLawsInversions = [
    'Rendre invisible',
    'Rendre peu attrayant',
    'Rendre difficile',
    'Rendre insatisfaisant',
  ];
  
  // Categories
  static const List<String> defaultCategories = [
    'Santé',
    'Productivité',
    'Apprentissage',
    'Social',
    'Créativité',
    'Finance',
    'Sport',
    'Mindfulness',
  ];
  
  // Frequency
  static const List<String> frequencies = [
    'Quotidien',
    'Hebdomadaire',
    'Personnalisé',
  ];
  
  // Atomic Habits Quotes
  static const List<String> quotes = [
    'Vous n\'atteignez pas le niveau de vos objectifs. Vous tombez au niveau de vos systèmes.',
    'Chaque action que vous prenez est un vote pour le type de personne que vous souhaitez devenir.',
    'Les habitudes sont l\'intérêt composé de l\'amélioration de soi.',
    'La plus grande menace au succès n\'est pas l\'échec mais l\'ennui.',
    'Vous ne faites pas monter au niveau de vos objectifs. Vous tombez au niveau de vos systèmes.',
    'Le but n\'est pas de lire un livre, le but est de devenir un lecteur.',
    'Les progrès sont progressifs, les résultats sont dramatiques.',
    'L\'amélioration de 1% n\'est pas particulièrement notable, mais elle peut être bien plus significative.',
  ];
  
  // Identity Statements
  static const Map<String, String> identityStatements = {
    'Santé': 'Je suis quelqu\'un qui prend soin de sa santé',
    'Productivité': 'Je suis quelqu\'un d\'organisé et productif',
    'Apprentissage': 'Je suis quelqu\'un qui apprend constamment',
    'Social': 'Je suis quelqu\'un qui cultive des relations significatives',
    'Créativité': 'Je suis quelqu\'un de créatif et innovant',
    'Finance': 'Je suis quelqu\'un qui gère bien son argent',
    'Sport': 'Je suis un athlète',
    'Mindfulness': 'Je suis quelqu\'un de présent et conscient',
  };
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // UI Constants
  static const double borderRadius = 16.0;
  static const double cardElevation = 2.0;
  static const double iconSize = 24.0;
  static const double spacing = 16.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
}
