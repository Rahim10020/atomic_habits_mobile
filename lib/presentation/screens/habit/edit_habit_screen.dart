import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditHabitScreen extends ConsumerWidget {
  final int habitId;
  
  const EditHabitScreen({super.key, required this.habitId});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier l\'habitude'),
      ),
      body: const Center(
        child: Text('Edit Habit Screen - À implémenter'),
      ),
    );
  }
}
