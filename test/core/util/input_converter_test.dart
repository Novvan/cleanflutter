import 'package:cleanflutter/core/util/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

void main() {
  InputConverter inputConverter;
  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
      'Should return an int when the string represents an unsigned integer',
      () async {
        //arrange
        final str = '123';
        //act
        final result = inputConverter.stringToUnsignedInteger(str);
        //assert
        expect(result, Right(123));
      },
    );
    test(
      'Should return a failure when string is not an integer',
      () async {
        //arrange
        final str = 'abc';
        //act
        final result = inputConverter.stringToUnsignedInteger(str);
        //assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
    test(
      'Should return failure when negative integer',
      () async {
        //arrange
        final str = '-123';
        //act
        final result = inputConverter.stringToUnsignedInteger(str);
        //assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
  });
}
