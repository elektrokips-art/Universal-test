import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../l10n/app_strings.dart';
import '../l10n/locale_provider.dart';
import '../models/grade_scale.dart';
import '../models/question.dart';
import '../models/test_recipe.dart';
import '../services/ai_settings.dart';
import '../services/ai_service.dart';
import '../state/recipes_model.dart';
import 'grade_scale_screen.dart';

const int kMaxQuestionSlots = 30;
const int kMinActiveQuestions = 10;
const _uuid = Uuid();

class _QuestionSlot {
  String? id;
  final TextEditingController textController = TextEditingController();
  int answerCount = 4;
  List<TextEditingController> optionControllers =
      List.generate(4, (_) => TextEditingController());
  int correctIndex = 0;
  bool enabled = true;

  _QuestionSlot();

  factory _QuestionSlot.fromQuestion(Question q) {
    final slot = _QuestionSlot();
    slot.id = q.id;
    slot.textController.text = q.text;
    slot.answerCount = q.options.length;
    slot.optionControllers =
        q.options.map((o) => TextEditingController(text: o)).toList();
    slot.correctIndex = q.correctIndex;
    slot.enabled = q.enabled;
    return slot;
  }

  void setAnswerCount(int count) {
    if (count == optionControllers.length) return;
    if (count > optionControllers.length) {
      while (optionControllers.length < count) {
        optionControllers.add(TextEditingController());
      }
    } else {
      optionControllers.removeRange(count, optionControllers.length);
      if (correctIndex >= count) correctIndex = 0;
    }
    answerCount = count;
  }

  /// Fills this (empty) slot with an AI-generated question, without
  /// touching [id] so a fresh one is assigned on save.
  void fillFrom(Question q) {
    textController.text = q.text;
    setAnswerCount(q.options.length);
    for (var i = 0; i < q.options.length; i++) {
      optionControllers[i].text = q.options[i];
    }
    correctIndex = q.correctIndex;
  }

  bool get isUsed => textController.text.trim().isNotEmpty;

  void dispose() {
    textController.dispose();
    for (final c in optionControllers) {
      c.dispose();
    }
  }
}

class TestEditScreen extends StatefulWidget {
  final TestRecipe? existing;
  const TestEditScreen({super.key, this.existing});

  @override
  State<TestEditScreen> createState() => _TestEditScreenState();
}

class _TestEditScreenState extends State<TestEditScreen> {
  late final TextEditingController _nameController;
  late final List<_QuestionSlot> _slots;
  late GradeScale _gradeScale;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _nameController = TextEditingController(text: existing?.name ?? '');
    _gradeScale = existing?.gradeScale ?? const GradeScale();
    _slots = List.generate(kMaxQuestionSlots, (i) {
      if (existing != null && i < existing.questions.length) {
        return _QuestionSlot.fromQuestion(existing.questions[i]);
      }
      return _QuestionSlot();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (final s in _slots) {
      s.dispose();
    }
    super.dispose();
  }

  int get _activeCount =>
      _slots.where((s) => s.isUsed && s.enabled).length;

  void _toggleEnabled(_QuestionSlot slot, bool value) {
    final locale = context.read<LocaleProvider>();
    if (!value && slot.isUsed && slot.enabled && _activeCount <= kMinActiveQuestions) {
      _showError('${locale.t('minActiveQuestions')} ($kMinActiveQuestions)');
      return;
    }
    setState(() => slot.enabled = value);
  }

  bool _aiBusy = false;

  Future<void> _generateWithAi() async {
    final locale = context.read<LocaleProvider>();
    final aiSettings = context.read<AiSettings>();

    if (!aiSettings.hasKey) {
      _showError(locale.t('aiMissingKey'));
      return;
    }

    final emptySlots = _slots.where((s) => !s.isUsed).length;
    if (emptySlots == 0) {
      _showError(locale.t('aiWillOverwrite'));
      return;
    }

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => _AiGenerateDialog(maxCount: emptySlots),
    );
    if (result == null) return;

    setState(() => _aiBusy = true);
    try {
      final languageName =
          locale.language == AppLanguage.uz ? 'узбекский' : 'русский';
      final questions = await AiService.generateQuestions(
        apiKey: aiSettings.apiKey,
        model: aiSettings.model,
        topic: result['topic'] as String,
        count: result['count'] as int,
        optionsPerQuestion: result['options'] as int,
        languageName: languageName,
      );

      var qi = 0;
      for (final slot in _slots) {
        if (qi >= questions.length) break;
        if (slot.isUsed) continue;
        slot.fillFrom(questions[qi]);
        qi++;
      }

      if (mounted) {
        setState(() => _aiBusy = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(locale.t('aiGenerated'))),
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() => _aiBusy = false);
        _showError(locale.t('aiError'));
      }
    }
  }

  Future<void> _openGradeScale() async {
    final result = await Navigator.of(context).push<GradeScale>(
      MaterialPageRoute(
        builder: (_) => GradeScaleScreen(initial: _gradeScale),
      ),
    );
    if (result != null) {
      setState(() => _gradeScale = result);
    }
  }

  void _save() {
    final locale = context.read<LocaleProvider>();
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showError(locale.t('testName'));
      return;
    }

    final questions = <Question>[];
    for (var i = 0; i < _slots.length; i++) {
      final slot = _slots[i];
      if (!slot.isUsed) continue;

      final options = slot.optionControllers.map((c) => c.text.trim()).toList();
      if (options.any((o) => o.isEmpty)) {
        _showError('${locale.t('question')} ${i + 1}: ${locale.t('answer')}');
        return;
      }
      if (slot.correctIndex < 0 || slot.correctIndex >= options.length) {
        _showError('${locale.t('question')} ${i + 1}: ${locale.t('correct')}');
        return;
      }

      questions.add(Question(
        id: slot.id ?? _uuid.v4(),
        text: slot.textController.text.trim(),
        options: options,
        correctIndex: slot.correctIndex,
        enabled: slot.enabled,
      ));
    }

    if (questions.isEmpty) {
      _showError(locale.t('question'));
      return;
    }

    if (questions.where((q) => q.enabled).length < kMinActiveQuestions) {
      _showError('${locale.t('minActiveQuestions')} ($kMinActiveQuestions)');
      return;
    }

    final recipe = TestRecipe(
      id: widget.existing?.id ?? _uuid.v4(),
      name: name,
      questions: questions,
      gradeScale: _gradeScale,
      createdAt: widget.existing?.createdAt ?? DateTime.now(),
    );

    context.read<RecipesModel>().save(recipe);
    Navigator.of(context).pop();
  }

  void _showError(String detail) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(detail)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? locale.t('newTest') : locale.t('edit')),
        actions: [
          IconButton(
            tooltip: locale.t('aiGenerate'),
            onPressed: _aiBusy ? null : _generateWithAi,
            icon: _aiBusy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.auto_awesome),
          ),
          IconButton(
            tooltip: locale.t('gradeScale'),
            onPressed: _openGradeScale,
            icon: const Icon(Icons.leaderboard),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _save,
        icon: const Icon(Icons.save),
        label: Text(locale.t('saveAsRecipe')),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 90),
        itemCount: _slots.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: locale.t('testName'),
                  border: const OutlineInputBorder(),
                ),
              ),
            );
          }
          final slotIndex = index - 1;
          return _QuestionSlotCard(
            index: slotIndex,
            slot: _slots[slotIndex],
            onChanged: () => setState(() {}),
            onToggleEnabled: (v) => _toggleEnabled(_slots[slotIndex], v),
          );
        },
      ),
    );
  }
}

