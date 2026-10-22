import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'image_file_store.dart';

/// An [ImageProvider] that loads through [ImageFileStore]: disk first, then the
/// injected HTTP client. Wrap it in [ResizeImage] to decode at display size.
@immutable
final class CachedHttpImage extends ImageProvider<CachedHttpImage> {
  const CachedHttpImage(this.url, {required this.store, this.scale = 1.0});

  final Uri url;
  final ImageFileStore store;
  final double scale;

  @override
  Future<CachedHttpImage> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture<CachedHttpImage>(this);

  @override
  ImageStreamCompleter loadImage(CachedHttpImage key, ImageDecoderCallback decode) =>
      MultiFrameImageStreamCompleter(
        codec: _decode(decode),
        scale: key.scale,
        debugLabel: key.url.toString(),
      );

  Future<ui.Codec> _decode(ImageDecoderCallback decode) async {
    final bytes = await store.get(url);
    final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
    return decode(buffer);
  }

  @override
  bool operator ==(Object other) =>
      other is CachedHttpImage && other.url == url && other.scale == scale;

  @override
  int get hashCode => Object.hash(url, scale);
}
