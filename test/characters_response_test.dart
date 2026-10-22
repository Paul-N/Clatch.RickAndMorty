import 'package:http/http.dart' as http;
import 'package:rick_and_morty/rest_api/api_errors.dart';
import 'package:rick_and_morty/infrastructure/rickandmorty_rest_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getCharacters', () {
    test('returns getCharacters not filtered', () async {
      final api = RickAndMortyRestApi(
        client: http.Client(),
        baseUrl: 'https://rickandmortyapi.com',
      );

      final result = await api.getCharacters();

      expect(result.is1, isTrue);
      final response = result.as1;
      expect(response.info, isNotNull);
      expect(response.results, isNotNull);
      expect(response.results, isNotEmpty);
      final first = response.results.first;
      expect(first.id, isNot(0));
    });
    test('returns getCharacters filtered and paged', () async {
      final api = RickAndMortyRestApi(
        client: http.Client(),
        baseUrl: 'https://rickandmortyapi.com',
      );

      final testName = 'Rick';
      final result = await api.getCharactersByUri(Uri.parse('https://rickandmortyapi.com/api/character?page=2&name=$testName'));

      expect(result.is1, isTrue);
      final response = result.as1;
      expect(response.info, isNotNull);
      expect(response.results, isNotNull);
      expect(response.results, isNotEmpty);
      expect(response.results.any((element) => !element.name.toLowerCase().contains(testName.toLowerCase())), isFalse);
      final first = response.results.first;
      expect(first.id, isNot(0));
    });
    test('returns getCharacters non existed (404 case)', () async {
      final api = RickAndMortyRestApi(
        client: http.Client(),
        baseUrl: 'https://rickandmortyapi.com',
      );

      final testName = 'NEVER_EXISTED';
      final result = await api.getCharactersByUri(Uri.parse('https://rickandmortyapi.com/api/character?page=2&name=$testName'));

      expect(result.is3, isTrue);
      final excErr = result.as3 as ApiResponseError;
      expect(excErr, isNotNull);
      expect(excErr.statusCode, 404);
      expect(excErr.body, isNotNull);
      expect(excErr.body!.is1, isTrue);
      final errData = excErr.body!.as1;
      expect(errData, isNotEmpty);
      expect(errData['error'], isNotNull);
    });
    test('returns getCharacter by id', () async {
      final api = RickAndMortyRestApi(
        client: http.Client(),
        baseUrl: 'https://rickandmortyapi.com',
      );

      final result = await api.getCharacterById(2);

      expect(result.is1, isTrue);
      final response = result.as1;
      expect(response.id, 2);
      expect(response.name, isNotNull);
      expect(response.name.isEmpty, isFalse);
    });
  });
}
