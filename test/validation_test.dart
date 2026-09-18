import 'package:econauta/models/economy_state.dart';
import 'package:econauta/models/policy_settings.dart';
import 'package:econauta/services/app_state.dart';
import 'package:econauta/services/simulation_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validacion de valores invalidos', () {
    const neutral = PolicySettings.initial;

    test('la politica inicial es valida', () {
      expect(neutral.isValid, isTrue);
      expect(neutral.validate, returnsNormally);
    });

    test('rechaza impuestos fuera de rango', () {
      final policy = neutral.copyWith(taxRate: 80.0);
      expect(policy.isValid, isFalse);
      expect(policy.validate, throwsArgumentError);
    });

    test('rechaza gasto publico negativo', () {
      final policy = neutral.copyWith(publicSpendingRate: -5.0);
      expect(policy.validate, throwsArgumentError);
    });

    test('rechaza tasas de interes imposibles', () {
      final policy = neutral.copyWith(interestRate: 120.0);
      expect(policy.validate, throwsArgumentError);
    });

    test('rechaza valores no numericos', () {
      final policy = neutral.copyWith(inflationTarget: double.nan);
      expect(policy.validate, throwsArgumentError);
    });

    test('el motor rechaza politicas invalidas', () {
      final policy = neutral.copyWith(taxRate: 99.0);
      expect(
        () => SimulationEngine.runPeriod(
          state: EconomyState.initial,
          policy: policy,
        ),
        throwsArgumentError,
      );
    });

    test('el motor rechaza una cantidad invalida de periodos', () {
      expect(
        () => SimulationEngine.runPeriods(
          initialState: EconomyState.initial,
          policy: neutral,
          periods: 0,
        ),
        throwsArgumentError,
      );
      expect(
        () => SimulationEngine.runPeriods(
          initialState: EconomyState.initial,
          policy: neutral,
          periods: 6,
        ),
        throwsArgumentError,
      );
    });

    test('el estado de la app ignora politicas invalidas', () {
      final state = AppState();
      final applied = state.updatePolicy(neutral.copyWith(taxRate: 500.0));
      expect(applied, isFalse);
      expect(state.policy.taxRate, neutral.taxRate);

      final valid = state.updatePolicy(neutral.copyWith(taxRate: 22.0));
      expect(valid, isTrue);
      expect(state.policy.taxRate, 22.0);
    });

    test('el estado de la app guarda historial y se reinicia', () {
      final state = AppState();
      expect(state.hasSimulated, isFalse);
      state.runSimulation(3);
      expect(state.hasSimulated, isTrue);
      expect(state.history.length, 4);
      expect(state.current.period, 3);
      expect(state.insights, isNotEmpty);

      state.reset();
      expect(state.history.length, 1);
      expect(state.current.period, 0);
      expect(state.insights, isEmpty);
    });
  });
}
