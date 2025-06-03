import 'package:fitness_app/core/entities/meal_combo.dart';
import 'package:fitness_app/core/error/exception.dart';
import 'package:fitness_app/features/calorie_tracker/data/models/save_meal_combo_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class SaveMealComboRemote {
  Future<void> addMealCombo(SaveMealCombo mealCombo);

  Future<void> deleteMealCombo(SaveMealCombo mealCombo);

  Future<void> updateMealCombo(SaveMealCombo mealCombo);

  Future<List<SaveMealCombo>> getMealcombo();
}

class SaveMealComboRemoteImpl implements SaveMealComboRemote {
  final SupabaseClient supabaseClient;

  const SaveMealComboRemoteImpl(this.supabaseClient);

  @override
  Future<void> addMealCombo(SaveMealCombo mealCombo) async {
    try {
      final userId = supabaseClient.auth.currentUser!.id;
      var json = mealCombo.toJson(userId);
      json.remove('id');
      await supabaseClient.from('save_meal_combos').upsert(json);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteMealCombo(SaveMealCombo mealCombo) async {
    try {
      await supabaseClient
          .from('save_meal_combos')
          .delete()
          .eq('id', mealCombo.mealId);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateMealCombo(SaveMealCombo mealCombo) async {
    try {
      final userId = supabaseClient.auth.currentUser!.id;
      print('calling update');

      await supabaseClient
          .from('save_meal_combos')
          .update(mealCombo.toJson(userId))
          .eq('id', mealCombo.mealId); // Add WHERE clause here

      print('success after update');
    } catch (e) {
      print(e.toString());
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<SaveMealCombo>> getMealcombo() async {
    try {
      final userId = supabaseClient.auth.currentUser!.id;
      final mealCombo = await supabaseClient
          .from('save_meal_combos')
          .select()
          .eq('user_id', userId);
      List<SaveMealCombo> res =
          mealCombo.map((e) => SaveMealComboModel.fromJson(e)).toList();
      // print('result of getting ${res[0].mealId}');
      return res;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
