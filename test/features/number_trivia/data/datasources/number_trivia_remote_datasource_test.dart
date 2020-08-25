import 'dart:convert';

import 'package:cleanflutter/core/error/exceptions.dart';
import 'package:cleanflutter/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:cleanflutter/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'package:http/http.dart' as http;

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSourceImpl;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSourceImpl = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpsClientSuccess() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpsClientFailure() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      '''Should perform a GET request on a URL with number 
    being the endpoint and with application/json header''',
      () async {
        //arrange
        setUpMockHttpsClientSuccess();
        //act
        dataSourceImpl.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockHttpClient.get(
          'http://numbersapi.com/$tNumber',
          headers: {'Content-Type': 'application/json'},
        ));
      },
    );
    test(
      'Should return number trivia when response code is 200',
      () async {
        //arrange
        setUpMockHttpsClientSuccess();
        //act
        final result = await dataSourceImpl.getConcreteNumberTrivia(tNumber);
        //assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'Throw ServerException when response error code',
      () async {
        //arrange
        setUpMockHttpsClientFailure();
        //act
        final call = dataSourceImpl.getConcreteNumberTrivia;
        //assert
        expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      '''Should perform a GET request on a URL with number 
    being the endpoint and with application/json header''',
      () async {
        //arrange
        setUpMockHttpsClientSuccess();
        //act
        dataSourceImpl.getRandomNumberTrivia();
        //assert
        verify(mockHttpClient.get(
          'http://numbersapi.com/random',
          headers: {'Content-Type': 'application/json'},
        ));
      },
    );
    test(
      'Should return random number trivia when response code is 200',
      () async {
        //arrange
        setUpMockHttpsClientSuccess();
        //act
        final result = await dataSourceImpl.getRandomNumberTrivia();
        //assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'Throw ServerException when response error code',
      () async {
        //arrange
        setUpMockHttpsClientFailure();
        //act
        final call = dataSourceImpl.getRandomNumberTrivia;
        //assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
