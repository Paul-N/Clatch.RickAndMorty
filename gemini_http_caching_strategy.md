# Native HTTP Caching and Rate-Limiting Guide for Flutter

This guide explains how to handle caching and HTTP 429 Rate-Limiting responses using official packages maintained directly by the Flutter and Dart teams: `cupertino_http`, `cronet_http`, and `package:http`.

---

## 1. Deep Analysis of Your Response Headers

Looking closely at your provided log files, we can extract critical caching behavior based directly on how the backend server communicates.

### Log 1: Success Logs (JSON & Image)

#### The JSON Response Header:
```http
cache-control: public, max-age=7776000, immutable
etag: W/"a6e-zQHAPIKFfD+Wv+P+4aCju24Mapw"
cf-cache-status: HIT
```
*   **What this means:** The server explicitly permits long-term caching (`max-age=7776000` is 90 days). The `immutable` flag tells the client that this response body will never change over its lifetime. 
*   **The Native Behavior:** Both `cupertino_http` and `cronet_http` will automatically store this JSON response payload on the device disk (ROM). Subsquent matching requests inside the Flutter app will read instantly from disk without hitting the network infrastructure.

#### The Image Response Header:
```http
content-type: image/jpeg
cache-control: public, max-age=7776000, immutable
```
*   **What this means:** Much like the JSON payload, the image is marked public and immutable for 90 days.
*   **The Native Behavior:** The underlying Android/iOS systems cache these raw bytes automatically. Because `package:http` handles image data as streams or byte arrays, you can use these native clients inside standard Flutter image loaders (like `Image.network`) to benefit from transparent disk storage.

---

### Log 2: Rate-Limited Log (HTTP 429)

#### The Error Response Header & Body:
```http
retry-after: 2
cache-control: private, max-age=0, no-store, no-cache, must-revalidate
```
```json
{
  "status": 429,
  "error_name": "rate_limited",
  "retry_after": 30
}
```
*   **What this means:** The cache-control string explicitly commands `no-store, no-cache`, meaning the native layer will **never** save this failure block over your previously cached good data.
*   **The Conflict:** The HTTP header suggests a wait time of 2 seconds (`retry-after: 2`), but the application JSON body explicitly states a wait time of 30 seconds (`"retry_after": 30`). 
*   **The Strategy:** To protect your network architecture, your Flutter code must prioritize the longer duration (30 seconds) declared by the application payload and use a backoff pattern.

---

## 2. Implementing the Architecture with Official Packages

To orchestrate this, you must configure `cupertino_http` (iOS/macOS) and `cronet_http` (Android) as the platform engine clients, and wrap your request logic inside a resilient retry mechanism.

### Step 1: Add Official Dependencies
Add the required platform interface packages to your `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0          # The standard HTTP interface from dart.dev
  cupertino_http: ^1.3.0 # Native Apple Network Stack wrapper
  cronet_http: ^1.1.0    # Native Android Cronet Engine wrapper
```

### Step 2: Initialize Platform-Specific Client Engines
Configure your Flutter app's entry point to use the proper native client depending on the running operating system.

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cupertino_http/cupertino_http.dart';
import 'package:cronet_http/cronet_http.dart';

void main() {
  // Bind the global http client to optimized native engines
  http.runWithClient(() {
    runApp(const MyApp());
  }, () {
    if (Platform.isAndroid) {
      // Cronet manages automatic HTTP/3, connection pooling, and disk caching
      final engine = CronetEngine.build(
        cacheMode: CacheMode.disk,
        cacheMaxSize: 50 * 1024 * 1024, // 50 MB Dedicated ROM space
      );
      return CronetClient.fromEngine(engine);
    } else if (Platform.isIOS || Platform.isMacOS) {
      // Cupertino client automatically hooks into standard URLCache mechanisms
      final config = URLSessionConfiguration.ephemeralSessionConfiguration()
        ..requestCachePolicy = URLRequestCachePolicy.useProtocolCachePolicy;
      return CupertinoClient.fromSessionConfiguration(config);
    }
    // Fallback engine for other systems (Web, Windows, Linux)
    return http.Client();
  });
}
```

### Step 3: Handling JSON & Images with Automatic 429 Retries
Because we are avoiding unofficial packages, we can handle the retry logic natively using a basic async recursive wrapper. This function respects your explicit server payload telling you to wait 30 seconds.

```dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  /// Fetches data while handling automatic disk caching and smart 429 retries
  Future<http.Response> fetchWithRetry(Uri url, {int retryCount = 0}) async {
    if (retryCount >= 5) {
      throw Exception("Request failed: Max rate-limit retries reached.");
    }

    // This request automatically hits disk storage first if the 90-day TTL is still valid
    final response = await http.get(url);

    // Handle Success (200 OK)
    if (response.statusCode == 200) {
      return response;
    }

    // Handle Rate Limiting (429 Too Many Requests)
    if (response.statusCode == 429) {
      int backoffSeconds = 30; // Safer fallback based on your error JSON log

      try {
        // Try parsing the JSON error block payload directly
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body.containsKey('retry_after')) {
          backoffSeconds = body['retry_after'];
        }
      } catch (_) {
        // Fallback to Header parsing if JSON body is invalid
        final headerRetry = response.headers['retry-after'];
        if (headerRetry != null) {
          backoffSeconds = int.tryParse(headerRetry) ?? backoffSeconds;
        }
      }

      // Exponential backoff modification if rate limiting persists across attempts
      final calculatedWait = backoffSeconds * (retryCount + 1);
      
      print("Rate limited (429). Waiting $calculatedWait seconds before retry...");
      await Future.delayed(Duration(seconds: calculatedWait));

      // Recursive call to attempt request execution again
      return fetchWithRetry(url, retryCount: retryCount + 1);
    }

    // Generic error handling
    throw HttpException("Server returned status code: ${response.statusCode}");
  }
}
```

---

## 3. Serving Images Through the Native Client

To render image data safely using your `cronet_http` or `cupertino_http` configurations without depending on third-party custom image UI utilities, leverage Flutter's native `Image.memory` along with your global HTTP wrapper:

```dart
import 'package:flutter/material.dart';

class NetworkImageWidget extends StatelessWidget {
  final Uri imageUrl;
  final ApiService _apiService = ApiService();

  NetworkImageWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _apiService.fetchWithRetry(imageUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          // Native system disk cache provides immediate rendering on subsequent loads
          return Image.memory(snapshot.data!.bodyBytes);
        }
        if (snapshot.hasError) {
          return const Icon(Icons.error_outline, color: Colors.red);
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
```

---

## Summary Checklist
1. **Caching Logic:** You do not need database code (SQLite/Hive). As long as `CronetClient` or `CupertinoClient` are active, your 90-day immutable `Cache-Control` header automatically puts responses directly into ROM.
2. **Error Handling:** When receiving a 429 status code, do not trust the 2-second header. Safely isolate the `retry_after: 30` block found inside the response JSON body and use an increasing wait loop before re-executing.