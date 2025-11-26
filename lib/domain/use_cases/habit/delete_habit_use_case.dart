import '../../../core/errors/failures.dart';
import '../../repositories/habit_repository.dart';

// Use case pour supprimer une habitude
class DeleteHabitUseCase {
  final HabitRepository _repository;

  DeleteHabitUseCase(this._repository);

  // Exécute la suppression d'une habitude
  //
  // Retourne un [Result] contenant void ou une erreur.
  Future<Result<void>> execute(int habitId) async {
    try {
      // Vérifier que l'habitude existe
      final habit = await _repository.getHabitById(habitId);
      if (habit == null) {
        return NotFoundFailure(
          message: 'Habitude avec l\'ID $habitId introuvable',
        );
      }

      // Suppression (suppression en cascade des logs dans la DB)
      await _repository.deleteHabit(habitId);

      return const Success(null);
    } catch (e, stackTrace) {
      return DatabaseFailure(
        message: 'Erreur lors de la suppression de l\'habitude',
        exception: e is Exception ? e : Exception(e.toString()),
        stackTrace: stackTrace,
      );
    }
  }

  // Exécute une suppression soft (marque comme inactive)
  Future<Result<void>> executeSoft(int habitId) async {
    try {
      // Vérifier que l'habitude existe
      final habit = await _repository.getHabitById(habitId);
      if (habit == null) {
        return NotFoundFailure(
          message: 'Habitude avec l\'ID $habitId introuvable',
        );
      }

      // Suppression soft
      await _repository.softDeleteHabit(habitId);

      return const Success(null);
    } catch (e, stackTrace) {
      return DatabaseFailure(
        message: 'Erreur lors de la désactivation de l\'habitude',
        exception: e is Exception ? e : Exception(e.toString()),
        stackTrace: stackTrace,
      );
    }
  }
}
