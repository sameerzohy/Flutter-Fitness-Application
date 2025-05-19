import 'package:flutter/material.dart';

class MealCard extends StatefulWidget {
  const MealCard({super.key});

  @override
  State<MealCard> createState() => MealCardState();
}

class MealCardState extends State<MealCard> {
  List<dynamic> meals = ['Dosa', 'idly'];
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        child: ListView.builder(
          itemCount: meals.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (cxt, index) {
            return ListTile(title: Text(meals[index]));
          },
        ),
      ),
    );
  }
}
