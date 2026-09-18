/// Pregunta corta de opcion multiple del modulo de evaluacion.
class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.topic,
    required this.prompt,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  /// Identificador estable de la pregunta.
  final String id;

  /// Tema al que pertenece la pregunta.
  final String topic;

  /// Enunciado de la pregunta.
  final String prompt;

  /// Alternativas disponibles.
  final List<String> options;

  /// Indice de la alternativa correcta dentro de [options].
  final int correctIndex;

  /// Explicacion educativa de la respuesta correcta.
  final String explanation;

  /// Indica si la alternativa elegida es la correcta.
  bool isCorrect(int selectedIndex) => selectedIndex == correctIndex;
}