class _QuestionSlotCard extends StatelessWidget {
  final int index;
  final _QuestionSlot slot;
  final VoidCallback onChanged;
  final ValueChanged<bool> onToggleEnabled;

  const _QuestionSlotCard({
    required this.index,
    required this.slot,
    required this.onChanged,
    required this.onToggleEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Opacity(
        opacity: slot.enabled ? 1.0 : 0.5,
        child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 14, child: Text('${index + 1}')),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: slot.textController,
                    decoration: InputDecoration(
                      labelText: '${locale.t('question')} ${index + 1}',
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (_) => onChanged(),
                  ),
                ),
                const SizedBox(width: 8),
                Tooltip(
                  message: locale.t('questionEnabled'),
                  child: Checkbox(
                    value: slot.enabled,
                    onChanged: (v) => onToggleEnabled(v ?? true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(locale.t('answersCount')),
                const SizedBox(width: 10),
                DropdownButton<int>(
                  value: slot.answerCount,
                  items: const [2, 3, 4, 5]
                      .map((n) => DropdownMenuItem(value: n, child: Text('$n')))
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    slot.setAnswerCount(value);
                    onChanged();
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...List.generate(slot.optionControllers.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Checkbox(
                      value: slot.correctIndex == i,
                      onChanged: (_) {
                        slot.correctIndex = i;
                        onChanged();
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: slot.optionControllers[i],
                        decoration: InputDecoration(
                          labelText: '${locale.t('answer')} ${i + 1}',
                          isDense: true,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
        ),
      ),
    );
  }
}

class _AiGenerateDialog extends StatefulWidget {
  final int maxCount;
  const _AiGenerateDialog({required this.maxCount});

  @override
  State<_AiGenerateDialog> createState() => _AiGenerateDialogState();
}

class _AiGenerateDialogState extends State<_AiGenerateDialog> {
  late final TextEditingController _topicController;
  late int _count;
  int _options = 4;

  @override
  void initState() {
    super.initState();
    _topicController = TextEditingController();
    _count = widget.maxCount < 10 ? widget.maxCount : 10;
  }

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    return AlertDialog(
      title: Text(locale.t('aiGenerate')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _topicController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: locale.t('aiTopic'),
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: Text(locale.t('aiQuestionsCount'))),
              DropdownButton<int>(
                value: _count,
                items: List.generate(widget.maxCount, (i) => i + 1)
                    .map((n) => DropdownMenuItem(value: n, child: Text('$n')))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _count = v);
                },
              ),
            ],
          ),
          Row(
            children: [
              Expanded(child: Text(locale.t('aiOptionsCount'))),
              DropdownButton<int>(
                value: _options,
                items: const [2, 3, 4, 5]
                    .map((n) => DropdownMenuItem(value: n, child: Text('$n')))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _options = v);
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(locale.t('cancel')),
        ),
        FilledButton(
          onPressed: _topicController.text.trim().isEmpty
              ? null
              : () => Navigator.of(context).pop({
                    'topic': _topicController.text.trim(),
                    'count': _count,
                    'options': _options,
                  }),
          child: Text(locale.t('generate')),
        ),
      ],
    );
  }
}
