import 'package:econauta/models/economy_state.dart';
import 'package:econauta/models/policy_settings.dart';
import 'package:econauta/services/economic_analyst.dart';
import 'package:econauta/services/simulation_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SimulationEngine', () {
    const initial = EconomyState.initial;
    const neutral = PolicySettings.initial;

    test('simula un periodo con la politica neutral', () {
      final result = SimulationEngine.runPeriod(
        state: initial,
        policy: neutral,
      );
      expect(result.period, 1);
      expect(result.gdpGrowth, closeTo(2.5, 0.0001));
      expect(result.gdp, closeTo(102.5, 0.0001));
      expect(result.inflation, closeTo(3.5, 0.0001));
      expect(result.unemployment, closeTo(7.0, 0.0001));
      expect(result.fiscalDeficit, closeTo(2.5625, 0.0001));
      expect(result.publicDebt, closeTo(44.8703, 0.001));
      expect(result.stabilityIndex, closeTo(90.5, 0.01));
      expect(result.employment, closeTo(93.0, 0.0001));
    });

    test('una politica expansiva acelera el crecimiento y el empleo', () {
      final expansive = neutral.copyWith(
        publicSpendingRate: 26.0,
        interestRate: 2.0,
      );
      final result = SimulationEngine.runPeriod(
        state: initial,
        policy: expansive,
      );
      expect(result.gdpGrowth, greaterThan(2.5));
      expect(result.unemployment, lessThan(initial.unemployment));
      expect(result.inflation, greaterThan(3.5));
    });

    test('el modelo es determinista', () {
      final first = SimulationEngine.runPeriod(
        state: initial,
        policy: neutral,
      );
      final second = SimulationEngine.runPeriod(
        state: initial,
        policy: neutral,
      );
      expect(first.gdp, second.gdp);
      expect(first.inflation, second.inflation);
      expect(first.stabilityIndex, second.stabilityIndex);
    });

    test('ejecuta varios periodos consecutivos', () {
      final results = SimulationEngine.runPeriods(
        initialState: initial,
        policy: neutral,
        periods: 5,
      );
      expect(results.length, 5);
      expect(results.first.period, 1);
      expect(results.last.period, 5);
      // Sin impulso, la inflacion converge hacia la meta.
      expect(results.last.inflation, lessThan(results.first.inflation));
    });

    test('el impulso de demanda suma politica fiscal y monetaria', () {
      final policy = neutral.copyWith(
        publicSpendingRate: 25.0,
        interestRate: 1.0,
      );
      final impulse = SimulationEngine.demandImpulse(policy);
      // (25 - 20) * 0.30 + (5 - 1) * 0.25 = 2.5
      expect(impulse, closeTo(2.5, 0.0001));
    });
  });

  group('EconomicAnalyst', () {
    test('genera comentarios educativos entre dos periodos', () {
      const initial = EconomyState.initial;
      final next = SimulationEngine.runPeriod(
        state: initial,
        policy: PolicySettings.initial,
      );
      final insights = EconomicAnalyst.analyze(
        previous: initial,
        current: next,
      );
      expect(insights.length, 7);
      expect(insights.first.title, 'Politica aplicada');
      expect(EconomicAnalyst.summary(next), isNotEmpty);
    });
  });
}
