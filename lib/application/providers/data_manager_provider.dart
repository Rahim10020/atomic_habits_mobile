import 'package:atomic_habits_mobile/domain/repositories/habit_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/sample_data.dart';
import 'habit_provider.dart';

// Provider pour vérifier si c'est le premier lancement
final firstLaunchProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('first_launch') ?? true;
});

// Provider pour charger les données d'exemple
final sampleDataLoaderProvider = FutureProvider<void>((ref) async {
  final isFirstLaunch = await ref.watch(firstLaunchProvider.future);

  if (!isFirstLaunch) return;

  final repository = ref.watch(habitRepositoryProvider);
  final sampleHabits = SampleData.getSampleHabits();

  // Charger les habitudes d'exemple
  final existingNames = (await repository.getAllHabits())
      .map((habit) => habit.name.trim().toLowerCase())
      .toSet();

  for (var habit in sampleHabits) {
    final normalizedName = habit.name.trim().toLowerCase();
    if (existingNames.contains(normalizedName)) continue;

    await repository.createHabit(habit);
    existingNames.add(normalizedName);
  }

  // Marquer que l'app a été lancée
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('first_launch', false);

  // Rafraîchir les habitudes
  ref.invalidate(habitsProvider);
});

// Provider pour réinitialiser les données (utile pour les tests)
class DataManager extends StateNotifier<AsyncValue<void>> {
  final HabitRepository _repository;
  final Ref _ref;

  DataManager(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<void> loadSampleData() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final sampleHabits = SampleData.getSampleHabits();

      for (var habit in sampleHabits) {
        await _repository.createHabit(habit);
      }

      _ref.invalidate(habitsProvider);
    });
  }

  Future<void> clearAllData() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final habits = await _repository.getAllHabits();

      for (var habit in habits) {
        await _repository.deleteHabit(habit.id);
      }

      _ref.invalidate(habitsProvider);
    });
  }

  Future<void> resetToSampleData() async {
    await clearAllData();
    await loadSampleData();
  }
}

final dataManagerProvider =
    StateNotifierProvider<DataManager, AsyncValue<void>>((ref) {
      final repository = ref.watch(habitRepositoryProvider);
      return DataManager(repository, ref);
    });
