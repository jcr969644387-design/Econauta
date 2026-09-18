import 'package:econauta/calculators/gdp_calculator.dart';
import 'package:econauta/models/policy_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GdpCalculator', () {
    test('sin impulso crece al ritmo potencial', () {
      final growth = GdpCalculator.growth(
        demandImpulse: 0.0,
        publicDebt: 45.0,
        inflation: 4.0,
      );
      expect(growth, closeTo(2.5, 0.0001));
    });

    test('el impulso de demanda aumenta el crecimiento', () {
      final growth = GdpCalculator.growth(
        demandImpulse: 1.5,
        publicDebt: 45.0,
        inflation: 4.0,
      );
      expect(growth, closeTo(4.0, 0.0001));
    });

    test('la deuda alta y la inflacion alta restan crecimiento', () {
      final growth = GdpCalculator.growth(
        demandImpulse: 0.0,
        publicDebt: 110.0,
        inflation: 20.0,
      );
      // 2.5 - (110 - 60) * 0.02 - (20 - 10) * 0.10 = 0.5
      expect(growth, closeTo(0.5, 0.0001));
    });

    test('calcula el PIB del periodo siguiente', () {
      final gdp = GdpCalculator.nextGdp(gdp: 100.0, growth: 2.5);
      expect(gdp, closeTo(102.5, 0.0001));
    });

    test('los componentes reaccionan a la politica economica', () {
      const neutral = PolicySettings.initial;
      final expensive = neutral.copyWith(interestRate: 12.0);
      final baseInvestment = GdpCalculator.investment(
        gdp: 100.0,
        policy: neutral,
      );
      final tightInvestment = GdpCalculator.investment(
        gdp: 100.0,
        policy: expensive,
      );
      expect(baseInvestment, closeTo(20.0, 0.0001));
      expect(tightInvestment, lessThan(baseInvestment));

      final highTaxes = neutral.copyWith(taxRate: 30.0);
      final baseConsumption = GdpCalculator.consumption(
        gdp: 100.0,
        policy: neutral,
      );
      final lowerConsumption = GdpCalculator.consumption(
        gdp: 100.0,
        policy: highTaxes,
      );
      expect(baseConsumption, closeTo(60.0, 0.0001));
      expect(lowerConsumption, lessThan(baseConsumption));

      final spending = GdpCalculator.publicSpending(
        gdp: 100.0,
        policy: neutral,
      );
      expect(spending, closeTo(20.0, 0.0001));
    });

    test('clasifica el ritmo de crecimiento', () {
      expect(GdpCalculator.classify(5.0), contains('acelerada'));
      expect(GdpCalculator.classify(2.6), contains('sostenido'));
      expect(GdpCalculator.classify(-1.0), contains('Contraccion'));
    });
  });
}
