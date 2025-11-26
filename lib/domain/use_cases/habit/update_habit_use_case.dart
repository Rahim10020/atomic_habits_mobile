import '../../../core/errors/failures.dart';
import '../../../core/utils/validators.dart';
import '../../models/habit.dart';
import '../../repositories/habit_repository.dart';

// Use case pour mettre à jour une habitude existante
class UpdateHabitUseCase {
  final HabitRepository _repository;

  UpdateHabitUseCase(this._repository);

  // Exécute la mise à jour d'une habitude
  //
  // Valide les données avant de les enregistrer.
  // Retourne un [Result] contenant void ou une erreur.
  Future<Result<void>> execute(Habit habit) async {
    try {
      // Vérifier que l'habitude existe
      final existingHabit = await _repository.getHabitById(habit.id);
      if (existingHabit == null) {
        return NotFoundFailure(
          message: 'Habitude avec l\'ID ${habit.id} introuvable',
        );
      }

      // Validation
      final validationError = _validate(habit);
      if (validationError != null) {
        return ValidationFailure(message: validationError);
      }

      // Mise à jour avec timestamp
      final updatedHabit = habit.copyWith(updatedAt: DateTime.now());

      await _repository.updateHabit(updatedHabit);

      return const Success(null);
    } catch (e, stackTrace) {
      return DatabaseFailure(
        message: 'Erreur lors de la mise à jour de l\'habitude',
        exception: e is Exception ? e : Exception(e.toString()),
        stackTrace: stackTrace,
      );
    }
  }

  // Valide les données de l'habitude
  String? _validate(Habit habit) {
    // Valider le nom
    final nameError = Validators.habitName(habit.name);
    if (nameError != null) return nameError;

    // Valider la description si présente
    if (habit.description != null) {
      final descError = Validators.description(habit.description);
      if (descError != null) return descError;
    }

    // Valider le reminder time si présent
    if (habit.reminderTime != null) {
      final timeError = Validators.timeFormat(habit.reminderTime);
      if (timeError != null) return timeError;
    }

    return null;
  }
}
