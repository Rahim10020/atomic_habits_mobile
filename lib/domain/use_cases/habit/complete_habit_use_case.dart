import '../../../core/errors/failures.dart';
import '../../../core/utils/validators.dart';
import '../../repositories/habit_repository.dart';

// Use case pour compléter une habitude
class CompleteHabitUseCase {
  final HabitRepository _repository;

  CompleteHabitUseCase(this._repository);

  /// Exécute la complétion d'une habitude
  ///
  /// Params:
  /// - [habitId]: ID de l'habitude à compléter
  /// - [note]: Note optionnelle
  /// - [mood]: Humeur (1-5)
  /// - [wasEasy]: Si c'était facile (optionnel)
  ///
  /// Retourne un [Result] contenant void ou une erreur.
  Future<Result<void>> execute({
    required int habitId,
    String? note,
    int? mood,
    bool? wasEasy,
  }) async {
    try {
      // Vérifier que l'habitude existe
      final habit = await _repository.getHabitById(habitId);
      if (habit == null) {
        return NotFoundFailure(
          message: 'Habitude avec l\'ID $habitId introuvable',
        );
      }

      // Validation de la note
      if (note != null) {
        final noteError = Validators.logNote(note);
        if (noteError != null) {
          return ValidationFailure(message: noteError);
        }
      }

      // Validation du mood
      if (mood != null) {
        final moodError = Validators.mood(mood);
        if (moodError != null) {
          return ValidationFailure(message: moodError);
        }
      }

      // Vérifier si déjà complété aujourd'hui
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final existingLog = await _repository.getLogForHabitOnDate(
        habitId,
        today,
      );

      if (existingLog != null) {
        return ValidationFailure(
          message: 'Habitude déjà complétée aujourd\'hui',
        );
      }

      // Complétion
      await _repository.completeHabit(
        habitId,
        note: note,
        mood: mood,
        wasEasy: wasEasy,
      );

      return const Success(null);
    } catch (e, stackTrace) {
      return DatabaseFailure(
        message: 'Erreur lors de la complétion de l\'habitude',
        exception: e is Exception ? e : Exception(e.toString()),
        stackTrace: stackTrace,
      );
    }
  }
}
