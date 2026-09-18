import 'package:flutter/material.dart';

import '../models/quiz_question.dart';
import '../services/feedback_service.dart';
import '../services/question_bank.dart';
import '../widgets/app_theme.dart';
import '../widgets/educational_notice.dart';
import '../widgets/screen_scaffold.dart';

/// Modulo 7: evaluacion con preguntas cortas y retroalimentacion.
class EvaluationScreen extends StatefulWidget {
  const EvaluationScreen({super.key});

  @override
  State<EvaluationScreen> createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {
  final Map<String, int> _answers = <String, int>{};
  bool _submitted = false;

  List<QuizQuestion> get _questions => QuestionBank.questions;

  int get _score {
    var total = 0;
    for (final question in _questions) {
      final selected = _answers[question.id];
      if (selected != null && question.isCorrect(selected)) {
        total++;
      }
    }
    return total;
  }

  void _submit() {
    final score = _score;
    final total = _questions.length;
    if (total > 0 && score == total) {
      feedback.achievement();
    } else if (total > 0 && score / total >= 0.6) {
      feedback.correct();
    } else {
      feedback.incorrect();
    }
    setState(() {
      _submitted = true;
    });
  }

  void _restart() {
    feedback.tap();
    setState(() {
      _answers.clear();
      _submitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final answered = _answers.length;
    final total = _questions.length;
    return ScreenScaffold(
      title: 'Evaluacion',
      children: <Widget>[
        SectionCard(
          title: 'Progreso',
          subtitle: 'Respondidas: $answered de $total',
          child: _ScoreBanner(
            submitted: _submitted,
            score: _score,
            total: total,
          ),
        ),
        const SizedBox(height: 16),
        ..._questions.map((QuizQuestion question) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _QuestionCard(
              question: question,
              selected: _answers[question.id],
              submitted: _submitted,
              onSelected: (int index) {
                setState(() {
                  _answers[question.id] = index;
                });
              },
            ),
          );
        }),
        if (!_submitted)
          FilledButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.fact_check_outlined),
            label: const Text('Revisar respuestas'),
          ),
        if (_submitted)
          OutlinedButton.icon(
            onPressed: _restart,
            icon: const Icon(Icons.refresh),
            label: const Text('Intentar de nuevo'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
          ),
        const SizedBox(height: 16),
        const EducationalNotice(),
      ],
    );
  }
}

class _ScoreBanner extends StatelessWidget {
  const _ScoreBanner({
    required this.submitted,
    required this.score,
    required this.total,
  });

  final bool submitted;
  final int score;
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppColors.of(context);
    if (!submitted) {
      return Text(
        'Responde las preguntas y pulsa "Revisar respuestas" para ver tu '
        'puntaje y la explicacion de cada caso.',
        style: theme.textTheme.bodyMedium,
      );
    }
    final percent = total == 0 ? 0.0 : score / total * 100;
    var message = 'Necesitas repasar los conceptos basicos.';
    if (percent >= 80) {
      message = 'Excelente dominio de los conceptos.';
    } else if (percent >= 60) {
      message = 'Buen avance, revisa los temas fallados.';
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Puntaje: $score de $total',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colors.heading,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(message, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.question,
    required this.selected,
    required this.submitted,
    required this.onSelected,
  });

  final QuizQuestion question;
  final int? selected;
  final bool submitted;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppColors.of(context);
    final options = <Widget>[];
    for (var index = 0; index < question.options.length; index++) {
      final position = index;
      options.add(
        _OptionTile(
          text: question.options[position],
          isSelected: selected == position,
          onTap: () {
            if (!submitted) {
              feedback.tap();
              onSelected(position);
            }
          },
        ),
      );
    }
    return SectionCard(
      title: question.topic,
      subtitle: question.prompt,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ...options,
          if (submitted) const SizedBox(height: 8),
          if (submitted)
            Text(
              _feedback(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: _feedbackColor(colors),
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  String _feedback() {
    final answer = selected;
    if (answer == null) {
      return 'Sin responder. ${question.explanation}';
    }
    if (question.isCorrect(answer)) {
      return 'Correcto. ${question.explanation}';
    }
    return 'Incorrecto. ${question.explanation}';
  }

  Color _feedbackColor(AppColors colors) {
    final answer = selected;
    if (answer != null && question.isCorrect(answer)) {
      return colors.positive;
    }
    return colors.negative;
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppColors.of(context);
    var icon = Icons.radio_button_unchecked;
    var color = colors.muted;
    if (isSelected) {
      icon = Icons.radio_button_checked;
      color = colors.accent;
    }
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Text(text, style: theme.textTheme.bodyMedium),
            ),
          ],
        ),
      ),
    );
  }
}
