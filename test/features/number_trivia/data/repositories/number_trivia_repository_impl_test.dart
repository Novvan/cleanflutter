import 'package:cleanflutter/core/error/exceptions.dart';
import 'package:cleanflutter/core/error/failures.dart';
import 'package:cleanflutter/core/platform/network_info.dart';
import 'package:cleanflutter/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:cleanflutter/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:cleanflutter/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:cleanflutter/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:cleanflutter/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

main() {
  NumberTriviaRepositoryImpl repositoryImpl;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repositoryImpl = NumberTriviaRepositoryImpl(
      remoteDatasource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('Device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestsOffline(Function body) {
    group('Device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumbertriviamodel =
        NumberTriviaModel(text: "Test text", number: tNumber);
    final NumberTrivia tNumberTrivia = tNumbertriviamodel;

    runTestsOnline(() {
      test(
        'Should return remote data when the call to remote data source is successful',
        () async {
          //arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumbertriviamodel);
          //act
          final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
          //assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          expect(result, equals(Right(tNumberTrivia)));
        },
      );
      test(
        'Should cache the data locally when the call to remote data source is successful',
        () async {
          //arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumbertriviamodel);
          //act
          final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
          //assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verify(mockLocalDataSource.cacheNumberTrivia(tNumbertriviamodel));
        },
      );
      test(
        'Should return server failure when the call to remote data source is unsuccessful',
        () async {
          //arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenThrow(ServerException());
          //act
          final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
          //assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'Should return last locally cached data when cached data is present',
        () async {
          //arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTrivia);
          //act
          final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );
      test(
        'Should return CacheFailure when there is no cached data present',
        () async {
          //arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          //act
          final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumbertriviamodel =
        NumberTriviaModel(text: "Test text", number: 123);
    final NumberTrivia tNumberTrivia = tNumbertriviamodel;

    runTestsOnline(() {
      test(
        'Should return remote data when the call to remote data source is successful',
        () async {
          //arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumbertriviamodel);
          //act
          final result = await repositoryImpl.getRandomNumberTrivia();
          //assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );
      test(
        'Should cache the data locally when the call to remote data source is successful',
        () async {
          //arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumbertriviamodel);
          //act
          final result = await repositoryImpl.getRandomNumberTrivia();
          //assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verify(mockLocalDataSource.cacheNumberTrivia(tNumbertriviamodel));
        },
      );
      test(
        'Should return server failure when the call to remote data source is unsuccessful',
        () async {
          //arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenThrow(ServerException());
          //act
          final result = await repositoryImpl.getRandomNumberTrivia();
          //assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'Should return last locally cached data when cached data is present',
        () async {
          //arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTrivia);
          //act
          final result = await repositoryImpl.getRandomNumberTrivia();
          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );
      test(
        'Should return CacheFailure when there is no cached data present',
        () async {
          //arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          //act
          final result = await repositoryImpl.getRandomNumberTrivia();
          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
