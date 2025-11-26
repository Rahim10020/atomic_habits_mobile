import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/habit_templates_repository.dart';
import '../../core/utils/habit_templates.dart';

/// Provider pour le repository de templates
final habitTemplatesRepositoryProvider = Provider<HabitTemplatesRepository>((
  ref,
) {
  return HabitTemplatesRepositoryImpl();
});

/// Provider pour récupérer tous les templates
final allHabitTemplatesProvider = Provider<List<HabitTemplate>>((ref) {
  final repository = ref.watch(habitTemplatesRepositoryProvider);
  return repository.getAllTemplates();
});

/// Provider pour récupérer les templates par catégorie
final habitTemplatesByCategoryProvider =
    Provider.family<List<HabitTemplate>, String>((ref, category) {
      final repository = ref.watch(habitTemplatesRepositoryProvider);
      return repository.getTemplatesByCategory(category);
    });

/// Provider pour rechercher des templates
final searchHabitTemplatesProvider =
    Provider.family<List<HabitTemplate>, String>((ref, query) {
      final repository = ref.watch(habitTemplatesRepositoryProvider);
      return repository.searchTemplates(query);
    });
