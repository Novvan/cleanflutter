import 'package:cleanflutter/core/error/failures.dart';
import 'package:cleanflutter/core/usecases/usecase.dart';
import 'package:cleanflutter/core/util/input_converter.dart';
import 'package:cleanflutter/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:cleanflutter/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:cleanflutter/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:cleanflutter/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockInputConverter = MockInputConverter();
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();

    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('InitialState should be empty', () {
    expect(bloc.initialState, equals(Empty()));
  });

  group('getTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'Test Trivia', number: 1);

    void setUpMockInputConverterSuccess() {
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumberParsed));
    }

    test(
      'Should call the InputConverter to validate and convert the string',
      () async {
        //arrange
        setUpMockInputConverterSuccess();
        //act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        //assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );
    test(
      'Should get data from the concrete use case',
      () async {
        //arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        //act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockGetConcreteNumberTrivia(any));
        //assert
        verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
      },
    );
    test(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        //arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        //assert later
        final expectedList = [
          Empty(),
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];
        expectLater(bloc.state, emitsInOrder(expectedList));
        //act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      },
    );
    test(
      'Block should emit [Error] when input is invalid',
      () async {
        //arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
        //assert later
        final expectedList = [
          Empty(),
          Error(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];
        expectLater(
          bloc.state,
          emitsInOrder(expectedList),
        );
        //act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      },
    );
    test(
      'Should emit [Loading, Error] when there was an error retrieving SERVER data',
      () async {
        //arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        //assert later
        final expectedList = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expectedList));
        //act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      },
    );
    test(
      'Should emit [Loading, Error] when there was an error retrieving CACHED data',
      () async {
        //arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        //assert later
        final expectedList = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expectedList));
        //act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      },
    );
  });

  group('getTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(text: 'Test Trivia', number: 1);

    test(
      'Should get data from the random use case',
      () async {
        //arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        //act
        bloc.dispatch(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(any));
        //assert
        verify(mockGetRandomNumberTrivia(NoParams()));
      },
    );
    test(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        //arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        //assert later
        final expectedList = [
          Empty(),
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];
        expectLater(bloc.state, emitsInOrder(expectedList));
        //act
        bloc.dispatch(GetTriviaForRandomNumber());
      },
    );
    test(
      'Should emit [Loading, Error] when there was an error retrieving SERVER data',
      () async {
        //arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        //assert later
        final expectedList = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expectedList));
        //act
        bloc.dispatch(GetTriviaForRandomNumber());
      },
    );
    test(
      'Should emit [Loading, Error] when there was an error retrieving CACHED data',
      () async {
        //arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        //assert later
        final expectedList = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expectedList));
        //act
        bloc.dispatch(GetTriviaForRandomNumber());
      },
    );
  });
}
