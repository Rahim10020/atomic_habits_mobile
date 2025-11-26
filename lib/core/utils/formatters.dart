import 'package:intl/intl.dart';

// Formatters pour l'affichage des données

class Formatters {
  // Formate un nombre avec séparateurs de milliers
  static String number(int value) {
    final formatter = NumberFormat('#,###', 'fr_FR');
    return formatter.format(value);
  }

  // Formate un pourcentage
  static String percentage(double value, {int decimals = 0}) {
    return '${value.toStringAsFixed(decimals)}%';
  }

  // Formate une durée en texte lisible
  static String duration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} jour${duration.inDays > 1 ? 's' : ''}';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} heure${duration.inHours > 1 ? 's' : ''}';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} minute${duration.inMinutes > 1 ? 's' : ''}';
    } else {
      return '${duration.inSeconds} seconde${duration.inSeconds > 1 ? 's' : ''}';
    }
  }

  // Formate un streak
  static String streak(int days) {
    if (days == 0) return 'Pas de série';
    if (days == 1) return '1 jour';
    return '$days jours';
  }

  // Formate une date relative (Aujourd'hui, Hier, etc.)
  static String relativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateDay = DateTime(date.year, date.month, date.day);

    if (dateDay == today) {
      return "Aujourd'hui";
    } else if (dateDay == yesterday) {
      return 'Hier';
    } else if (dateDay.isAfter(today.subtract(const Duration(days: 7)))) {
      return DateFormat('EEEE', 'fr_FR').format(date);
    } else if (dateDay.year == now.year) {
      return DateFormat('d MMMM', 'fr_FR').format(date);
    } else {
      return DateFormat('d MMM yyyy', 'fr_FR').format(date);
    }
  }

  // Formate un temps (HH:mm)
  static String time(String timeString) {
    try {
      final parts = timeString.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return timeString;
    }
  }

  // Formate un mood en emoji
  static String moodEmoji(int mood) {
    return switch (mood) {
      1 => '😢',
      2 => '😕',
      3 => '😐',
      4 => '🙂',
      5 => '😄',
      _ => '😐',
    };
  }

  // Formate un mood en texte
  static String moodText(int mood) {
    return switch (mood) {
      1 => 'Très difficile',
      2 => 'Difficile',
      3 => 'Moyen',
      4 => 'Facile',
      5 => 'Très facile',
      _ => 'Non défini',
    };
  }

  // Formate une fréquence
  static String frequency(String frequency) {
    return switch (frequency) {
      'Quotidien' => 'Tous les jours',
      'Hebdomadaire' => 'Une fois par semaine',
      'Personnalisé' => 'Fréquence personnalisée',
      _ => frequency,
    };
  }

  // Formate un message de milestone
  static String? milestone(int days) {
    if (days == 7) return '🎉 Une semaine complète !';
    if (days == 14) return '🔥 Deux semaines de suite !';
    if (days == 21) return '💪 21 jours - Une habitude se forme !';
    if (days == 30) return '🏆 Un mois complet !';
    if (days == 60) return '⭐ Deux mois incroyables !';
    if (days == 90) return '🌟 90 jours - Vous êtes une machine !';
    if (days == 100) return '💯 Centenaire ! Vous êtes légendaire !';
    if (days == 180) return '🎯 Six mois de persévérance !';
    if (days == 365) return '👑 UN AN ! Vous avez transformé votre vie !';
    return null;
  }

  // Formate un message d'encouragement
  static String encouragement(int completionRate) {
    if (completionRate >= 90) {
      return 'Incroyable ! Vous êtes exceptionnel ! 🌟';
    } else if (completionRate >= 75) {
      return 'Excellent travail ! Continuez comme ça ! 💪';
    } else if (completionRate >= 50) {
      return 'Bon rythme ! Vous progressez bien ! 👍';
    } else if (completionRate >= 25) {
      return 'Continuez vos efforts ! Chaque jour compte ! 🔥';
    } else {
      return 'Un nouveau départ commence maintenant ! 🚀';
    }
  }
}
