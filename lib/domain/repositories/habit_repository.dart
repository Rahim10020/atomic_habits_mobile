import '../models/habit.dart';
import '../models/habit_log.dart';

abstract class HabitRepository {
  // Habit CRUD
  Future<List<Habit>> getAllHabits();
  Future<List<Habit>> getActiveHabits();
  Future<Habit?> getHabitById(int id);
  Future<List<Habit>> getHabitsByCategory(String category);
  Future<int> createHabit(Habit habit);
  Future<void> updateHabit(Habit habit);
  Future<void> deleteHabit(int id);
  Future<void> softDeleteHabit(int id);
  
  // Habit Logs
  Future<List<HabitLog>> getLogsForHabit(int habitId);
  Future<HabitLog?> getLogForHabitOnDate(int habitId, DateTime date);
  Future<void> completeHabit(int habitId, {String? note, int? mood, bool? wasEasy});
  Future<void> uncompleteHabit(int habitId, DateTime date);
  
  // Statistics
  Future<Map<DateTime, bool>> getCompletionHistory(int habitId, int days);
  Future<int> getCurrentStreak(int habitId);
  Future<HabitStatistics> getHabitStatistics(int habitId);
  
  // Dashboard data
  Future<int> getTodayCompletedCount();
  Future<int> getTodayPendingCount();
  Future<List<Habit>> getTodayHabits();
}
