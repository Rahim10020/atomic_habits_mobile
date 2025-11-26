import '../../../core/errors/failures.dart';
import '../../models/habit.dart';
import '../../repositories/habit_repository.dart';

/// Use case pour récupérer les habitudes
class GetHabitsUseCase {
  final HabitRepository _repository;

  GetHabitsUseCase(this._repository);

  /// Récupère toutes les habitudes actives
  Future<Result<List<Habit>>> execute() async {
    try {
      final habits = await _repository.getActiveHabits();
      return Success(habits);
    } catch (e, stackTrace) {
      return DatabaseFailure(
        message: 'Erreur lors de la récupération des habitudes',
        exception: e is Exception ? e : Exception(e.toString()),
        stackTrace: stackTrace,
      );
    }
  }

  /// Récupère toutes les habitudes (actives et inactives)
  Future<Result<List<Habit>>> executeAll() async {
    try {
      final habits = await _repository.getAllHabits();
      return Success(habits);
    } catch (e, stackTrace) {
      return DatabaseFailure(
        message: 'Erreur lors de la récupération des habitudes',
        exception: e is Exception ? e : Exception(e.toString()),
        stackTrace: stackTrace,
      );
    }
  }

  /// Récupère les habitudes d'une catégorie
  Future<Result<List<Habit>>> executeByCategory(String category) async {
    try {
      final habits = await _repository.getHabitsByCategory(category);
      return Success(habits);
    } catch (e, stackTrace) {
      return DatabaseFailure(
        message: 'Erreur lors de la récupération des habitudes par catégorie',
        exception: e is Exception ? e : Exception(e.toString()),
        stackTrace: stackTrace,
      );
    }
  }

  /// Récupère une habitude par ID
  Future<Result<Habit>> executeById(int habitId) async {
    try {
      final habit = await _repository.getHabitById(habitId);
      if (habit == null) {
        return NotFoundFailure(
          message: 'Habitude avec l\'ID $habitId introuvable',
        );
      }
      return Success(habit);
    } catch (e, stackTrace) {
      return DatabaseFailure(
        message: 'Erreur lors de la récupération de l\'habitude',
        exception: e is Exception ? e : Exception(e.toString()),
        stackTrace: stackTrace,
      );
    }
  }
}
