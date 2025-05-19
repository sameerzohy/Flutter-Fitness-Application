import 'package:fitness_app/core/entities/meal_item.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/widgets/gradient_button.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/widgets/meal_detail_card.dart';
import 'package:flutter/material.dart';

class MealDetailPage extends StatefulWidget {
  final MealItem meal;

  const MealDetailPage({super.key, required this.meal});

  @override
  State<MealDetailPage> createState() => _MealDetailPageState();
}

class _MealDetailPageState extends State<MealDetailPage> {
  int _quantity = 1;
  final int min = 1;
  final int max = 100;
  late int selectedIndex;
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    selectedIndex = _quantity - min;
    _controller = FixedExtentScrollController(initialItem: selectedIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.meal.foodName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Opacity(
              opacity: 0.8, // 0.0 = fully transparent, 1.0 = fully opaque
              child: Image.asset(
                'assets/images/food_details_cover.jpg',
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Select Quantity',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 150,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey, width: 3),
                  bottom: BorderSide(color: Colors.grey, width: 3),
                ),
              ),
              child: Center(
                child: SizedBox(
                  height: 120, // 3 items visible (3 * 40)
                  width: 80,
                  child: ListWheelScrollView.useDelegate(
                    controller: _controller,
                    itemExtent: 40,
                    physics: const FixedExtentScrollPhysics(),
                    perspective: 0.002,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedIndex = index;
                        _quantity = min + index;
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: max - min + 1,
                      builder: (context, index) {
                        final value = min + index;
                        final isSelected = selectedIndex == index;
                        return Center(
                          child: Text(
                            '$value',
                            style: TextStyle(
                              fontSize: isSelected ? 28 : 24,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                              color: isSelected ? Colors.black : Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                MealDetailCard(
                  title: 'Calories',
                  value: (_quantity * widget.meal.calories).toStringAsFixed(2),
                ),
                MealDetailCard(
                  title: 'Carbs',
                  value: (_quantity * widget.meal.carbs).toStringAsFixed(2),
                ),
                MealDetailCard(
                  title: 'Protein',
                  value: (_quantity * widget.meal.protein).toStringAsFixed(2),
                ),
                MealDetailCard(
                  title: 'Fat',
                  value: (_quantity * widget.meal.fat).toStringAsFixed(2),
                ),
                MealDetailCard(
                  title: 'Fibre',
                  value: (_quantity * widget.meal.fiber).toStringAsFixed(2),
                ),
                MealDetailCard(
                  title: 'Sugar',
                  value: (_quantity * widget.meal.sugar).toStringAsFixed(2),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 30,
              ),
              child: GradientButton(buttonText: 'Add Meal', onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }
}
