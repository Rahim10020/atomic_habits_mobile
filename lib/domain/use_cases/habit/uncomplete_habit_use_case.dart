import '../../../core/errors/failures.dart';
import '../../repositories/habit_repository.dart';

/// Use case pour annuler la complétion d'une habitude
class UncompleteHabitUseCase {
  final HabitRepository _repository;

  UncompleteHabitUseCase(this._repository);

  /// Exécute l'annulation de la complétion d'une habitude
  ///
  /// Params:
  /// - [habitId]: ID de l'habitude
  /// - [date]: Date de la complétion à annuler
  ///
  /// Retourne un [Result] contenant void ou une erreur.
  Future<Result<void>> execute({
    required int habitId,
    required DateTime date,
  }) async {
    try {
      // Vérifier que l'habitude existe
      final habit = await _repository.getHabitById(habitId);
      if (habit == null) {
        return NotFoundFailure(
          message: 'Habitude avec l\'ID $habitId introuvable',
        );
      }

      // Normaliser la date (début de journée)
      final normalizedDate = DateTime(date.year, date.month, date.day);

      // Vérifier qu'il y a bien un log à cette date
      final existingLog = await _repository.getLogForHabitOnDate(
        habitId,
        normalizedDate,
      );

      if (existingLog == null) {
        return ValidationFailure(
          message: 'Aucune complétion trouvée pour cette date',
        );
      }

      // Annulation
      await _repository.uncompleteHabit(habitId, normalizedDate);

      return const Success(null);
    } catch (e, stackTrace) {
      return DatabaseFailure(
        message: 'Erreur lors de l\'annulation de la complétion',
        exception: e is Exception ? e : Exception(e.toString()),
        stackTrace: stackTrace,
      );
    }
  }
}
