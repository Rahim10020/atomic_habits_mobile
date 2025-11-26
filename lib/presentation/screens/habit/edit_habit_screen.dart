import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../domain/models/habit.dart';
import '../../../application/providers/habit_provider.dart';

class EditHabitScreen extends ConsumerStatefulWidget {
  final int habitId;

  const EditHabitScreen({super.key, required this.habitId});

  @override
  ConsumerState<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends ConsumerState<EditHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _identityStatementController = TextEditingController();
  final _twoMinuteController = TextEditingController();
  final _cueController = TextEditingController();
  final _cravingController = TextEditingController();
  final _responseController = TextEditingController();
  final _rewardController = TextEditingController();

  String _selectedCategory = AppConstants.defaultCategories[0];
  String _selectedFrequency = AppConstants.frequencies[0];
  bool _reminderEnabled = false;
  TimeOfDay? _reminderTime;
  bool _isLoading = true;
  Habit? _originalHabit;

  @override
  void initState() {
    super.initState();
    _loadHabit();
  }

  Future<void> _loadHabit() async {
    final habitAsync = ref.read(habitProvider(widget.habitId));
    habitAsync.when(
      data: (habit) {
        if (habit != null) {
          setState(() {
            _originalHabit = habit;
            _nameController.text = habit.name;
            _descriptionController.text = habit.description ?? '';
            _identityStatementController.text = habit.identityStatement ?? '';
            _twoMinuteController.text = habit.twoMinuteVersion ?? '';
            _cueController.text = habit.cue ?? '';
            _cravingController.text = habit.craving ?? '';
            _responseController.text = habit.response ?? '';
            _rewardController.text = habit.reward ?? '';
            _selectedCategory = habit.category;
            _selectedFrequency = habit.frequency;
            _reminderEnabled = habit.reminderEnabled;

            if (habit.reminderTime != null) {
              final parts = habit.reminderTime!.split(':');
              _reminderTime = TimeOfDay(
                hour: int.parse(parts[0]),
                minute: int.parse(parts[1]),
              );
            }

            _isLoading = false;
          });
        }
      },
      loading: () {},
      error: (_, __) {
        setState(() {
          _isLoading = false;
        });
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _identityStatementController.dispose();
    _twoMinuteController.dispose();
    _cueController.dispose();
    _cravingController.dispose();
    _responseController.dispose();
    _rewardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Modifier l\'habitude')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_originalHabit == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Modifier l\'habitude')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: AppConstants.paddingMedium),
              const Text('Habitude introuvable'),
              const SizedBox(height: AppConstants.paddingMedium),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Retour'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier l\'habitude'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _showDeleteDialog,
            tooltip: 'Supprimer',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          children: [
            _buildBasicInfoSection(),
            const SizedBox(height: AppConstants.paddingLarge),
            _buildIdentitySection(),
            const SizedBox(height: AppConstants.paddingLarge),
            _buildFourLawsSection(),
            const SizedBox(height: AppConstants.paddingLarge),
            _buildReminderSection(),
            const SizedBox(height: AppConstants.paddingLarge),
            _buildActionButtons(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Informations de base', style: AppTextStyles.headlineSmall),
        const SizedBox(height: AppConstants.paddingMedium),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Nom de l\'habitude *',
            prefixIcon: Icon(Icons.title),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer un nom';
            }
            return null;
          },
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            prefixIcon: Icon(Icons.description),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          decoration: const InputDecoration(
            labelText: 'Catégorie',
            prefixIcon: Icon(Icons.category),
          ),
          items: AppConstants.defaultCategories.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.categoryColors[category],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(category),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCategory = value!;
            });
          },
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        DropdownButtonFormField<String>(
          value: _selectedFrequency,
          decoration: const InputDecoration(
            labelText: 'Fréquence',
            prefixIcon: Icon(Icons.calendar_today),
          ),
          items: AppConstants.frequencies.map((frequency) {
            return DropdownMenuItem(value: frequency, child: Text(frequency));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedFrequency = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildIdentitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Identité et Mini-habitude', style: AppTextStyles.headlineSmall),
        const SizedBox(height: AppConstants.paddingMedium),
        TextFormField(
          controller: _identityStatementController,
          decoration: const InputDecoration(
            labelText: 'Déclaration d\'identité',
            hintText: 'Je suis quelqu\'un qui...',
            prefixIcon: Icon(Icons.person),
          ),
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        TextFormField(
          controller: _twoMinuteController,
          decoration: const InputDecoration(
            labelText: 'Version 2 minutes',
            hintText: 'La version la plus simple',
            prefixIcon: Icon(Icons.bolt),
          ),
        ),
      ],
    );
  }

  Widget _buildFourLawsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Les 4 Lois du changement', style: AppTextStyles.headlineSmall),
        const SizedBox(height: AppConstants.paddingMedium),
        _buildLawField(
          controller: _cueController,
          label: '1. Rendre évident',
          hint: 'Comment allez-vous vous en souvenir ?',
          icon: Icons.visibility,
          color: AppColors.primary,
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        _buildLawField(
          controller: _cravingController,
          label: '2. Rendre attrayant',
          hint: 'Comment la rendre plus agréable ?',
          icon: Icons.favorite,
          color: AppColors.accent,
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        _buildLawField(
          controller: _responseController,
          label: '3. Rendre facile',
          hint: 'Comment la simplifier ?',
          icon: Icons.speed,
          color: AppColors.secondary,
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        _buildLawField(
          controller: _rewardController,
          label: '4. Rendre satisfaisant',
          hint: 'Comment vous récompenser ?',
          icon: Icons.star,
          color: AppColors.success,
        ),
      ],
    );
  }

  Widget _buildLawField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color color,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: color),
        labelStyle: TextStyle(color: color),
      ),
    );
  }

  Widget _buildReminderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Rappels', style: AppTextStyles.headlineSmall),
        const SizedBox(height: AppConstants.paddingMedium),
        SwitchListTile(
          title: const Text('Activer les rappels'),
          subtitle: const Text('Recevoir une notification quotidienne'),
          value: _reminderEnabled,
          onChanged: (value) {
            setState(() {
              _reminderEnabled = value;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
        if (_reminderEnabled) ...[
          const SizedBox(height: AppConstants.paddingMedium),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: Text(
              _reminderTime != null
                  ? 'À ${_reminderTime!.format(context)}'
                  : 'Choisir une heure',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: _reminderTime ?? TimeOfDay.now(),
              );
              if (time != null) {
                setState(() {
                  _reminderTime = time;
                });
              }
            },
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saveChanges,
            child: const Text('Enregistrer les modifications'),
          ),
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => context.pop(),
            child: const Text('Annuler'),
          ),
        ),
      ],
    );
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final categoryColor = AppColors.categoryColors[_selectedCategory];

    final updatedHabit = _originalHabit!.copyWith(
      name: _nameController.text,
      description: _descriptionController.text.isNotEmpty
          ? _descriptionController.text
          : null,
      category: _selectedCategory,
      frequency: _selectedFrequency,
      identityStatement: _identityStatementController.text.isNotEmpty
          ? _identityStatementController.text
          : null,
      twoMinuteVersion: _twoMinuteController.text.isNotEmpty
          ? _twoMinuteController.text
          : null,
      cue: _cueController.text.isNotEmpty ? _cueController.text : null,
      craving: _cravingController.text.isNotEmpty
          ? _cravingController.text
          : null,
      response: _responseController.text.isNotEmpty
          ? _responseController.text
          : null,
      reward: _rewardController.text.isNotEmpty ? _rewardController.text : null,
      reminderEnabled: _reminderEnabled,
      reminderTime: _reminderTime != null
          ? '${_reminderTime!.hour.toString().padLeft(2, '0')}:${_reminderTime!.minute.toString().padLeft(2, '0')}'
          : null,
      color: categoryColor?.toARGB32(),
      updatedAt: DateTime.now(),
    );

    final controller = ref.read(habitControllerProvider.notifier);
    await controller.updateHabit(updatedHabit);

    // Refresh data
    ref.invalidate(habitProvider(widget.habitId));
    ref.invalidate(habitsProvider);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Habitude modifiée avec succès!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.pop();
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer l\'habitude'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer cette habitude ? Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              final controller = ref.read(habitControllerProvider.notifier);
              await controller.deleteHabit(widget.habitId);
              if (!context.mounted) return;
              ref.invalidate(habitsProvider);

              if (mounted) {
                Navigator.pop(context);
                context.go('/');
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
