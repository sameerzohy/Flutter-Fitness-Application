import 'package:fitness_app/core/error/exception.dart';
// import 'package:fitness_app/core/error/failure.dart';
import 'package:fitness_app/features/auth/data/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDatasource {
  Session? get currentUserSession;
  Future<UserModel> signupWithEmailPassword({
    required String name,

    required String email,
    required String password,
  });

  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getUserData();

  Future<UserModel?> updateUserInfo(Map<String, dynamic> data);

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDatasource {
  final SupabaseClient _supabaseClient;
  const AuthRemoteDataSourceImpl({required SupabaseClient supabaseClient})
    : _supabaseClient = supabaseClient;

  @override
  Session? get currentUserSession => _supabaseClient.auth.currentSession;

  @override
  Future<UserModel> signupWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await _supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {'name': name},
      );
      if (res.user == null) {
        throw ServerException(message: 'User is null');
      } else {
        UserModel user = UserModel(email: email, name: name, id: res.user!.id);
        return user;
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );
      UserModel? user = await getUserData();

      if (res.user == null || user == null) {
        throw ServerException(message: 'User is null');
      } else {
        return user;
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel?> getUserData() async {
    try {
      final res = await _supabaseClient
          .from('profiles')
          .select()
          .eq('id', currentUserSession!.user.id);
      final id = res.first['id'];
      final name = res.first['name'];
      final email = currentUserSession!.user.email!;
      final goal = res.first['goal'];
      final gender = res.first['gender'];
      final bmi = res.first['bmi'];
      final height = res.first['height'];
      final weight = res.first['weight'];
      final date_of_birth = res.first['date_of_birth'];
      UserModel user = UserModel(
        id: id,
        name: name,
        email: email,
        goal: goal,
        gender: gender,
        bmi: bmi,
        height: height,
        weight: weight,
        date_of_birth: date_of_birth,
      );

      return user;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel?> updateUserInfo(Map<String, dynamic> data) async {
    try {
      final res =
          await _supabaseClient
              .from('profiles')
              .update({
                'weight': data['weight'],
                'height': data['height'],
                'bmi': data['bmi'],
                'goal': data['goal'],
                'gender': data['gender'],
                'date_of_birth':
                    (data['date_of_birth'] as DateTime).toIso8601String(),
              })
              .eq('id', currentUserSession!.user.id)
              .select()
              .single();
      print(res);

      UserModel user = UserModel(
        email: currentUserSession!.user.email!,
        id: res['id'],
        name: res['name'],
        height: res['height'],
        weight: res['weight'],
        bmi: res['bmi'],
        goal: res['goal'],
        gender: res['gender'],
        date_of_birth: res['date_of_birth'],
      );
      return user;
    } catch (e) {
      print(e.toString());
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _supabaseClient.auth.signOut();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
