/// Tono educativo de un comentario del analista economico.
enum InsightTone {
  /// El indicador mejoro respecto al periodo anterior.
  positive,

  /// El indicador empeoro o presenta un riesgo.
  negative,

  /// El indicador se mantuvo estable o requiere contexto.
  neutral,
}

/// Comentario generado por el analista economico local.
class AnalystInsight {
  const AnalystInsight({
    required this.title,
    required this.message,
    required this.tone,
  });

  /// Titulo corto del comentario, por ejemplo "Inflacion".
  final String title;

  /// Explicacion educativa del cambio observado.
  final String message;

  /// Tono del comentario.
  final InsightTone tone;
}
