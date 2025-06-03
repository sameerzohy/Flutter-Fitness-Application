import 'package:fitness_app/core/entities/meal_item.dart';
import 'package:fitness_app/core/error/exception.dart';
import 'package:fitness_app/features/calorie_tracker/data/hive_models/hive_meal_item.dart';
import 'package:fitness_app/features/calorie_tracker/data/models/meal_item_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

abstract interface class MealTrackLocalDataSource {
  Future<MealItem> addMealItem(
    MealItem mealItem,
    String mealTime,
    DateTime date,
  );

  Future<List<MealItem>> getMealItems(DateTime date, String mealTime);

  Future<void> deleteMealItems(DateTime date, String mealTime, String mealId);
}

class MealTrackLocalDataSourceImpl implements MealTrackLocalDataSource {
  final Box<HiveMealItem> hiveBox;

  MealTrackLocalDataSourceImpl(this.hiveBox);

  String _generateKey(DateTime date, String mealTime) {
    final dateStr = date.toIso8601String().split('T').first;
    return '${dateStr}_$mealTime';
  }

  @override
  Future<MealItem> addMealItem(
    MealItem mealItem,
    String mealTime,
    DateTime date,
  ) async {
    try {
      // for subtracting and testing: .subtract(Duration(days: 1))
      final key = _generateKey(date, mealTime);

      final hiveMealItem = HiveMealItem(
        id: UniqueKey().toString(), // You can replace with UUID if preferred
        foodName: mealItem.foodName,
        calories: mealItem.calories,
        protein: mealItem.protein,
        carbs: mealItem.carbs,
        fat: mealItem.fat,
        fibre: mealItem.fiber,
        sugar: mealItem.sugar,
        quantity: mealItem.quantity.toDouble(),
        unit: mealItem.unit,
      );

      await hiveBox.put('${key}_${hiveMealItem.id}', hiveMealItem);
      // print(
      //   'response of adding meal in datasource' + hiveBox.toMap().toString(),
      // );
      return mealItem;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<MealItem>> getMealItems(DateTime date, String mealTime) async {
    try {
      final keyPrefix = _generateKey(date, mealTime);
      // print(keyPrefix + ' Get ID: keyPrefix');

      final List<MealItem> items = [];

      for (final entry in hiveBox.toMap().entries) {
        if (entry.key.toString().startsWith(keyPrefix)) {
          final e = entry.value;
          items.add(
            MealItemModel(
              mealId: e.id,
              foodName: e.foodName,
              calories: e.calories,
              protein: e.protein,
              carbs: e.carbs,
              fat: e.fat,
              fiber: e.fibre,
              sugar: e.sugar,
              quantity: e.quantity.toInt(),
              unit: e.unit,
            ),
          );
        }
      }

      return items;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteMealItems(
    DateTime date,
    String mealTime,
    String mealId,
  ) async {
    try {
      final key = '${_generateKey(date, mealTime)}_$mealId';
      await hiveBox.delete(key);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
