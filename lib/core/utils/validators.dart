// Validateurs pour les formulaires et les données

class Validators {
  // Valide qu'une chaîne n'est pas vide
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Ce champ'} est requis';
    }
    return null;
  }

  // Valide la longueur minimale
  static String? minLength(String? value, int min, {String? fieldName}) {
    if (value == null || value.isEmpty) return null;
    if (value.length < min) {
      return '${fieldName ?? 'Ce champ'} doit contenir au moins $min caractères';
    }
    return null;
  }

  // Valide la longueur maximale
  static String? maxLength(String? value, int max, {String? fieldName}) {
    if (value == null || value.isEmpty) return null;
    if (value.length > max) {
      return '${fieldName ?? 'Ce champ'} ne peut pas dépasser $max caractères';
    }
    return null;
  }

  // Valide le nom d'une habitude
  static String? habitName(String? value) {
    final requiredError = required(value, fieldName: 'Le nom');
    if (requiredError != null) return requiredError;

    final minError = minLength(value, 2, fieldName: 'Le nom');
    if (minError != null) return minError;

    final maxError = maxLength(value, 100, fieldName: 'Le nom');
    if (maxError != null) return maxError;

    return null;
  }

  // Valide une description
  static String? description(String? value) {
    if (value == null || value.isEmpty) return null;

    final maxError = maxLength(value, 500, fieldName: 'La description');
    if (maxError != null) return maxError;

    return null;
  }

  // Valide une note de log
  static String? logNote(String? value) {
    if (value == null || value.isEmpty) return null;

    final maxError = maxLength(value, 1000, fieldName: 'La note');
    if (maxError != null) return maxError;

    return null;
  }

  // Valide un format de temps HH:mm
  static String? timeFormat(String? value) {
    if (value == null || value.isEmpty) return null;

    final timeRegex = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');
    if (!timeRegex.hasMatch(value)) {
      return 'Format invalide. Utilisez HH:mm';
    }

    return null;
  }

  // Valide un nombre dans une plage
  static String? range(int? value, int min, int max, {String? fieldName}) {
    if (value == null) {
      return '${fieldName ?? 'Ce champ'} est requis';
    }

    if (value < min || value > max) {
      return '${fieldName ?? 'La valeur'} doit être entre $min et $max';
    }

    return null;
  }

  // Valide un mood (1-5)
  static String? mood(int? value) {
    return range(value, 1, 5, fieldName: 'L\'humeur');
  }

  // Combine plusieurs validateurs
  static String? combine(
    String? value,
    List<String? Function(String?)> validators,
  ) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) return error;
    }
    return null;
  }
}

// Extension pour faciliter la validation
extension ValidatorExtension on String? {
  String? validate(List<String? Function(String?)> validators) {
    return Validators.combine(this, validators);
  }
}
