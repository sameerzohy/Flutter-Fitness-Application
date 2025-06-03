import 'package:fitness_app/features/calorie_tracker/presentation/bloc/meal_track_bloc/meal_track_bloc.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/widgets/weekly_bar_chart.dart';
import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';

class MealNutrientAnalysis extends StatefulWidget {
  const MealNutrientAnalysis({super.key});

  @override
  State<MealNutrientAnalysis> createState() => _MealNutrientAnalysisState();
}

class _MealNutrientAnalysisState extends State<MealNutrientAnalysis> {
  Map<DateTime, Map<String, dynamic>> nutrientData = {};
  List<DateTime> keys = [];
  int pageIndex = 0;
  final PageController _pageController = PageController();

  final List<String> mealTypes = [
    'breakfast',
    'morningsnack',
    'lunch',
    'eveningsnack',
    'dinner',
  ];

  final List<String> mealTitles = [
    'BreakFast',
    'Morning Snack',
    'Lunch',
    'Evening Snack',
    'Dinner',
  ];

  @override
  void initState() {
    super.initState();
    context.read<MealTrackBloc>().add(GetNutrientInfo());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Meal Nutrient Analysis")),
      body: BlocBuilder<MealTrackBloc, MealTrackState>(
        builder: (context, state) {
          if (state is GetNutrientInfoFailure) {
            return Center(child: Text(state.message));
          }
          if (state is GetNutrientInfoSuccess) {
            nutrientData = state.nutrientInfo;
            keys = nutrientData.keys.toList();
          }

          return Column(
            children: [
              SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        setState(() {
                          pageIndex = pageIndex == 0 ? 0 : pageIndex - 1;
                        });
                        _pageController.jumpToPage(pageIndex);
                      },
                    ),
                    Text(mealTitles[pageIndex], style: TextStyle(fontSize: 20)),
                    IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () {
                        setState(() {
                          pageIndex = pageIndex == 4 ? 4 : pageIndex + 1;
                        });
                        _pageController.jumpToPage(pageIndex);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: mealTypes.length,
                  onPageChanged: (index) {
                    setState(() {
                      pageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final meal = mealTypes[index];
                    final mealTitle = mealTitles[index];
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          WeeklyBarChart(
                            nutrientData: nutrientData,
                            keys: keys,
                            keyName: '${meal}_calories',
                            charTitle: '$mealTitle Calories',
                          ),
                          const SizedBox(height: 30),
                          WeeklyBarChart(
                            nutrientData: nutrientData,
                            keys: keys,
                            keyName: '${meal}_protein',
                            charTitle: '$mealTitle Protein',
                          ),
                          const SizedBox(height: 30),
                          WeeklyBarChart(
                            nutrientData: nutrientData,
                            keys: keys,
                            keyName: '${meal}_carbs',
                            charTitle: '$mealTitle Carbs',
                          ),
                          const SizedBox(height: 30),
                          WeeklyBarChart(
                            nutrientData: nutrientData,
                            keys: keys,
                            keyName: '${meal}_fat',
                            charTitle: '$mealTitle Fat',
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
