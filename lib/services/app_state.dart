import 'package:flutter/foundation.dart';

import '../models/analyst_insight.dart';
import '../models/economy_state.dart';
import '../models/policy_settings.dart';
import 'economic_analyst.dart';
import 'simulation_engine.dart';

/// Estado compartido de la aplicacion.
///
/// Guarda la economia actual, la politica seleccionada, el historial de
/// periodos y los comentarios del analista local.
class AppState extends ChangeNotifier {
  AppState() {
    _current = EconomyState.initial;
    _policy = PolicySettings.initial;
    _history.add(_current);
  }

  late EconomyState _current;
  late PolicySettings _policy;
  final List<EconomyState> _history = <EconomyState>[];
  List<AnalystInsight> _insights = <AnalystInsight>[];

  /// Estado economico vigente.
  EconomyState get current => _current;

  /// Politica economica seleccionada por el estudiante.
  PolicySettings get policy => _policy;

  /// Historial de periodos, comenzando por el estado inicial.
  List<EconomyState> get history => List<EconomyState>.unmodifiable(_history);

  /// Comentarios del analista sobre la ultima simulacion.
  List<AnalystInsight> get insights {
    return List<AnalystInsight>.unmodifiable(_insights);
  }

  /// Estado del periodo anterior, si existe.
  EconomyState? get previous {
    if (_history.length < 2) {
      return null;
    }
    return _history[_history.length - 2];
  }

  /// Indica si ya se ejecuto al menos un periodo.
  bool get hasSimulated => _history.length > 1;

  /// Actualiza la politica economica si los valores son validos.
  bool updatePolicy(PolicySettings policy) {
    if (!policy.isValid) {
      return false;
    }
    _policy = policy;
    notifyListeners();
    return true;
  }

  /// Ejecuta la cantidad de periodos indicada y guarda los resultados.
  void runSimulation(int periods) {
    final previousState = _current;
    final results = SimulationEngine.runPeriods(
      initialState: _current,
      policy: _policy,
      periods: periods,
    );
    _history.addAll(results);
    _current = results.last;
    _insights = EconomicAnalyst.analyze(
      previous: previousState,
      current: _current,
    );
    notifyListeners();
  }

  /// Vuelve al estado inicial de la economia.
  void reset() {
    _current = EconomyState.initial;
    _policy = PolicySettings.initial;
    _history
      ..clear()
      ..add(_current);
    _insights = <AnalystInsight>[];
    notifyListeners();
  }
}

/// Instancia global usada por las pantallas del MVP.
final AppState appState = AppState();
