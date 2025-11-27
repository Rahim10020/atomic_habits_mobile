import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../domain/models/habit.dart';
import '../../../domain/models/four_laws.dart';
import '../../../application/providers/habit_provider.dart';
import '../../../application/providers/habit_templates_provider.dart';
import '../../../core/utils/habit_templates.dart';
import '../../widgets/common/habit_laws_fields.dart';

class CreateHabitScreen extends ConsumerStatefulWidget {
  const CreateHabitScreen({super.key});

  @override
  ConsumerState<CreateHabitScreen> createState() => _CreateHabitScreenState();
}

class _CreateHabitScreenState extends ConsumerState<CreateHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _twoMinuteController = TextEditingController();
  final _cueController = TextEditingController();
  final _cravingController = TextEditingController();
  final _responseController = TextEditingController();
  final _rewardController = TextEditingController();

  String _selectedCategory = AppConstants.defaultCategories[0];
  String _selectedFrequency = AppConstants.frequencies[0];
  bool _reminderEnabled = false;
  TimeOfDay? _reminderTime;
  int _currentStep = 0;
  HabitTemplate? _selectedTemplate;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _twoMinuteController.dispose();
    _cueController.dispose();
    _cravingController.dispose();
    _responseController.dispose();
    _rewardController.dispose();
    super.dispose();
  }

  void _preFillFromTemplate() {
    if (_selectedTemplate == null) return;

    _nameController.text = _selectedTemplate!.name;
    _descriptionController.text = _selectedTemplate!.description;
    _selectedCategory = _selectedTemplate!.category;
    _twoMinuteController.text = _selectedTemplate!.twoMinuteVersion;
    _cueController.text = _selectedTemplate!.cue;
    _cravingController.text = _selectedTemplate!.craving;
    _responseController.text = _selectedTemplate!.response;
    _rewardController.text = _selectedTemplate!.reward;

    if (_selectedTemplate!.reminderTime != null) {
      _reminderEnabled = true;
      final parts = _selectedTemplate!.reminderTime!.split(':');
      _reminderTime = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final templatesAsync = ref.watch(allHabitTemplatesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle habitude'),
        actions: [
          if (_currentStep > 0)
            TextButton(
              onPressed: () {
                setState(() {
                  _currentStep--;
                });
              },
              child: const Text('Précédent'),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: _onStepContinue,
          onStepCancel: _onStepCancel,
          controlsBuilder: _controlsBuilder,
          steps: [
            _buildTemplateSelectionStep(templatesAsync),
            _buildBasicInfoStep(),
            _buildIdentityStep(),
            _buildFourLawsStep(),
            _buildReminderStep(),
          ],
        ),
      ),
    );
  }

  Step _buildTemplateSelectionStep(List<HabitTemplate> templates) {
    return Step(
      title: const Text('Choisir un modèle'),
      subtitle: const Text('Commencez avec un modèle ou créez votre habitude'),
      isActive: _currentStep >= 0,
      state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Modèles populaires', style: AppTextStyles.headlineSmall),
          const SizedBox(height: AppConstants.paddingMedium),
          _buildTemplatesGrid(templates),
          const SizedBox(height: AppConstants.paddingLarge),
          OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _selectedTemplate = null;
              });
              _onStepContinue();
            },
            icon: const Icon(Icons.create),
            label: const Text(
              'Créer une habitude personnalisée',
              style: AppTextStyles.personalizedHabit,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplatesGrid(List<HabitTemplate> templates) {
    // Group by category
    final templatesByCategory = <String, List<HabitTemplate>>{};
    for (var template in templates) {
      if (!templatesByCategory.containsKey(template.category)) {
        templatesByCategory[template.category] = [];
      }
      templatesByCategory[template.category]!.add(template);
    }

    return Column(
      children: templatesByCategory.entries.map((entry) {
        final color = AppColors.categoryColors[entry.key] ?? AppColors.primary;

        return Card(
          margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            side: BorderSide(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
          ),
          child: ExpansionTile(
            leading: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            title: Text(
              entry.key,
              style: AppTextStyles.titleMedium.copyWith(color: color),
            ),
            subtitle: Text(
              '${entry.value.length} modèle${entry.value.length > 1 ? 's' : ''}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: entry.value
                      .map((template) => _buildTemplateCard(template))
                      .toList(),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTemplateCard(HabitTemplate template) {
    final isSelected = _selectedTemplate == template;
    final color =
        AppColors.categoryColors[template.category] ?? AppColors.primary;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedTemplate = template;
        });
        _preFillFromTemplate();
        _onStepContinue();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.1)
              : Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? color
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              template.name,
              style: AppTextStyles.titleSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              template.description,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondaryLight,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Step _buildBasicInfoStep() {
    return Step(
      title: const Text('Informations de base'),
      isActive: _currentStep >= 0,
      state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      content: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nom de l\'habitude *',
              hintText: 'Ex: Faire du sport',
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
              labelText: 'Description (optionnel)',
              hintText: 'Qu\'allez-vous faire exactement ?',
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
      ),
    );
  }

  Step _buildIdentityStep() {
    final identityStatement =
        IdentityBasedHabit.identityExamples[_selectedCategory]?.first ??
        'Je suis quelqu\'un qui...';

    return Step(
      title: const Text('Identité et Mini-habitude'),
      subtitle: const Text('Qui voulez-vous devenir ?'),
      isActive: _currentStep >= 1,
      state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            title: 'Habitudes basées sur l\'identité',
            description:
                'Au lieu de vous concentrer sur ce que vous voulez accomplir, concentrez-vous sur qui vous voulez devenir.',
            icon: Icons.person_rounded,
            color: AppColors.primary,
          ),
          const SizedBox(height: AppConstants.paddingMedium),

          Container(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Déclaration d\'identité suggérée :',
                  style: AppTextStyles.labelMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  identityStatement,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.paddingLarge),

          _buildInfoCard(
            title: 'Règle des 2 minutes',
            description:
                'Quand vous commencez une nouvelle habitude, elle ne devrait pas prendre plus de deux minutes.',
            icon: Icons.timer_rounded,
            color: AppColors.secondary,
          ),
          const SizedBox(height: AppConstants.paddingMedium),

          TextFormField(
            controller: _twoMinuteController,
            decoration: const InputDecoration(
              labelText: 'Version 2 minutes de votre habitude',
              hintText: 'Ex: Mettre mes chaussures de sport',
              prefixIcon: Icon(Icons.bolt),
            ),
          ),
          const SizedBox(height: AppConstants.paddingSmall),

          Text(
            'Exemples: "Lire" → "Lire une page" | "Faire du sport" → "Mettre mes chaussures"',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondaryLight,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Step _buildFourLawsStep() {
    return Step(
      title: const Text('Les 4 Lois du changement'),
      subtitle: const Text('Rendez votre habitude efficace'),
      isActive: _currentStep >= 2,
      state: _currentStep > 2 ? StepState.complete : StepState.indexed,
      content: HabitLawsFields(
        cueController: _cueController,
        cravingController: _cravingController,
        responseController: _responseController,
        rewardController: _rewardController,
        showExamples: true,
      ),
    );
  }

  Step _buildReminderStep() {
    return Step(
      title: const Text('Rappels'),
      subtitle: const Text('N\'oubliez jamais votre habitude'),
      isActive: _currentStep >= 3,
      state: StepState.indexed,
      content: Column(
        children: [
          SwitchListTile(
            title: const Text('Activer les rappels'),
            subtitle: const Text('Recevoir une notification quotidienne'),
            value: _reminderEnabled,
            onChanged: (value) {
              setState(() {
                _reminderEnabled = value;
              });
            },
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
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleSmall.copyWith(color: color),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _controlsBuilder(BuildContext context, ControlsDetails details) {
    return Padding(
      padding: const EdgeInsets.only(top: AppConstants.paddingMedium),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: details.onStepContinue,
              child: Text(_currentStep == 4 ? 'Créer' : 'Suivant'),
            ),
          ),
          if (_currentStep > 0) ...[
            const SizedBox(width: AppConstants.paddingMedium),
            Expanded(
              child: OutlinedButton(
                onPressed: details.onStepCancel,
                child: const Text('Retour'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _onStepContinue() {
    if (_currentStep == 0) {
      // Template selection - always continue
      setState(() {
        _currentStep++;
      });
    } else if (_currentStep == 1) {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _currentStep++;
        });
      }
    } else if (_currentStep < 4) {
      setState(() {
        _currentStep++;
      });
    } else {
      _createHabit();
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _createHabit() async {
    if (!_formKey.currentState!.validate()) return;

    final identityStatement =
        _selectedTemplate?.identityStatement ??
        IdentityBasedHabit.identityExamples[_selectedCategory]?.first;
    final categoryColor = AppColors.categoryColors[_selectedCategory];

    final habit = Habit(
      id: 0, // Will be set by database
      name: _nameController.text,
      description: _descriptionController.text.isNotEmpty
          ? _descriptionController.text
          : _selectedTemplate?.description,
      category: _selectedCategory,
      frequency: _selectedFrequency,
      identityStatement: identityStatement,
      twoMinuteVersion: _twoMinuteController.text.isNotEmpty
          ? _twoMinuteController.text
          : _selectedTemplate?.twoMinuteVersion,
      cue: _cueController.text.isNotEmpty
          ? _cueController.text
          : _selectedTemplate?.cue,
      craving: _cravingController.text.isNotEmpty
          ? _cravingController.text
          : _selectedTemplate?.craving,
      response: _responseController.text.isNotEmpty
          ? _responseController.text
          : _selectedTemplate?.response,
      reward: _rewardController.text.isNotEmpty
          ? _rewardController.text
          : _selectedTemplate?.reward,
      reminderEnabled: _reminderEnabled,
      reminderTime: _reminderTime != null
          ? '${_reminderTime!.hour.toString().padLeft(2, '0')}:${_reminderTime!.minute.toString().padLeft(2, '0')}'
          : _selectedTemplate?.reminderTime,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      color: categoryColor?.toARGB32(),
    );

    final controller = ref.read(habitControllerProvider.notifier);
    await controller.createHabit(habit);

    // Refresh the habits list
    ref.invalidate(habitsProvider);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Habitude créée avec succès!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.pop();
    }
  }
}
