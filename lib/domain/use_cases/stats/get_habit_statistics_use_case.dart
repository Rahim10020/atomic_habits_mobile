import '../../../core/errors/failures.dart';
import '../../models/habit_log.dart';
import '../../repositories/habit_repository.dart';

/// Use case pour récupérer les statistiques d'une habitude
class GetHabitStatisticsUseCase {
  final HabitRepository _repository;

  GetHabitStatisticsUseCase(this._repository);

  /// Récupère les statistiques d'une habitude
  Future<Result<HabitStatistics>> execute(int habitId) async {
    try {
      // Vérifier que l'habitude existe
      final habit = await _repository.getHabitById(habitId);
      if (habit == null) {
        return NotFoundFailure(
          message: 'Habitude avec l\'ID $habitId introuvable',
        );
      }

      // Récupérer les statistiques
      final stats = await _repository.getHabitStatistics(habitId);

      return Success(stats);
    } catch (e, stackTrace) {
      return DatabaseFailure(
        message: 'Erreur lors de la récupération des statistiques',
        exception: e is Exception ? e : Exception(e.toString()),
        stackTrace: stackTrace,
      );
    }
  }

  /// Récupère l'historique de complétion
  Future<Result<Map<DateTime, bool>>> executeHistory({
    required int habitId,
    int days = 365,
  }) async {
    try {
      final history = await _repository.getCompletionHistory(habitId, days);
      return Success(history);
    } catch (e, stackTrace) {
      return DatabaseFailure(
        message: 'Erreur lors de la récupération de l\'historique',
        exception: e is Exception ? e : Exception(e.toString()),
        stackTrace: stackTrace,
      );
    }
  }

  /// Récupère le streak actuel
  Future<Result<int>> executeCurrentStreak(int habitId) async {
    try {
      final streak = await _repository.getCurrentStreak(habitId);
      return Success(streak);
    } catch (e, stackTrace) {
      return DatabaseFailure(
        message: 'Erreur lors de la récupération du streak',
        exception: e is Exception ? e : Exception(e.toString()),
        stackTrace: stackTrace,
      );
    }
  }
}
