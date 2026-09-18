import '../models/economy_state.dart';

/// Utilidades de presentacion del historial de periodos.
class HistoryUtils {
  const HistoryUtils._();

  /// Devuelve los ultimos [count] periodos del historial.
  static List<EconomyState> last(List<EconomyState> history, int count) {
    if (count <= 0 || history.isEmpty) {
      return <EconomyState>[];
    }
    if (history.length <= count) {
      return List<EconomyState>.from(history);
    }
    return history.sublist(history.length - count);
  }
}
