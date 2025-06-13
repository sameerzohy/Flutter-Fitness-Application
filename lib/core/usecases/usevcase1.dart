import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_app/core/error/failure.dart';


abstract class UseCase1<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}