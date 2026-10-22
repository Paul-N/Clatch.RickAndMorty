import 'dart:async';

/// Keyed time-to-live cache for async results.
///
/// * Concurrent callers for the same key share one in-flight load.
/// * A finished load is kept for `ttl`.
/// * Failures (and values rejected by `cacheable`) are never kept.
/// * At most [maxEntries] keys are held; the oldest are dropped first.
///
/// A key must always be used with the same value type `V`.
final class TtlCache<K> {
  TtlCache({this.maxEntries = 200, DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final int maxEntries;
  final DateTime Function() _now;
  final _entries = <K, _Entry>{};

  Future<V> fetch<V>(
    K key,
    Future<V> Function() load, {
    required Duration ttl,
    bool refresh = false,
    bool Function(V value)? cacheable,
  }) {
    final existing = _entries[key];
    if (!refresh && existing != null && existing.isUsable(_now())) {
      _entries
        ..remove(key)
        ..[key] = existing; // most recently used goes last
      return existing.future as Future<V>;
    }

    final future = load();
    final entry = _Entry(future);
    _entries
      ..remove(key)
      ..[key] = entry;
    while (_entries.length > maxEntries) {
      _entries.remove(_entries.keys.first);
    }

    future.then<void>(
      (value) {
        if (!identical(_entries[key], entry)) {
          return; // a newer load replaced it
        }
        if (cacheable != null && !cacheable(value)) {
          _entries.remove(key);
        } else {
          entry.expiresAt = _now().add(ttl);
        }
      },
      onError: (Object _) {
        if (identical(_entries[key], entry)) _entries.remove(key);
      },
    );
    return future;
  }

  void invalidate(K key) => _entries.remove(key);

  void clear() => _entries.clear();
}

class _Entry {
  _Entry(this.future);

  final Future<Object?> future;

  /// Null while the load is still in flight (such an entry can be shared).
  DateTime? expiresAt;

  bool isUsable(DateTime now) => expiresAt == null || now.isBefore(expiresAt!);
}
