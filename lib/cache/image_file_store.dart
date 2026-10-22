import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart';

/// On-disk cache for responses explicitly marked immutable, keyed by URL.
///
/// A cached file is served forever and never revalidated. Only responses with
/// an `immutable` Cache-Control directive are persisted. Misses are fetched
/// through the injected [Client] (so the native HTTP cache and 429 handling
/// apply too).
///
/// Pure Dart (dart:io): not for web. Point [directory] at a folder the OS does
/// not purge (e.g. application support) if the images must really stay.
final class ImageFileStore {
  ImageFileStore({required this.client, required this.directory});

  final Client client;
  final Directory directory;
  final _inflight = <String, Future<Uint8List>>{};

  /// The image bytes: from disk when cached, otherwise downloaded and stored.
  /// Concurrent calls for the same URL share one download.
  Future<Uint8List> get(Uri url) {
    final name = _fileName(url);
    return _inflight[name] ??= _load(url, name).whenComplete(() {
      _inflight.remove(name); // block body on purpose: see whenComplete docs
    });
  }

  /// Deletes every cached image.
  Future<void> clear() async {
    if (await directory.exists()) await directory.delete(recursive: true);
  }

  Future<Uint8List> _load(Uri url, String name) async {
    final file = File('${directory.path}${Platform.pathSeparator}$name');
    try {
      return await file.readAsBytes();
    } on FileSystemException {
      // Not cached yet (or unreadable): download it.
    }

    final response = await client.get(url);
    if (response.statusCode != 200) {
      throw ClientException(
        'Image request failed with status ${response.statusCode}',
        url,
      );
    }
    final contentType = response.headers['content-type'] ?? '';
    if (!contentType.startsWith('image/')) {
      // e.g. an HTML challenge page served with 200: never cache that.
      throw ClientException('Expected an image but got "$contentType"', url);
    }

    final bytes = response.bodyBytes;
    if (_isImmutable(response.headers['cache-control'])) {
      await _write(file, bytes);
    }
    return bytes;
  }

  bool _isImmutable(String? cacheControl) =>
      cacheControl
          ?.split(',')
          .map((directive) => directive.trim().split('=').first.toLowerCase())
          .contains('immutable') ??
      false;

  Future<void> _write(File file, Uint8List bytes) async {
    try {
      await directory.create(recursive: true);
      final temp = File('${file.path}.tmp');
      await temp.writeAsBytes(bytes, flush: true);
      await temp.rename(file.path); // readers never see a half-written file
    } on FileSystemException {
      // A full or read-only disk must not break image loading.
    }
  }

  String _fileName(Uri url) =>
      sha256.convert(utf8.encode(url.toString())).toString();
}
