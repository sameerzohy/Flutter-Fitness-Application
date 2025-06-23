import 'package:fitness_app/features/calorie_tracker/presentation/bloc/meal_track_bloc/meal_track_bloc.dart';
import 'package:fitness_app/features/home_screen/presentation/pages/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/core/theme/appPalatte.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/pages/calorie_screen.dart';
import 'package:fitness_app/features/exercise_tracker/presentation/pages/exercise_tracker_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    CalorieScreen(),
    ExercisePage(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    context.read<MealTrackBloc>().add(GetDailyMeals(date: DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    final bool isExercisePage = _currentIndex == 2;

    return Scaffold(
      appBar:
          isExercisePage
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
              : AppBar(title: Text(_getAppBarTitle())),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
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
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Home';
      case 1:
        return 'Calorie Tracker';
      case 2:
        return '';
      case 3:
        return 'Profile';
      default:
        return '';
    }
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Profile Page'));
  }
}
