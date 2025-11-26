import '../../core/utils/habit_templates.dart';

/// Repository pour gérer les templates d'habitudes
abstract class HabitTemplatesRepository {
  /// Récupère tous les templates disponibles
  List<HabitTemplate> getAllTemplates();

  /// Récupère les templates par catégorie
  List<HabitTemplate> getTemplatesByCategory(String category);

  /// Recherche des templates par nom ou description
  List<HabitTemplate> searchTemplates(String query);
}

/// Implémentation du repository de templates
class HabitTemplatesRepositoryImpl implements HabitTemplatesRepository {
  @override
  List<HabitTemplate> getAllTemplates() {
    return HabitTemplates.getAllTemplates();
  }

  @override
  List<HabitTemplate> getTemplatesByCategory(String category) {
    return HabitTemplates.getTemplatesByCategory(category);
  }

  @override
  List<HabitTemplate> searchTemplates(String query) {
    final allTemplates = getAllTemplates();
    final lowercaseQuery = query.toLowerCase();

    return allTemplates.where((template) {
      return template.name.toLowerCase().contains(lowercaseQuery) ||
          template.description.toLowerCase().contains(lowercaseQuery) ||
          template.category.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}
