import 'package:flutter/material.dart';

class StepsTracker extends StatelessWidget {
  const StepsTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 2),
          ),

          width: double.infinity,
          padding: const EdgeInsets.all(30),
          child: Image.asset(
            'assets/images/shoe-running-icon.png',
            height: 100,
            width: 100,
          ),
        ),
        const SizedBox(height: 10),
        Text('Steps: 1000/ 5000', style: TextStyle(fontSize: 18)),
      ],
    );
  }
}
