import 'package:fitness_app/features/auth/presentation/pages/successful_register.dart';
import 'package:fitness_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Register3Ui extends StatefulWidget {
  final Map<String, dynamic> details;
  const Register3Ui({super.key, required this.details});
  @override
  State<Register3Ui> createState() => _Register3UiState();
}

class _Register3UiState extends State<Register3Ui> {
  final PageController _controller = PageController(viewportFraction: 0.8);

  final List<Map<String, String>> goals = [
    {
      "title": "Improve Shape",
      "image_uri": "assets/images/register3.1.png",
      "desc":
          "I have a low amount of body fat and need / want to build more muscle.",
    },
    {
      "title": "Lean & Tone",
      "image_uri": "assets/images/register3.2.png",
      "desc":
          "I'm 'skinny fat'. Look thin but have no shape. I want to add lean muscle.",
    },
    {
      "title": "Lose a Fat",
      "image_uri": "assets/images/register3.3.png",
      "desc":
          "I have over 20 lbs to lose. I want to drop fat and gain muscle mass.",
    },
  ];

  double _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "What is your goal ?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              "It will help us to choose a best program for you",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  double diff = (_currentPage - index).abs();
                  double opacity = max(
                    1.0 - diff,
                    0.3,
                  ); // Adjust 0.3 to set min opacity

                  return Opacity(
                    opacity: opacity,
                    child: Transform.scale(
                      scale: 1.0 - (0.05 * diff), // Optional: scale effect
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: GoalCard(
                          title: goals[index]['title']!,
                          description: goals[index]['desc']!,
                          imageUri: goals[index]['image_uri']!,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: AuthGradientButton(
                buttonText: 'Confirm',
                onPressed: () {
                  int ind = _currentPage.toInt();
                  widget.details['goal'] = goals[ind]['title'];
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (cxt) => SuccessfulRegister(details: widget.details),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GoalCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUri;

  const GoalCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUri,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFCC8FED), Color(0xFF6B50F6)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 12, spreadRadius: 2),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Image.asset(imageUri)), // Replace with image
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
