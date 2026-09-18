import 'package:econauta/calculators/fiscal_policy_calculator.dart';
import 'package:econauta/models/policy_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiscalPolicyCalculator', () {
    const neutral = PolicySettings.initial;

    test('la politica neutral no genera impulso', () {
      final impulse = FiscalPolicyCalculator.fiscalImpulse(neutral);
      expect(impulse, closeTo(0.0, 0.0001));
      expect(FiscalPolicyCalculator.stance(neutral), contains('neutral'));
    });

    test('mas gasto y menos impuestos generan impulso positivo', () {
      final expansive = neutral.copyWith(
        publicSpendingRate: 25.0,
        taxRate: 15.0,
      );
      final impulse = FiscalPolicyCalculator.fiscalImpulse(expansive);
      // (25 - 20) * 0.30 + (18 - 15) * 0.20 = 2.1
      expect(impulse, closeTo(2.1, 0.0001));
      expect(FiscalPolicyCalculator.stance(expansive), contains('expansiva'));
    });

    test('menos gasto y mas impuestos generan impulso negativo', () {
      final contractive = neutral.copyWith(
        publicSpendingRate: 15.0,
        taxRate: 25.0,
      );
      final impulse = FiscalPolicyCalculator.fiscalImpulse(contractive);
      expect(impulse, lessThan(0.0));
      final stance = FiscalPolicyCalculator.stance(contractive);
      expect(stance, contains('contractiva'));
    });

    test('calcula ingresos, intereses y deficit', () {
      final revenue = FiscalPolicyCalculator.publicRevenue(
        policy: neutral,
        gdpGrowth: 2.5,
      );
      expect(revenue, closeTo(18.0, 0.0001));

      final interest = FiscalPolicyCalculator.interestBurden(
        publicDebt: 45.0,
        interestRate: 5.0,
      );
      expect(interest, closeTo(0.5625, 0.0001));

      final deficit = FiscalPolicyCalculator.fiscalDeficit(
        policy: neutral,
        gdpGrowth: 2.5,
        publicDebt: 45.0,
      );
      // 20 + 0.5625 - 18 = 2.5625
      expect(deficit, closeTo(2.5625, 0.0001));
    });

    test('un superavit reduce la deuda publica', () {
      final debt = FiscalPolicyCalculator.nextPublicDebt(
        publicDebt: 45.0,
        fiscalDeficit: -2.0,
        gdpGrowth: 2.5,
        inflation: 3.5,
      );
      expect(debt, lessThan(45.0));
    });

    test('el crecimiento nominal diluye la deuda existente', () {
      final debt = FiscalPolicyCalculator.nextPublicDebt(
        publicDebt: 45.0,
        fiscalDeficit: 2.5625,
        gdpGrowth: 2.5,
        inflation: 3.5,
      );
      // (45 + 2.5625) / 1.06 = 44.870...
      expect(debt, closeTo(44.8703, 0.001));
      expect(debt, lessThanOrEqualTo(FiscalPolicyCalculator.maxDebt));
    });
  });
}
