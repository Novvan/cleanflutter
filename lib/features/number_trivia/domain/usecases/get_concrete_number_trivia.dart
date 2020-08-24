import 'package:cleanflutter/core/error/failures.dart';
import 'package:cleanflutter/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:cleanflutter/features/number_trivia/domain/repositories/number_trivia_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class GetConcreteNumberTrivia {
  final NumberTriviaRepo repository;
  GetConcreteNumberTrivia(this.repository);
  Future<Either<Failure, NumberTrivia>> execute({
    @required int number,
  }) async {
    return await repository.getConcreteNumberTrivia(number);
  }
}
