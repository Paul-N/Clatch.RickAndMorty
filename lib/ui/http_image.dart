import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart';
import '../rest_api/low_priority.dart';

/// Loads an image through the injected (throttled) [Client] at low priority, so
/// JSON requests are served first. It has no cache of its own: the native HTTP
/// cache and Flutter's ImageCache do that.
@immutable
final class HttpImage extends ImageProvider<HttpImage> {
  const HttpImage(this.url, {required this.client, this.scale = 1.0});

  final Uri url;
  final Client client;
  final double scale;

  @override
  Future<HttpImage> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture<HttpImage>(this);

  @override
  ImageStreamCompleter loadImage(HttpImage key, ImageDecoderCallback decode) =>
      MultiFrameImageStreamCompleter(
        codec: _load(decode),
        scale: key.scale,
        debugLabel: key.url.toString(),
      );

  Future<ui.Codec> _load(ImageDecoderCallback decode) async {
    final response = await client.get(url, headers: lowPriorityHeaders);
    if (response.statusCode != 200) {
      throw NetworkImageLoadException(statusCode: response.statusCode, uri: url);
    }
    final buffer = await ui.ImmutableBuffer.fromUint8List(response.bodyBytes);
    return decode(buffer);
  }

  @override
  bool operator ==(Object other) =>
      other is HttpImage && other.url == url && other.scale == scale;

  @override
  int get hashCode => Object.hash(url, scale);
}