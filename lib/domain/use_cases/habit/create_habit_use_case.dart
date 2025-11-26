import '../../../core/errors/failures.dart';
import '../../../core/utils/validators.dart';
import '../../models/habit.dart';
import '../../repositories/habit_repository.dart';

// Use case pour créer une nouvelle habitude
class CreateHabitUseCase {
  final HabitRepository _repository;

  CreateHabitUseCase(this._repository);

  // Exécute la création d'une habitude
  //
  // Valide les données avant de les enregistrer.
  // Retourne un [Result] contenant l'ID de l'habitude créée ou une erreur.
  Future<Result<int>> execute(Habit habit) async {
    try {
      // Validation
      final validationError = _validate(habit);
      if (validationError != null) {
        return ValidationFailure(message: validationError);
      }

      // Création
      final habitId = await _repository.createHabit(habit);

      return Success(habitId);
    } catch (e, stackTrace) {
      return DatabaseFailure(
        message: 'Erreur lors de la création de l\'habitude',
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
