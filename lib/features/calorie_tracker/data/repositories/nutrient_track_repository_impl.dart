import 'package:fitness_app/core/error/exception.dart';
import 'package:fitness_app/core/error/failure.dart';
import 'package:fitness_app/features/calorie_tracker/data/remotedatasources/nutrient_track_remote_datasource.dart';
import 'package:fitness_app/features/calorie_tracker/domain/repositories/nutrient_track_repo.dart';
import 'package:fpdart/fpdart.dart';

class NutrientTrackRepositoryImpl implements NutrientTrackRepository {
  final NutrientTrackRemoteDataSource nutrientTrackRemoteDataSource;
  const NutrientTrackRepositoryImpl(this.nutrientTrackRemoteDataSource);

  @override
  Future<Either<Failure, Map<DateTime, Map<String, dynamic>>>>
  fetchMealDataForWeek() async {
    try {
      final res = await nutrientTrackRemoteDataSource.fetchMealDataForWeek();
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
