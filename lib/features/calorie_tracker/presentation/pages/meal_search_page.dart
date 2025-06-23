import 'package:fitness_app/core/entities/meal_combo.dart';
import 'package:fitness_app/core/entities/meal_item.dart';
import 'package:fitness_app/core/utilities/meal_parser.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/bloc/meal_utility_bloc/meal_utilities_bloc.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/pages/meal_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchMealPage extends StatelessWidget {
  final String mealTime;
  final List<MealItem> meals;

  const SearchMealPage({
    super.key,
    required this.mealTime,
    required this.meals,
  });

  @override
  Widget build(BuildContext context) {
    context.read<MealUtilitiesBloc>().add(GetMealComboEvent());

    return BlocProvider(
      create: (context) => SearchMealCubit()..initialize(),
      child: SearchMealView(mealTime: mealTime, meals: meals),
    );
  }
}

class SearchMealView extends StatelessWidget {
  final String mealTime;
  final List<MealItem> meals;

  const SearchMealView({
    super.key,
    required this.mealTime,
    required this.meals,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Meals'), elevation: 0),
      body: MultiBlocListener(
        listeners: [
          BlocListener<MealUtilitiesBloc, MealUtilitiesState>(
            listener: (context, state) {
              if (state is GetMealComboSuccess) {
                context.read<SearchMealCubit>().onSavedMealsLoaded(
                  state.savedMeals,
                );
              }
            },
          ),
        ],
        child: Column(
          children: [
            // Search Bar
            const _SearchBar(),
            // Content
            Expanded(
              child: BlocBuilder<SearchMealCubit, SearchMealState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      _buildSectionHeader(context, state),
                      Expanded(child: _buildMealsList(context, state)),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, SearchMealState state) {
    if (state.searchQuery.isEmpty && state.savedMeals.isNotEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: const Text(
          'Your Saved Meals',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      );
    }

    if (state.searchQuery.isNotEmpty && state.filteredMeals.isNotEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          'Search Results (${state.filteredMeals.length})',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildMealsList(BuildContext context, SearchMealState state) {
    // Show loading indicatorx
    if (state.isLoadingAssets && state.savedMeals.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading meals...'),
          ],
        ),
      );
    }

    // Show empty state
    if (state.filteredMeals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              state.searchQuery.isEmpty
                  ? Icons.bookmark_border
                  : Icons.search_off,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              state.searchQuery.isEmpty
                  ? 'No saved meals yet.\nStart by creating meal combos!'
                  : 'No meals found for "${state.searchQuery}"',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // Show meals list
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: state.filteredMeals.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final meal = state.filteredMeals[index];
        return _MealListTile(
          meal: meal,
          onTap: () => _navigateToMealDetail(context, meal),
        );
      },
    );
  }

  void _navigateToMealDetail(BuildContext context, MealItem meal) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder:
            (context, animation, secondaryAnimation) =>
                MealDetailPage(meal: meal, mealTime: mealTime, meals: meals),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}

// Separate search bar widget for better organization
class _SearchBar extends StatefulWidget {
  const _SearchBar();

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _controller,
        onChanged:
            (query) => context.read<SearchMealCubit>().updateSearch(query),
        decoration: InputDecoration(
          hintText: 'Search for meals...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon:
              _controller.text.isNotEmpty
                  ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      context.read<SearchMealCubit>().updateSearch('');
                    },
                  )
                  : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}

// Cubit for state management
class SearchMealCubit extends Cubit<SearchMealState> {
  SearchMealCubit() : super(const SearchMealState());

  Future<void> initialize() async {
    try {
      // Load asset meals
      final meals = await loadMealItemsFromAssets();
      emit(state.copyWith(allMeals: meals, isLoadingAssets: false));
      _updateFilteredMeals();
    } catch (e) {
      emit(state.copyWith(isLoadingAssets: false));
      _updateFilteredMeals();
      debugPrint('Error loading meals from assets: $e');
    }
  }

  void onSavedMealsLoaded(List<SaveMealCombo> savedMeals) {
    if (!state.hasInitializedSavedMeals) {
      final convertedMeals = _convertSavedMealsToMealItems(savedMeals);
      emit(
        state.copyWith(
          savedMeals: convertedMeals,
          hasInitializedSavedMeals: true,
        ),
      );
      _updateFilteredMeals();
    }
  }

  void updateSearch(String query) {
    emit(state.copyWith(searchQuery: query.trim().toLowerCase()));
    _updateFilteredMeals();
  }

  void _updateFilteredMeals() {
    final searchQuery = state.searchQuery;
    List<MealItem> filtered;

    if (searchQuery.isEmpty) {
      filtered = List.from(state.savedMeals);
    } else {
      filtered =
          state.allMeals
              .where(
                (meal) => meal.foodName.toLowerCase().contains(searchQuery),
              )
              .toList();
    }

    emit(state.copyWith(filteredMeals: filtered));
  }

  List<MealItem> _convertSavedMealsToMealItems(List<SaveMealCombo> savedMeals) {
    return savedMeals.map((savedItem) {
      final totals = savedItem.meals.fold(
        <String, double>{
          'calories': 0.0,
          'fat': 0.0,
          'carbs': 0.0,
          'protein': 0.0,
          'fiber': 0.0,
          'sugar': 0.0,
        },
        (totals, meal) {
          totals['calories'] = totals['calories']! + meal.calories;
          totals['fat'] = totals['fat']! + meal.fat;
          totals['carbs'] = totals['carbs']! + meal.carbs;
          totals['protein'] = totals['protein']! + meal.protein;
          totals['fiber'] = totals['fiber']! + meal.fiber;
          totals['sugar'] = totals['sugar']! + meal.sugar;
          return totals;
        },
      );

      return MealItem(
        mealId: savedItem.mealId,
        foodName: savedItem.mealComboName,
        calories: totals['calories']!,
        fat: totals['fat']!,
        carbs: totals['carbs']!,
        protein: totals['protein']!,
        fiber: totals['fiber']!,
        sugar: totals['sugar']!,
        quantity: 1,
        unit: 'combo',
      );
    }).toList();
  }
}

// State class
class SearchMealState {
  final List<MealItem> allMeals;
  final List<MealItem> savedMeals;
  final List<MealItem> filteredMeals;
  final String searchQuery;
  final bool isLoadingAssets;
  final bool hasInitializedSavedMeals;

  const SearchMealState({
    this.allMeals = const [],
    this.savedMeals = const [],
    this.filteredMeals = const [],
    this.searchQuery = '',
    this.isLoadingAssets = true,
    this.hasInitializedSavedMeals = false,
  });

  SearchMealState copyWith({
    List<MealItem>? allMeals,
    List<MealItem>? savedMeals,
    List<MealItem>? filteredMeals,
    String? searchQuery,
    bool? isLoadingAssets,
    bool? hasInitializedSavedMeals,
  }) {
    return SearchMealState(
      allMeals: allMeals ?? this.allMeals,
      savedMeals: savedMeals ?? this.savedMeals,
      filteredMeals: filteredMeals ?? this.filteredMeals,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoadingAssets: isLoadingAssets ?? this.isLoadingAssets,
      hasInitializedSavedMeals:
          hasInitializedSavedMeals ?? this.hasInitializedSavedMeals,
    );
  }
}

// Keep the existing _MealListTile widget as it's already optimized
class _MealListTile extends StatelessWidget {
  final MealItem meal;
  final VoidCallback onTap;

  const _MealListTile({required this.meal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(
        meal.foodName,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text('${meal.calories.toStringAsFixed(0)} kcal'),
          if (meal.unit == 'combo')
            const Text(
              'Meal Combo',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
