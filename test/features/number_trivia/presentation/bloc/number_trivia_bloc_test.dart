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
  NumberTriviaBlock bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockInputConverter = MockInputConverter();
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();

    bloc = NumberTriviaBlock(
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

    test(
      'Should call the InputConverter to validate and convert the string',
      () async {
        //arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));
        //act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        //assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
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
  });
}
