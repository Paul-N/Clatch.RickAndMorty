import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:rick_and_morty/cache/image_file_store.dart'; // adjust the paths
import 'package:rick_and_morty/cache/ttl_cache.dart';
import 'package:rick_and_morty/infrastructure/rickandmorty_rest_api.dart';

void main() {
  group('TtlCache', () {
    const ttl = Duration(minutes: 5);
    late DateTime now;
    late int loads;
    late TtlCache<String> cache;

    Future<int> load() async => ++loads;

    setUp(() {
      now = DateTime.utc(2026, 10, 21);
      loads = 0;
      cache = TtlCache(maxEntries: 2, now: () => now);
    });

    test('serves from the cache until the ttl expires', () async {
      expect(await cache.fetch('a', load, ttl: ttl), 1);

      now = now.add(const Duration(minutes: 4));
      expect(await cache.fetch('a', load, ttl: ttl), 1);

      now = now.add(const Duration(minutes: 2));
      expect(await cache.fetch('a', load, ttl: ttl), 2);
    });

    test('concurrent callers share one in-flight load', () async {
      final gate = Completer<void>();
      Future<int> slow() async {
        await gate.future;
        return ++loads;
      }

      final a = cache.fetch('a', slow, ttl: ttl);
      final b = cache.fetch('a', slow, ttl: ttl);
      gate.complete();

      expect(await a, 1);
      expect(await b, 1);
      expect(loads, 1);
    });

    test('refresh bypasses a fresh entry and replaces it', () async {
      expect(await cache.fetch('a', load, ttl: ttl), 1);
      expect(await cache.fetch('a', load, ttl: ttl, refresh: true), 2);
      expect(await cache.fetch('a', load, ttl: ttl), 2);
    });

    test('values rejected by cacheable are not kept', () async {
      bool cacheable(int v) => v > 1;

      expect(
        await cache.fetch('a', load, ttl: ttl, cacheable: cacheable),
        1,
      ); // rejected
      expect(
        await cache.fetch('a', load, ttl: ttl, cacheable: cacheable),
        2,
      ); // kept
      expect(
        await cache.fetch('a', load, ttl: ttl, cacheable: cacheable),
        2,
      ); // cached
      expect(loads, 2);
    });

    test('errors are not cached', () async {
      var calls = 0;
      Future<int> flaky() async {
        if (++calls == 1) throw StateError('boom');
        return calls;
      }

      await expectLater(cache.fetch('a', flaky, ttl: ttl), throwsStateError);
      expect(await cache.fetch('a', flaky, ttl: ttl), 2);
    });

    test('drops the oldest entries beyond maxEntries', () async {
      await cache.fetch('a', load, ttl: ttl);
      await cache.fetch('b', load, ttl: ttl);
      await cache.fetch('c', load, ttl: ttl); // evicts 'a'
      expect(loads, 3);

      await cache.fetch('b', load, ttl: ttl); // still cached
      expect(loads, 3);

      await cache.fetch('a', load, ttl: ttl); // loaded again
      expect(loads, 4);
    });
  });

  group('ImageFileStore', () {
    final url = Uri.parse(
      'https://rickandmortyapi.com/api/character/avatar/2.jpeg',
    );
    final bytes = Uint8List.fromList([1, 2, 3, 4]);
    late Directory dir;
    late int requests;

    ImageFileStore newStore({
      int status = 200,
      String contentType = 'image/jpeg',
    }) {
      return ImageFileStore(
        directory: dir,
        client: MockClient((http.Request request) async {
          requests++;
          return http.Response.bytes(
            bytes,
            status,
            headers: {
              'content-type': contentType,
              'cache-control': 'public, max-age=7776000, immutable',
            },
          );
        }),
      );
    }

    setUp(() async {
      dir = await Directory.systemTemp.createTemp('image_file_store_test');
      requests = 0;
    });

    tearDown(() async {
      if (await dir.exists()) await dir.delete(recursive: true);
    });

    test(
      'downloads once, then serves from disk even after a restart',
      () async {
        expect(await newStore().get(url), bytes);
        expect(await newStore().get(url), bytes); // a new store = a new app run
        expect(requests, 1);
      },
    );

    test('concurrent gets share one download', () async {
      final store = newStore();
      final results = await Future.wait([store.get(url), store.get(url)]);

      expect(results[0], bytes);
      expect(results[1], bytes);
      expect(requests, 1);
    });

    test(
      'does not persist responses without the immutable directive',
      () async {
        final client = MockClient((request) async {
          requests++;
          return http.Response.bytes(
            bytes,
            200,
            headers: {
              'content-type': 'image/jpeg',
              'cache-control': 'public, max-age=60',
            },
          );
        });
        final store = ImageFileStore(client: client, directory: dir);

        expect(await store.get(url), bytes);
        expect(await store.get(url), bytes);
        expect(requests, 2);
        client.close();
      },
    );

    test('non-200 and non-image responses fail and cache nothing', () async {
      await expectLater(
        newStore(status: 429).get(url),
        throwsA(isA<http.ClientException>()),
      );
      await expectLater(
        newStore(contentType: 'text/html').get(url),
        throwsA(isA<http.ClientException>()),
      );

      expect(await newStore().get(url), bytes); // still a miss: downloads now
      expect(requests, 3);
    });

    test('clear() removes every cached image', () async {
      final store = newStore();
      await store.get(url);
      await store.clear();
      await store.get(url);

      expect(requests, 2);
    });
  });

  group('REST API TTL cache', () {
    test(
      'caches parsed endpoint data and force refresh bypasses the cache',
      () async {
        var requests = 0;
        final client = MockClient((request) async {
          requests++;
          return http.Response(
            '{"characters":"https://example.test/api/character",'
            '"locations":"https://example.test/api/location",'
            '"episodes":"https://example.test/api/episode"}',
            200,
            headers: {'content-type': 'application/json'},
          );
        });
        final api = RickAndMortyRestApi(
          client: client,
          baseUrl: 'https://example.test',
        );

        expect((await api.getEndpoints()).is1, isTrue);
        expect((await api.getEndpoints()).is1, isTrue);
        expect(requests, 1);

        expect((await api.getEndpoints(force: true)).is1, isTrue);
        expect(requests, 2);
        client.close();
      },
    );
  });
}
