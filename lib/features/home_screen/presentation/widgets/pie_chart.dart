import 'package:fitness_app/features/calorie_tracker/presentation/bloc/meal_track_bloc/meal_track_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class NutrientPieChart extends StatelessWidget {
  const NutrientPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MealTrackBloc, MealTrackState>(
      builder: (context, state) {
        List<_NutrientData> chartData = [
          _NutrientData('protein', 0),
          _NutrientData('calories', 0),
          _NutrientData('fat', 0),
          _NutrientData('carbs', 0),
        ];

        if (state is GetDailyMealsSuccess) {
          final meals = state.mealsByCategory['all_meals'] ?? [];

          chartData = [
            _NutrientData(
              'protein',
              meals.fold(0, (sum, item) => sum + item.protein),
            ),
            _NutrientData(
              'calories',
              meals.fold(0, (sum, item) => sum + item.calories),
            ),
            _NutrientData('fat', meals.fold(0, (sum, item) => sum + item.fat)),
            _NutrientData(
              'carbs',
              meals.fold(0, (sum, item) => sum + item.carbs),
            ),
          ];
        }

        return SfCircularChart(
          title: ChartTitle(text: 'Nutrient Breakdown'),
          legend: Legend(
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
          ),
          series: <PieSeries<_NutrientData, String>>[
            PieSeries<_NutrientData, String>(
              dataSource: chartData,
              xValueMapper: (_NutrientData data, _) => data.name,
              yValueMapper: (_NutrientData data, _) => data.value,
              dataLabelMapper:
                  (_NutrientData data, _) =>
                      '${data.name}: ${data.value.toStringAsFixed(1)}',
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                labelPosition: ChartDataLabelPosition.outside,
                connectorLineSettings: ConnectorLineSettings(
                  type: ConnectorType.curve,
                ),
              ),
              pointColorMapper: (_NutrientData data, _) {
                switch (data.name) {
                  case 'protein':
                    return Colors.redAccent;
                  case 'calories':
                    return Colors.lightBlueAccent;
                  case 'fat':
                    return const Color.fromARGB(255, 110, 255, 100);
                  case 'carbs':
                    return Colors.amberAccent;
                  default:
                    return Colors.grey;
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class _NutrientData {
  final String name;
  final double value;

  _NutrientData(this.name, this.value);
}
