import 'package:fitness_app/core/entities/meal_item.dart';
import 'package:fitness_app/core/utilities/meal_parser.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/pages/meal_detail_page.dart';
import 'package:flutter/material.dart';

class SearchMealPage extends StatefulWidget {
  const SearchMealPage({super.key});

  @override
  State<SearchMealPage> createState() => _SearchMealPageState();
}

class _SearchMealPageState extends State<SearchMealPage> {
  List<MealItem> allMeals = [];
  List<MealItem> filteredMeals = [];
  String query = '';

  @override
  void initState() {
    super.initState();
    loadMealItemsFromAssets().then((meals) {
      setState(() {
        allMeals = meals;
        // filteredMeals = meals;
      });
    });
  }

  void updateSearch(String input) {
    if (input.isEmpty) {
      setState(() => filteredMeals = []);
      return;
    }
    setState(() {
      query = input.toLowerCase();
      filteredMeals =
          allMeals.where((meal) {
            return meal.foodName.toLowerCase().contains(query);
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Meals')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: updateSearch,
              decoration: InputDecoration(
                hintText: 'Search for meals...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child:
                filteredMeals.isEmpty
                    ? const Center(child: Text('No meals found.'))
                    : ListView.builder(
                      itemCount: filteredMeals.length,
                      itemBuilder: (context, index) {
                        final meal = filteredMeals[index];
                        return ListTile(
                          title: Text(meal.foodName),
                          subtitle: Text('${meal.calories} kcal'),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MealDetailPage(meal: meal),
                              ),
                            );
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
