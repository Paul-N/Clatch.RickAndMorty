import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:pauln10v_rick_and_morty_api/errors/api_errors.dart';
import 'package:pauln10v_rick_and_morty_api/service/rickandmorty_rest_api.dart';

const _baseUrl = 'https://rickandmortyapi.com';

void main() {
  late RickAndMortyRestApi api;

  setUp(() {
    api = RickAndMortyRestApi(client: http.Client(), baseUrl: _baseUrl);
  });

  group('getEpisodes', () {
    test('returns getEpisodes not filtered', () async {
      final result = await api.getEpisodes();

      expect(result.is1, isTrue);
      final response = result.as1;
      expect(response.info, isNotNull);
      expect(response.results, isNotNull);
      expect(response.results, isNotEmpty);
      final first = response.results.first;
      expect(first.id, isNot(0));
      expect(first.name, isNotEmpty);
      expect(first.episode, isNotEmpty);
    });

    test('returns getEpisodes filtered', () async {
      // the API matches the episode code by substring, e.g. S02E05
      final testSeason = 'S02';
      final result = await api
          .getEpisodesByUri(Uri.parse('$_baseUrl/api/episode?episode=$testSeason'));

      expect(result.is1, isTrue);
      final response = result.as1;
      expect(response.info, isNotNull);
      expect(response.results, isNotEmpty);
      expect(
        response.results.any((element) => !element.episode.startsWith(testSeason)),
        isFalse,
      );
    });

    test('returns getEpisodes paged', () async {
      final result =
      await api.getEpisodesByUri(Uri.parse('$_baseUrl/api/episode?page=2'));

      expect(result.is1, isTrue);
      final response = result.as1;
      expect(response.info, isNotNull);
      expect(response.results, isNotEmpty);
      // page 1 holds ids 1..20
      expect(response.results.first.id, greaterThan(20));
    });

    test('returns getEpisodes non existed (404 case)', () async {
      final testName = 'NEVER_EXISTED';
      final result = await api
          .getEpisodesByUri(Uri.parse('$_baseUrl/api/episode?name=$testName'));

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

    test('returns getEpisode by id', () async {
      final result = await api.getEpisodeById(2);

      expect(result.is1, isTrue);
      final response = result.as1;
      expect(response.id, 2);
      expect(response.name, isNotEmpty);
      expect(response.episode, 'S01E02');
    });

    test('returns getEpisode by ids', () async {
      final result = await api.getEpisodeByIds([2, 44]);

      expect(result.is1, isTrue);
      final response = result.as1;
      expect(response.length, 2);
      expect(response.elementAt(0), isNotNull);
      expect(response.elementAt(1), isNotNull);
    });

    test('returns getEpisode by a single id in the ids method', () async {
      // the API returns an object, not an array, for a single id
      final result = await api.getEpisodeByIds([2]);

      expect(result.is1, isTrue);
      final response = result.as1;
      expect(response.length, 1);
      expect(response.first.id, 2);
    });

    test('returns empty result for empty ids without calling the API', () async {
      final result = await api.getEpisodeByIds(const []);

      expect(result.is1, isTrue);
      expect(result.as1, isEmpty);
    });
  });
}