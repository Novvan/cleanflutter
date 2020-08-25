import 'dart:convert';

import 'package:cleanflutter/core/error/exceptions.dart';
import 'package:cleanflutter/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:cleanflutter/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl dataSourceImpl;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSourceImpl = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
      'Should return number trivia from Sharepreferences when there is one cached',
      () async {
        //arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('trivia_cached.json'));
        //act
        final result = await dataSourceImpl.getLastNumberTrivia();
        //assert
        verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
        expect(result, equals(tNumberTriviaModel));
      },
    );
    test(
      'Trow CacheException when there is not a cached value',
      () async {
        //arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        //act
        final call = dataSourceImpl.getLastNumberTrivia;
        //assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'Test trivia', number: 1);

    test(
      'Should call SharePreferences to cache the data',
      () async {
        //act
        dataSourceImpl.cacheNumberTrivia(tNumberTriviaModel);
        //assert
        final expectedJson = json.encode(tNumberTriviaModel);
        verify(mockSharedPreferences.setString(
            CACHED_NUMBER_TRIVIA, expectedJson));
      },
    );
  });
}
