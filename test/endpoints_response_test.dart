import 'package:clock/clock.dart';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty/infrastructure/rickandmorty_rest_api.dart';
import 'package:flutter_test/flutter_test.dart';

final _clock = Clock();

void main() {
  group('getEndpoints', () {
    test('returns EndpointsResponse on 200', () async {
      final api = RickAndMortyRestApi(
        client: http.Client(),
        baseUrl: 'https://rickandmortyapi.com',
        clock: _clock,
      );

      final result = await api.getEndpoints();

      expect(result.is1, isTrue);
      final response = result.as1;
      expect(response.characters, Uri.parse('https://rickandmortyapi.com/api/character'));
      expect(response.locations, Uri.parse('https://rickandmortyapi.com/api/location'));
      expect(response.episodes, Uri.parse('https://rickandmortyapi.com/api/episode'));
    });
  });
}
