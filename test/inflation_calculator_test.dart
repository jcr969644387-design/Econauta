import 'package:econauta/calculators/inflation_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InflationCalculator', () {
    test('converge hacia la meta cuando no hay impulso de demanda', () {
      final result = InflationCalculator.nextInflation(
        currentInflation: 4.0,
        inflationTarget: 2.0,
        demandImpulse: 0.0,
        unemployment: 7.0,
      );
      // 4 + 0 - (7 - 5) * 0.10 + (2 - 4) * 0.15 = 3.5
      expect(result, closeTo(3.5, 0.0001));
    });

    test('sube cuando existe un impulso de demanda positivo', () {
      final base = InflationCalculator.nextInflation(
        currentInflation: 4.0,
        inflationTarget: 2.0,
        demandImpulse: 0.0,
        unemployment: 7.0,
      );
      final expansive = InflationCalculator.nextInflation(
        currentInflation: 4.0,
        inflationTarget: 2.0,
        demandImpulse: 2.0,
        unemployment: 7.0,
      );
      expect(expansive, greaterThan(base));
      expect(expansive, closeTo(4.4, 0.0001));
    });

    test('un mercado laboral ajustado presiona los precios', () {
      final tight = InflationCalculator.nextInflation(
        currentInflation: 4.0,
        inflationTarget: 2.0,
        demandImpulse: 0.0,
        unemployment: 3.0,
      );
      final slack = InflationCalculator.nextInflation(
        currentInflation: 4.0,
        inflationTarget: 2.0,
        demandImpulse: 0.0,
        unemployment: 9.0,
      );
      expect(tight, greaterThan(slack));
    });

    test('respeta los limites del modelo', () {
      final result = InflationCalculator.nextInflation(
        currentInflation: 59.0,
        inflationTarget: 2.0,
        demandImpulse: 50.0,
        unemployment: 1.0,
      );
      expect(result, lessThanOrEqualTo(InflationCalculator.maxInflation));
    });

    test('clasifica la brecha respecto a la meta', () {
      final high = InflationCalculator.classify(inflation: 8.0, target: 2.0);
      final low = InflationCalculator.classify(inflation: 0.0, target: 4.0);
      final onTarget = InflationCalculator.classify(
        inflation: 2.4,
        target: 2.0,
      );
      expect(high, contains('encima'));
      expect(low, contains('debajo'));
      expect(onTarget, contains('cercana'));
      expect(InflationCalculator.gap(inflation: 8.0, target: 2.0), 6.0);
    });
  });
}
