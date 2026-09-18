import 'package:econauta/calculators/labor_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LaborCalculator', () {
    test('el desempleo baja cuando la economia crece sobre su potencial', () {
      final result = LaborCalculator.nextUnemployment(
        unemployment: 7.0,
        gdpGrowth: 4.5,
      );
      // 7 - 0.5 * (4.5 - 2.5) = 6.0
      expect(result, closeTo(6.0, 0.0001));
    });

    test('el desempleo sube cuando la economia se contrae', () {
      final result = LaborCalculator.nextUnemployment(
        unemployment: 7.0,
        gdpGrowth: -1.5,
      );
      // 7 - 0.5 * (-1.5 - 2.5) = 9.0
      expect(result, closeTo(9.0, 0.0001));
    });

    test('se mantiene estable con crecimiento potencial', () {
      final result = LaborCalculator.nextUnemployment(
        unemployment: 7.0,
        gdpGrowth: 2.5,
      );
      expect(result, closeTo(7.0, 0.0001));
    });

    test('respeta los limites del modelo', () {
      final floor = LaborCalculator.nextUnemployment(
        unemployment: 2.0,
        gdpGrowth: 10.0,
      );
      final ceiling = LaborCalculator.nextUnemployment(
        unemployment: 29.0,
        gdpGrowth: -8.0,
      );
      expect(floor, greaterThanOrEqualTo(LaborCalculator.minUnemployment));
      expect(ceiling, lessThanOrEqualTo(LaborCalculator.maxUnemployment));
    });

    test('calcula empleo y holgura laboral', () {
      expect(LaborCalculator.employmentRate(7.0), closeTo(93.0, 0.0001));
      expect(LaborCalculator.slack(7.0), closeTo(2.0, 0.0001));
      expect(LaborCalculator.classify(9.0), contains('holgura'));
      expect(LaborCalculator.classify(3.0), contains('recalentado'));
    });
  });
}
