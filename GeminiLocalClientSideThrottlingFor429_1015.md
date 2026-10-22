# Local Client-Side Throttling with Official Flutter Packages

Instead of complex data caching or writing reactive loops for every 429 failure, you can catch the problem *before* it leaves the device. By building a custom `ThrottledHttpClient` using standard Dart queues, you can strictly limit how fast your app fires requests.

---

### Step 1: The Throttled Client Implementation

This custom client wraps your native `cronet_http` or `cupertino_http` engines. It uses an internal queue to process requests sequentially, enforcing a mandatory minimum delay between the completion of one request and the start of the next.

```dart
import 'dart:async';
import 'package:http/http.dart' as http;

class ThrottledHttpClient extends http.BaseClient {
  final http.Client _innerClient;
  final Duration _minInterval;
  
  // A queue of operations waiting for their turn to execute
  final List<Completer<void>> _queue = [];
  bool _isProcessing = false;
  DateTime? _lastRequestEndTime;

  /// [_innerClient] should be your native CronetClient or CupertinoClient.
  /// [_minInterval] is the guaranteed cooldown period between requests.
  ThrottledHttpClient(this._innerClient, {Duration? minInterval})
      : _minInterval = minInterval ?? const Duration(milliseconds: 250);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final completer = Completer<void>();
    _queue.add(completer);
    
    // Trigger queue processing loop
    _processQueue();

    // Wait until this specific request's turn arrives
    await completer.future;

    try {
      // Execute the request using the native OS engine
      final response = await _innerClient.send(request);
      return response;
    } finally {
      // Record precisely when this call finished
      _lastRequestEndTime = DateTime.now();
      _isProcessing = false;
      
      // Trigger the next item in line
      _processQueue();
    }
  }

  void _processQueue() async {
    // If something is running or nothing is waiting, idle out
    if (_isProcessing || _queue.isEmpty) return;

    _isProcessing = true;
    final nextInLine = _queue.removeAt(0);

    // Calculate if we need to pause to respect the rate-limit interval
    if (_lastRequestEndTime != null) {
      final elapsed = DateTime.now().difference(_lastRequestEndTime!);
      if (elapsed < _minInterval) {
        final processDelay = _minInterval - elapsed;
        await Future.delayed(processDelay);
      }
    }

    // Release the block so the request can execute
    nextInLine.complete();
  }

  @override
  void close() {
    _innerClient.close();
    super.close();
  }
}
```

---

### Step 2: Wire it into your Native Setup

You can effortlessly combine this throttling client with the native runtime code configurations (`http.runWithClient`) you set up previously.

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cupertino_http/cupertino_http.dart';
import 'package:cronet_http/cronet_http.dart';

void main() {
  http.runWithClient(() {
    runApp(const MyApp());
  }, () {
    // 1. Establish the base native engine
    http.Client nativeEngine;
    if (Platform.isAndroid) {
      nativeEngine = CronetClient.fromEngine(
        CronetEngine.build(cacheMode: CacheMode.disk),
      );
    } else if (Platform.isIOS || Platform.isMacOS) {
      nativeEngine = CupertinoClient.defaultSessionConfiguration();
    } else {
      nativeEngine = http.Client();
    }

    // 2. Wrap it with your strict local interval rate-limiter
    // For example: Allow maximum 3 requests per second (approx 330ms delay)
    return ThrottledHttpClient(
      nativeEngine, 
      minInterval: const Duration(milliseconds: 335),
    );
  });
}
```

---

### Why this is better for 429 Errors:

1. **Zero UI Code Changes:** Your repositories, widgets, and state-management code continue to call `http.get()` completely normally. They have no idea requests are being delayed slightly under the hood.
2. **Eliminates Concurrent "Spam":** If a user opens a screen that immediately fires off 10 `FutureBuilder` requests at the exact same millisecond, this client lines them up neatly like a single-file queue rather than hammering Cloudflare simultaneously.
3. **Optimized Battery and Data:** Your app stops wasting battery processing incoming 429 error bodies and calculating artificial retry-backoff math.