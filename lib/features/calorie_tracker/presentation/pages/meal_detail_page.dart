import 'package:fitness_app/core/entities/meal_item.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/bloc/meal_track_bloc/meal_track_bloc.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/bloc/meal_utility_bloc/meal_utilities_bloc.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/widgets/gradient_button.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/widgets/meal_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MealDetailPage extends StatelessWidget {
  final MealItem meal;
  final String mealTime;
  final List<MealItem> meals;

  const MealDetailPage({
    super.key,
    required this.meal,
    required this.mealTime,
    required this.meals,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MealDetailCubit(),
      child: MealDetailView(meal: meal, mealTime: mealTime, meals: meals),
    );
  }
}

class MealDetailView extends StatelessWidget {
  final MealItem meal;
  final String mealTime;
  final List<MealItem> meals;

  const MealDetailView({
    super.key,
    required this.meal,
    required this.mealTime,
    required this.meals,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(meal.foodName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Opacity(
              opacity: 0.8,
              child: Image.asset(
                'assets/images/food_details_cover.jpg',
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                cacheWidth: 600,
              ),
            ),
            const SizedBox(height: 30),
            _QuantitySelector(unit: meal.unit),
            const SizedBox(height: 30),
            BlocSelector<MealDetailCubit, MealDetailState, int>(
              selector: (state) => state.quantity,
              builder: (context, quantity) {
                return _NutritionCards(meal: meal, quantity: quantity);
              },
            ),
            const SizedBox(height: 20),
            _AddMealButton(meal: meal, mealTime: mealTime, meals: meals),
          ],
        ),
      ),
    );
  }
}

class _QuantitySelector extends StatefulWidget {
  final String unit;
  const _QuantitySelector({required this.unit});

  @override
  State<_QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<_QuantitySelector> {
  static const int min = 1;
  static const int max = 100;
  late final FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<MealDetailCubit>();
    _controller = FixedExtentScrollController(
      initialItem: cubit.state.quantity - min,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MealDetailCubit, MealDetailState, int>(
      selector: (state) => state.quantity,
      builder: (context, quantity) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Select Quantity',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 150,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey, width: 3),
                      bottom: BorderSide(color: Colors.grey, width: 3),
                    ),
                  ),
                  child: Center(
                    child: SizedBox(
                      height: 120,
                      width: 80,
                      child: ListWheelScrollView.useDelegate(
                        controller: _controller,
                        itemExtent: 40,
                        physics: const FixedExtentScrollPhysics(),
                        perspective: 0.002,
                        onSelectedItemChanged: (index) {
                          context.read<MealDetailCubit>().updateQuantity(
                            min + index,
                          );
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: max - min + 1,
                          builder: (context, index) {
                            final value = min + index;
                            final isSelected = (quantity - min) == index;
                            return Center(
                              child: Text(
                                '$value',
                                style: TextStyle(
                                  fontSize: isSelected ? 28 : 24,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                  color:
                                      isSelected ? Colors.black : Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Text(
              widget.unit,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        );
      },
    );
  }
}

class _NutritionCards extends StatelessWidget {
  final MealItem meal;
  final int quantity;

  const _NutritionCards({required this.meal, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        MealDetailCard(
          title: 'Calories',
          value: (quantity * meal.calories).toStringAsFixed(2),
        ),
        MealDetailCard(
          title: 'Carbs',
          value: (quantity * meal.carbs).toStringAsFixed(2),
        ),
        MealDetailCard(
          title: 'Protein',
          value: (quantity * meal.protein).toStringAsFixed(2),
        ),
        MealDetailCard(
          title: 'Fat',
          value: (quantity * meal.fat).toStringAsFixed(2),
        ),
        MealDetailCard(
          title: 'Fibre',
          value: (quantity * meal.fiber).toStringAsFixed(2),
        ),
        MealDetailCard(
          title: 'Sugar',
          value: (quantity * meal.sugar).toStringAsFixed(2),
        ),
      ],
    );
  }
}

class _AddMealButton extends StatelessWidget {
  final MealItem meal;
  final String mealTime;
  final List<MealItem> meals;

  const _AddMealButton({
    required this.meal,
    required this.mealTime,
    required this.meals,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MealDetailCubit, MealDetailState, int>(
      selector: (state) => state.quantity,
      builder: (context, quantity) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
          child: GradientButton(
            buttonText: 'Add Meal',
            onPressed: () => _onAddMeal(context, quantity),
          ),
        );
      },
    );
  }

  void _onAddMeal(BuildContext context, int quantity) {
    final today = DateTime.now();
    final dateOnly = DateTime(today.year, today.month, today.day);

    final scaledMeal = MealItem(
      mealId: meal.mealId,
      foodName: meal.foodName,
      calories: meal.calories * quantity,
      carbs: meal.carbs * quantity,
      protein: meal.protein * quantity,
      fat: meal.fat * quantity,
      fiber: meal.fiber * quantity,
      sugar: meal.sugar * quantity,
      quantity: quantity,
      unit: meal.unit,
    );

    if (mealTime == 'save_meals') {
      meals.add(scaledMeal);
      context.read<MealUtilitiesBloc>().add(AddMealToSaved(addMealList: meals));
    } else {
      final bloc = context.read<MealTrackBloc>();
      bloc.add(
        AddMealLocal(mealItem: scaledMeal, mealTime: mealTime, date: dateOnly),
      );
      bloc.add(GetDailyMeals(date: dateOnly));
    }

    Navigator.pop(context);
  }
}

class MealDetailCubit extends Cubit<MealDetailState> {
  MealDetailCubit() : super(const MealDetailState());
  void updateQuantity(int quantity) => emit(state.copyWith(quantity: quantity));
}

class MealDetailState {
  final int quantity;
  const MealDetailState({this.quantity = 1});
  MealDetailState copyWith({int? quantity}) =>
      MealDetailState(quantity: quantity ?? this.quantity);
}
