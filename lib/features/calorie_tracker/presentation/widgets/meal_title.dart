import 'package:fitness_app/features/calorie_tracker/presentation/pages/meal_search_page.dart';
import 'package:flutter/material.dart';

class MealTitle extends StatelessWidget {
  final String title;
  // final VoidCallback onTap;
  const MealTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        CircleAvatar(
          backgroundColor: Colors.grey.shade200,
          child: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 150),
                  pageBuilder:
                      (context, animation, secondaryAnimation) =>
                          SearchMealPage(mealTime: title, meals: []),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              );
            },
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
