import 'package:flutter/material.dart';

import '../models/economy_state.dart';
import '../services/app_state.dart';
import '../services/history_utils.dart';
import '../services/simulation_engine.dart';
import '../widgets/app_palette.dart';
import '../widgets/educational_notice.dart';
import '../widgets/simple_bar_chart.dart';

/// Modulo 6: ejecucion de 1 a 5 periodos y comparacion de resultados.
class SimulationScreen extends StatefulWidget {
  const SimulationScreen({super.key});

  @override
  State<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen> {
  int _periods = 3;

  void _run() {
    appState.runSimulation(_periods);
    final message = 'Se simularon $_periods periodos.';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (BuildContext context, Widget? child) {
        final history = appState.history;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Simulacion'),
            backgroundColor: AppPalette.primary,
            foregroundColor: Colors.white,
            actions: <Widget>[
              IconButton(
                tooltip: 'Reiniciar economia',
                onPressed: appState.reset,
                icon: const Icon(Icons.restart_alt),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              SectionCard(
                title: 'Periodos a simular',
                subtitle: 'Entre 1 y ${SimulationEngine.maxPeriods} periodos',
                child: Column(
                  children: <Widget>[
                    _PeriodSelector(
                      value: _periods,
                      onChanged: (int value) {
                        setState(() {
                          _periods = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: _run,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Ejecutar simulacion'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppPalette.primary,
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                title: 'Comparacion de resultados',
                subtitle: 'Ultimos periodos registrados',
                child: _ResultsTable(history: HistoryUtils.last(history, 6)),
              ),
              const SizedBox(height: 16),
              SectionCard(
                title: 'Indice de estabilidad',
                subtitle: 'Indicador educativo entre 0 y 100',
                child: SimpleBarChart(
                  entries: _stabilityEntries(history),
                  decimals: 0,
                ),
              ),
              const SizedBox(height: 16),
              const EducationalNotice(),
            ],
          ),
        );
      },
    );
  }

  static List<ChartEntry> _stabilityEntries(List<EconomyState> history) {
    final visible = HistoryUtils.last(history, 6);
    return visible.map((EconomyState item) {
      return ChartEntry(label: 'P${item.period}', value: item.stabilityIndex);
    }).toList();
  }
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({
    required this.value,
    required this.onChanged,
  });

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final options = <int>[1, 2, 3, 4, 5];
    return Wrap(
      spacing: 8,
      children: options.map((int option) {
        return ChoiceChip(
          label: Text('$option'),
          selected: option == value,
          selectedColor: AppPalette.primary,
          labelStyle: TextStyle(
            color: option == value ? Colors.white : AppPalette.neutral,
            fontWeight: FontWeight.w600,
          ),
          onSelected: (bool selected) {
            if (selected) {
              onChanged(option);
            }
          },
        );
      }).toList(),
    );
  }
}

class _ResultsTable extends StatelessWidget {
  const _ResultsTable({required this.history});

  final List<EconomyState> history;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rows = <DataRow>[];
    for (final item in history) {
      rows.add(
        DataRow(
          cells: <DataCell>[
            DataCell(Text('P${item.period}')),
            DataCell(Text(item.gdpGrowth.toStringAsFixed(2))),
            DataCell(Text(item.inflation.toStringAsFixed(2))),
            DataCell(Text(item.unemployment.toStringAsFixed(2))),
            DataCell(Text(item.fiscalDeficit.toStringAsFixed(2))),
            DataCell(Text(item.publicDebt.toStringAsFixed(1))),
            DataCell(Text(item.stabilityIndex.toStringAsFixed(0))),
          ],
        ),
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingTextStyle: theme.textTheme.labelMedium,
        columnSpacing: 18,
        columns: const <DataColumn>[
          DataColumn(label: Text('Periodo')),
          DataColumn(label: Text('PIB %')),
          DataColumn(label: Text('Inflacion %')),
          DataColumn(label: Text('Desempleo %')),
          DataColumn(label: Text('Deficit %')),
          DataColumn(label: Text('Deuda %')),
          DataColumn(label: Text('Estabilidad')),
        ],
        rows: rows,
      ),
    );
  }
}
