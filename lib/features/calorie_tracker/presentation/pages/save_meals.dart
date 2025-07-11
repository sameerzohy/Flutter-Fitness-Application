import 'package:fitness_app/core/entities/meal_combo.dart';
import 'package:fitness_app/core/entities/meal_item.dart';
import 'package:fitness_app/features/calorie_tracker/data/models/meal_item_model.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/bloc/meal_utility_bloc/meal_utilities_bloc.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/pages/meal_search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SaveMealsRemote extends StatefulWidget {
  const SaveMealsRemote({super.key});

  @override
  State<SaveMealsRemote> createState() => _SaveMealsRemoteState();
}

class _SaveMealsRemoteState extends State<SaveMealsRemote> {
  List<SaveMealCombo> savedMeals = [];
  List<MealItem> foods = [];
  final TextEditingController _mealComboController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MealUtilitiesBloc>().add(GetMealComboEvent());
  }

  @override
  void dispose() {
    super.dispose();
    _mealComboController.dispose();
  }

  Future<dynamic> _modalBottomSheet(
    String title,
    List<MealItem> paraFood,
    String mealId,
    bool isUpdate,
  ) {
    if (title.isNotEmpty || paraFood.isNotEmpty) {
      foods =
          paraFood
              .map(
                (e) => MealItem(
                  calories: e.calories,
                  foodName: e.foodName,
                  carbs: e.carbs,
                  fat: e.fat,
                  fiber: e.fiber,
                  protein: e.protein,
                  quantity: e.quantity,
                  sugar: e.sugar,
                  unit: e.unit,
                  mealId: e.mealId,
                ),
              )
              .toList();

      _mealComboController.text = title;
    } else {
      foods = [];
      _mealComboController.text = '';
    }
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: BlocBuilder<MealUtilitiesBloc, MealUtilitiesState>(
              builder: (context, state) {
                if (state is AddMealSuccess) {
                  foods = state.mealList;
                }
                if (state is DeleteMealFromSavedSucess) {
                  foods = state.mealList;
                }
                return SafeArea(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.95,
                    child: Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 50),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: const Text(
                                  'Save Meals',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 25,

                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _mealComboController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Color.fromRGBO(182, 180, 194, 0.5),

                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 20,
                                ),
                                hintText: 'Meal Name',
                              ),
                              style: TextStyle(fontSize: 20),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter Meal Name';
                                }
                                return null;
                              },

                              autocorrect: false,
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Foods: ',
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.left,
                                ),
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.orange,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.add),
                                    color: Colors.white,
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder:
                                              (cxt) => SearchMealPage(
                                                mealTime: 'save_meals',
                                                meals: foods,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),
                            AddMealCard(meals: foods),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(
                                      context,
                                    ); // Close bottom sheet
                                  },
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (foods.isNotEmpty &&
                                        _mealComboController.text.isNotEmpty) {
                                      SaveMealCombo
                                      saveMealCombo = SaveMealCombo(
                                        mealComboName:
                                            _mealComboController.text,
                                        meals:
                                            foods
                                                .map(
                                                  (e) =>
                                                      MealItemModel.fromMealItem(
                                                        e,
                                                      ),
                                                )
                                                .toList(),
                                        mealId: mealId,
                                      );

                                      if (isUpdate) {
                                        context.read<MealUtilitiesBloc>().add(
                                          UpdateMealComboEvent(
                                            mealCombo: saveMealCombo,
                                          ),
                                        );
                                      } else {
                                        context.read<MealUtilitiesBloc>().add(
                                          AddMealComboEvent(
                                            mealCombo: saveMealCombo,
                                          ),
                                        );
                                      }

                                      Navigator.pop(context); // close modal
                                    } else {
                                      ScaffoldMessenger.of(context)
                                        ..hideCurrentSnackBar()
                                        ..showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Please make sure everything is filled',
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: Colors.redAccent,
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                    }
                                  },
                                  child: Text(
                                    isUpdate ? 'Update Meal' : 'Save Meal',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Meals')),
      body: BlocBuilder<MealUtilitiesBloc, MealUtilitiesState>(
        builder: (context, state) {
          if (state is GetMealComboSuccess) {
            savedMeals = state.savedMeals;
          }
          return ListView.builder(
            itemBuilder: (cxt, index) {
              return Container(
                margin: EdgeInsets.all(10),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row with meal name + buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  savedMeals[index].mealComboName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      _modalBottomSheet(
                                        savedMeals[index].mealComboName,
                                        savedMeals[index].meals,
                                        savedMeals[index].mealId,
                                        true,
                                      );
                                    },
                                    icon: Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      context.read<MealUtilitiesBloc>().add(
                                        DeleteMealComboEvent(
                                          mealCombo: savedMeals[index],
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Meal items list
                          if (savedMeals[index].meals.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                    savedMeals[index].meals.map((meal) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 4.0,
                                        ),
                                        child: Text(
                                          '• ${meal.foodName} (${meal.quantity} No)',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),
                          GetDetail(mealCombo: savedMeals[index]),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: savedMeals.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _modalBottomSheet('', [], '', false);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddMealCard extends StatelessWidget {
  final List<MealItem> meals;

  const AddMealCard({super.key, required this.meals});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 0),
        child:
            meals.isEmpty
                ? Text('No Foods are Added Yet')
                : ListView.builder(
                  itemCount: meals.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final meal = meals[index];
                    return ListTile(
                      title: Text(meal.foodName),
                      subtitle: Text(
                        '${meal.calories.toStringAsFixed(2)} kcal • ${meal.quantity} No',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          context.read<MealUtilitiesBloc>().add(
                            DeleteMealFromSaved(
                              deleteMealList: meals,
                              meal: meals[index],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
      ),
    );
  }
}

class GetDetail extends StatelessWidget {
  final SaveMealCombo mealCombo;

  const GetDetail({super.key, required this.mealCombo});

  @override
  Widget build(BuildContext context) {
    double calories = 0;
    double fat = 0;
    double protein = 0;
    double carbs = 0;

    for (var meal in mealCombo.meals) {
      calories += meal.calories;
      fat += meal.fat;
      protein += meal.protein;
      carbs += meal.carbs;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Calories: $calories'),
          Text('Fat: $fat'),
          Text('Protein: $protein'),
          Text('Carbs: $carbs'),
        ],
      ),
    );
  }
}
