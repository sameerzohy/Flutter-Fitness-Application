import 'package:fitness_app/core/theme/appPalatte.dart';


import 'package:fitness_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/pages/calorie_screen.dart';
import 'package:fitness_app/features/exercise_tracker/presentation/pages/exercise_tracker_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final bool isExercisePage = _currentIndex == 2;

    return Scaffold(
      appBar: isExercisePage
          ? PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: AppBar(
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppPallete.trackerContainerBackground1,
                        AppPallete.trackerContainerBackground1,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            )
          : AppBar(),
      body: _currentIndex == 0
          ? const HomeScreen()
          : _currentIndex == 1
              ? const CalorieScreen()
              : _currentIndex == 2
                  ? const ExercisePage()
                  : const Profile(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 27),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank_rounded, size: 27),
            label: 'Calorie',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center, size: 27),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 27),
            label: 'Profile',
          ),
        ],
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        currentIndex: _currentIndex,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Home Screen'));
  }
}

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Profile Page'));
  }
}
