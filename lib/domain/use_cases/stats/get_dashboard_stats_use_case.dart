import '../../../core/errors/failures.dart';
import '../../repositories/habit_repository.dart';

// Statistiques du dashboard
class DashboardStats {
  final int completedCount;
  final int pendingCount;
  final int totalHabits;
  final double completionRate;

  DashboardStats({
    required this.completedCount,
    required this.pendingCount,
    required this.totalHabits,
    required this.completionRate,
  });

  @override
  String toString() =>
      'DashboardStats(completed: $completedCount, pending: $pendingCount, total: $totalHabits, rate: $completionRate%)';
}

// Use case pour récupérer les statistiques du dashboard
class GetDashboardStatsUseCase {
  final HabitRepository _repository;

  GetDashboardStatsUseCase(this._repository);

  // Récupère les statistiques du jour
  Future<Result<DashboardStats>> execute() async {
    try {
      final results = await Future.wait([
        _repository.getTodayCompletedCount(),
        _repository.getTodayPendingCount(),
      ]);
      final completedCount = results[0];
      final pendingCount = results[1];
      final totalHabits = completedCount + pendingCount;

      final completionRate = totalHabits > 0
          ? (completedCount / totalHabits) * 100
          : 0.0;

      final stats = DashboardStats(
        completedCount: completedCount,
        pendingCount: pendingCount,
        totalHabits: totalHabits,
        completionRate: completionRate,
      );

      return Success(stats);
    } catch (e, stackTrace) {
      return DatabaseFailure(
        message: 'Erreur lors de la récupération des statistiques',
        exception: e is Exception ? e : Exception(e.toString()),
        stackTrace: stackTrace,
      );
    }
  }
}
