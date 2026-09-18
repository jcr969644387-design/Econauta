import '../models/quiz_question.dart';

/// Banco local de preguntas cortas del modulo de evaluacion.
class QuestionBank {
  const QuestionBank._();

  /// Preguntas disponibles en el MVP.
  static const List<QuizQuestion> questions = <QuizQuestion>[
    QuizQuestion(
      id: 'q1',
      topic: 'Inflacion',
      prompt: 'Que mide la tasa de inflacion?',
      options: <String>[
        'El aumento general y sostenido de los precios',
        'El valor total de la produccion de un pais',
        'La cantidad de personas sin empleo',
        'La diferencia entre exportaciones e importaciones',
      ],
      correctIndex: 0,
      explanation: 'La inflacion mide el aumento general y sostenido del '
          'nivel de precios, no la produccion ni el empleo.',
    ),
    QuizQuestion(
      id: 'q2',
      topic: 'Politica monetaria',
      prompt: 'Que suele ocurrir cuando el banco central sube la tasa de '
          'interes de referencia?',
      options: <String>[
        'El credito se abarata y la inversion aumenta',
        'El credito se encarece y la demanda tiende a enfriarse',
        'La inflacion sube de forma inmediata',
        'El gasto publico aumenta automaticamente',
      ],
      correctIndex: 1,
      explanation: 'Una tasa mas alta encarece el credito, reduce consumo e '
          'inversion y tiende a moderar la inflacion.',
    ),
    QuizQuestion(
      id: 'q3',
      topic: 'PIB',
      prompt: 'Cual de estos componentes forma parte del PIB por el lado del '
          'gasto?',
      options: <String>[
        'La tasa de desempleo',
        'El indice de precios al consumidor',
        'El consumo de los hogares',
        'La tasa de interes de referencia',
      ],
      correctIndex: 2,
      explanation: 'El PIB por el lado del gasto suma consumo, inversion, '
          'gasto publico y exportaciones netas.',
    ),
    QuizQuestion(
      id: 'q4',
      topic: 'Mercado laboral',
      prompt: 'Segun la ley de Okun, que ocurre con el desempleo cuando el '
          'PIB crece por encima de su nivel potencial?',
      options: <String>[
        'Tiende a bajar',
        'Tiende a subir',
        'No cambia nunca',
        'Se vuelve igual a la inflacion',
      ],
      correctIndex: 0,
      explanation: 'La ley de Okun relaciona un mayor crecimiento con una '
          'caida de la tasa de desempleo.',
    ),
    QuizQuestion(
      id: 'q5',
      topic: 'Politica fiscal',
      prompt: 'Que combinacion representa una politica fiscal expansiva?',
      options: <String>[
        'Mas impuestos y menos gasto publico',
        'Menos impuestos y mas gasto publico',
        'Mas impuestos y mas tasa de interes',
        'Menos gasto publico y mas tasa de interes',
      ],
      correctIndex: 1,
      explanation: 'Bajar impuestos y subir el gasto publico aumenta la '
          'demanda agregada: eso es una politica fiscal expansiva.',
    ),
    QuizQuestion(
      id: 'q6',
      topic: 'Deficit fiscal',
      prompt: 'Cuando existe deficit fiscal?',
      options: <String>[
        'Cuando los ingresos publicos superan a los gastos',
        'Cuando los gastos publicos superan a los ingresos',
        'Cuando la inflacion supera a la meta',
        'Cuando la deuda publica baja',
      ],
      correctIndex: 1,
      explanation: 'El deficit aparece cuando el gasto publico, incluidos los '
          'intereses, supera a los ingresos del Estado.',
    ),
    QuizQuestion(
      id: 'q7',
      topic: 'Deuda publica',
      prompt: 'Que efecto tiene un crecimiento nominal mas alto sobre la '
          'deuda publica medida como porcentaje del PIB?',
      options: <String>[
        'La aumenta siempre',
        'La deja igual',
        'Ayuda a reducirla si el deficit es moderado',
        'La elimina por completo',
      ],
      correctIndex: 2,
      explanation: 'Al crecer el PIB nominal, el mismo monto de deuda pesa '
          'menos en terminos relativos.',
    ),
    QuizQuestion(
      id: 'q8',
      topic: 'Meta de inflacion',
      prompt: 'Para que sirve que el banco central anuncie una meta de '
          'inflacion?',
      options: <String>[
        'Para fijar los precios de todos los productos',
        'Para anclar las expectativas de empresas y familias',
        'Para eliminar el desempleo',
        'Para aumentar la recaudacion tributaria',
      ],
      correctIndex: 1,
      explanation: 'La meta anuncia un compromiso creible que ancla las '
          'expectativas de inflacion.',
    ),
    QuizQuestion(
      id: 'q9',
      topic: 'Trade-off',
      prompt: 'Que costo suele tener una politica muy expansiva mantenida '
          'durante varios periodos?',
      options: <String>[
        'Mas inflacion y mas deuda publica',
        'Menos inflacion y menos deuda publica',
        'Menos crecimiento inmediato',
        'Ningun costo economico',
      ],
      correctIndex: 0,
      explanation: 'El estimulo sostenido eleva la demanda y los precios, y '
          'financiar el deficit incrementa la deuda.',
    ),
    QuizQuestion(
      id: 'q10',
      topic: 'Interpretacion',
      prompt: 'Si la inflacion es 8 % y la meta es 2 %, que decision es mas '
          'coherente?',
      options: <String>[
        'Bajar la tasa de interes y subir el gasto publico',
        'Subir la tasa de interes y moderar el gasto publico',
        'Mantener todo igual porque la brecha no importa',
        'Bajar los impuestos para estimular la demanda',
      ],
      correctIndex: 1,
      explanation: 'Con la inflacion muy por encima de la meta corresponde '
          'enfriar la demanda: tasa mas alta y menor impulso fiscal.',
    ),
  ];
}
