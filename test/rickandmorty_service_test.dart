import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty/dto/character.dart';
import 'package:rick_and_morty/dto/endpoints_response.dart';
import 'package:rick_and_morty/dto/paged_response.dart';
import 'package:rick_and_morty/infrastructure/rickandmorty_rest_api.dart';
import 'package:rick_and_morty/rest_api/api_errors.dart';
import 'package:rick_and_morty/services/rickandmorty_service.dart';

void main() {
  group('RickAndMortyService cache', () {
    test('reuses successful character results and force refresh reloads', () async {
      final api = _FakeRestApi();
      final service = RickAndMortyService(client: api);

      final first = await service.getCharacterById(2).value;
      final cached = await service.getCharacterById(2).value;
      final refreshed =
          await service.getCharacterById(2, refresh: true).value;

      expect(first.is1, isTrue);
      expect(cached.is1, isTrue);
      expect(refreshed.is1, isTrue);
      expect(api.characterCalls, 2);
    });

    test('does not cache unsuccessful API results', () async {
      final api = _FakeRestApi(failCharacterRequests: true);
      final service = RickAndMortyService(client: api);

      final first = await service.getCharacterById(2).value;
      final second = await service.getCharacterById(2).value;

      expect(first.is3, isTrue);
      expect(second.is3, isTrue);
      expect(api.characterCalls, 2);
    });

    test('uses the full page URI as the list cache key', () async {
      final api = _FakeRestApi();
      final service = RickAndMortyService(client: api);
      final firstPage = Uri.parse('https://example.test/character?page=1');
      final secondPage = Uri.parse('https://example.test/character?page=2');

      await service.getCharactersByUri(firstPage).value;
      await service.getCharactersByUri(firstPage).value;
      await service.getCharactersByUri(secondPage).value;

      expect(api.pageCalls, 2);
    });
  });
}

final class _FakeRestApi implements IRickAndMortyRestApi {
  int characterCalls = 0;
  int pageCalls = 0;
  final bool failCharacterRequests;

  _FakeRestApi({this.failCharacterRequests = false});

  @override
  Future<ApiResult<EndpointsResponse>> getEndpoints({bool force = false}) =>
      throw UnimplementedError();

  @override
  Future<ApiResult<PagedResponse<Character>>> getCharacters({
    CharacterFilter? filter,
  }) =>
      throw UnimplementedError();

  @override
  Future<ApiResult<PagedResponse<Character>>> getCharactersByUri(Uri uri) async {
    pageCalls++;
    return _page.u31;
  }

  @override
  Future<ApiResult<Character>> getCharacterById(int id) async {
    characterCalls++;
    if (failCharacterRequests) return ApiExceptionError(exception: Exception('failed')).u33;
    return _character(id).u31;
  }

  PagedResponse<Character> get _page => PagedResponse<Character>(
        info: const Info(count: 1, pages: 1, next: null, prev: null),
        results: [_character(1)],
      );

  Character _character(int id) => Character(
        id: id,
        name: 'Character $id',
        url: Uri.parse('https://example.test/character/$id'),
        created: DateTime.utc(2020),
        status: CharacterStatus.alive,
        species: 'Human',
        gender: CharacterGender.unknown,
        origin: CharacterLocation(name: 'Origin', url: Uri()),
        location: CharacterLocation(name: 'Location', url: Uri()),
        image: 'https://example.test/$id.jpg',
        episode: const [],
      );
}
