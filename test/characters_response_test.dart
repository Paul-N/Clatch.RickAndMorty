import 'package:http/http.dart' as http;
import 'package:rick_and_morty/dto/endpoints_response.dart';
import 'package:rick_and_morty/rest_api/rm_rest_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getEndpoints', () {
    test('returns EndpointsResponse on 200', () async {
      final api = RickAndMortyRestApi(
        client: http.Client(),
        baseUrl: 'https://rickandmortyapi.com',
      );

      final result = await api.getCharacters(EndpointsResponse(characters: Uri.parse('https://rickandmortyapi.com/api/character'), locations: Uri(), episodes: Uri()));

      expect(result.is1, isTrue);
      final response = result.as1;
      expect(response.info, isNotNull);
      expect(response.results, isNotNull);
      expect(response.results, isNotEmpty);
      final first = response.results.first;
      expect(first.id, isNot(0));
    });
  });
}
