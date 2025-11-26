import 'package:drift/drift.dart';

class Habits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().nullable()();
  TextColumn get category => text()();
  TextColumn get frequency => text()(); // 'daily', 'weekly', 'custom'
  TextColumn get identityStatement => text().nullable()(); // "Je suis quelqu'un qui..."
  TextColumn get twoMinuteVersion => text().nullable()(); // Version mini de l'habitude
  
  // Four Laws of Behavior Change
  TextColumn get cue => text().nullable()(); // 1st Law: Make it Obvious
  TextColumn get craving => text().nullable()(); // 2nd Law: Make it Attractive
  TextColumn get response => text().nullable()(); // 3rd Law: Make it Easy
  TextColumn get reward => text().nullable()(); // 4th Law: Make it Satisfying
  
  // Notification settings
  BoolColumn get reminderEnabled => boolean().withDefault(const Constant(false))();
  TextColumn get reminderTime => text().nullable()(); // Format: HH:mm
  
  // Metadata
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get color => integer().nullable()(); // Color value for the habit
  
  // Tracking
  IntColumn get currentStreak => integer().withDefault(const Constant(0))();
  IntColumn get longestStreak => integer().withDefault(const Constant(0))();
  IntColumn get totalCompletions => integer().withDefault(const Constant(0))();
}

// Model class for working with habits
class Habit {
  final int id;
  final String name;
  final String? description;
  final String category;
  final String frequency;
  final String? identityStatement;
  final String? twoMinuteVersion;
  final String? cue;
  final String? craving;
  final String? response;
  final String? reward;
  final bool reminderEnabled;
  final String? reminderTime;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final int? color;
  final int currentStreak;
  final int longestStreak;
  final int totalCompletions;
  
  Habit({
    required this.id,
    required this.name,
    this.description,
    required this.category,
    required this.frequency,
    this.identityStatement,
    this.twoMinuteVersion,
    this.cue,
    this.craving,
    this.response,
    this.reward,
    this.reminderEnabled = false,
    this.reminderTime,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.color,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalCompletions = 0,
  });
  
  Habit copyWith({
    int? id,
    String? name,
    String? description,
    String? category,
    String? frequency,
    String? identityStatement,
    String? twoMinuteVersion,
    String? cue,
    String? craving,
    String? response,
    String? reward,
    bool? reminderEnabled,
    String? reminderTime,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    int? color,
    int? currentStreak,
    int? longestStreak,
    int? totalCompletions,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      frequency: frequency ?? this.frequency,
      identityStatement: identityStatement ?? this.identityStatement,
      twoMinuteVersion: twoMinuteVersion ?? this.twoMinuteVersion,
      cue: cue ?? this.cue,
      craving: craving ?? this.craving,
      response: response ?? this.response,
      reward: reward ?? this.reward,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      color: color ?? this.color,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalCompletions: totalCompletions ?? this.totalCompletions,
    );
  }
}
