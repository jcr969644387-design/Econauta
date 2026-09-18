import 'package:econauta/calculators/monetary_policy_calculator.dart';
import 'package:econauta/models/policy_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MonetaryPolicyCalculator', () {
    const neutral = PolicySettings.initial;

    test('la tasa neutral no genera impulso', () {
      final impulse = MonetaryPolicyCalculator.monetaryImpulse(neutral);
      expect(impulse, closeTo(0.0, 0.0001));
      expect(MonetaryPolicyCalculator.stance(neutral), contains('neutral'));
    });

    test('una tasa baja genera impulso expansivo', () {
      final easy = neutral.copyWith(interestRate: 1.0);
      final impulse = MonetaryPolicyCalculator.monetaryImpulse(easy);
      // (5 - 1) * 0.25 = 1.0
      expect(impulse, closeTo(1.0, 0.0001));
      expect(MonetaryPolicyCalculator.stance(easy), contains('expansiva'));
    });

    test('una tasa alta genera impulso contractivo', () {
      final tight = neutral.copyWith(interestRate: 9.0);
      final impulse = MonetaryPolicyCalculator.monetaryImpulse(tight);
      // (5 - 9) * 0.25 = -1.0
      expect(impulse, closeTo(-1.0, 0.0001));
      expect(MonetaryPolicyCalculator.stance(tight), contains('restrictiva'));
      final description = MonetaryPolicyCalculator.effectDescription(tight);
      expect(description, contains('encarece'));
    });

    test('calcula la tasa de interes real', () {
      final real = MonetaryPolicyCalculator.realInterestRate(
        interestRate: 5.0,
        inflation: 8.0,
      );
      expect(real, closeTo(-3.0, 0.0001));
    });
  });
}
