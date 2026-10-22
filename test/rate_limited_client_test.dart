import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:rick_and_morty/services/rate_limited_client.dart';

void main() {
  final uri = Uri.parse('https://example.test/resource');

  test(
    'retries GET once after Retry-After and returns the successful response',
    () async {
      var requests = 0;
      var now = DateTime.utc(2026, 10, 22);
      final waited = <Duration>[];
      final inner = MockClient((request) async {
        requests++;
        if (requests == 1) {
          return http.Response(
            '{"status":429}',
            429,
            headers: {'retry-after': '2'},
          );
        }
        return http.Response('ok', 200);
      });
      final client = RateLimitedClient(
        inner,
        now: () => now,
        sleep: (duration) async {
          waited.add(duration);
          now = now.add(duration);
        },
      );

      final response = await client.get(uri);

      expect(response.statusCode, 200);
      expect(response.body, 'ok');
      expect(requests, 2);
      expect(waited, [const Duration(seconds: 2)]);
      client.close();
    },
  );

  test('short-circuits requests during a long shared cooldown', () async {
    var requests = 0;
    var now = DateTime.utc(2026, 10, 22);
    final waited = <Duration>[];
    final inner = MockClient((request) async {
      requests++;
      if (requests == 1) {
        return http.Response(
          jsonEncode({'cloudflare_error': true, 'error_code': 1015}),
          429,
          headers: {'retry-after': '30'},
        );
      }
      return http.Response('ok', 200);
    });
    final client = RateLimitedClient(
      inner,
      now: () => now,
      sleep: (duration) async {
        waited.add(duration);
        now = now.add(duration);
      },
    );

    final limited = await client.get(uri);
    expect(limited.statusCode, 429);
    expect(limited.body, contains('1015'));

    final locallyLimited = await client.get(uri);
    expect(locallyLimited.statusCode, 429);
    expect(locallyLimited.headers['x-app-rate-limit'], 'cooldown');
    expect(locallyLimited.headers['retry-after'], '30');
    expect(requests, 1);
    expect(waited, isEmpty);

    now = now.add(const Duration(seconds: 30));
    final success = await client.get(uri);
    expect(success.statusCode, 200);
    expect(requests, 2);
    client.close();
  });

  test(
    'returns the final 429 response body after retry budget is exhausted',
    () async {
      var requests = 0;
      var now = DateTime.utc(2026, 10, 22);
      final inner = MockClient((request) async {
        requests++;
        return http.Response(
          '{"error":"slow down"}',
          429,
          headers: {'retry-after': '1'},
        );
      });
      final client = RateLimitedClient(
        inner,
        maxRetries: 1,
        now: () => now,
        sleep: (duration) async => now = now.add(duration),
      );

      final response = await client.get(uri);

      expect(response.statusCode, 429);
      expect(response.body, contains('slow down'));
      expect(requests, 2);
      client.close();
    },
  );
}
