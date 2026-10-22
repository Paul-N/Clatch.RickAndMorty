import 'dart:io';
import 'package:clock/clock.dart';
import 'package:cronet_http/cronet_http.dart';
import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:logging/logging.dart';
import 'package:rick_and_morty/infrastructure/rickandmorty_rest_api.dart';
import 'package:rick_and_morty/services/app_config.dart';
import 'package:rick_and_morty/services/compilation_environment_app_config.dart';
import 'package:rick_and_morty/services/di.dart';
import 'package:rick_and_morty/rick_and_morty_app.dart';
import 'package:rick_and_morty/services/rickandmorty_service.dart';

import 'infrastructure/throttled_http_client.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  try {
    IAppConfig appConfig = CompilationEnvironmentAppConfig();

    Logger.root.level = Level.ALL; // defaults to Level.INFO
    Logger.root.onRecord.listen((record) {
      // ignore: avoid_print
      print('${record.level.name}: ${record.time}: ${record.message}');
    });


    DI.register(Clock());
    DI.register<Logger>(Logger.root);
    final httpClient = ThrottledHttpClient(_createPlatformClient(), minInterval: const Duration(milliseconds: 335));
    DI.register<http.Client>(httpClient);
    DI.register<IRickAndMortyRestApi>(RickAndMortyRestApi(
      client: DI.resolveOrCrash<http.Client>(),
      baseUrl: appConfig.backendHomeUrl,
    ));
    DI.register<IRickAndMortyService>(RickAndMortyService(
      client: DI.resolveOrCrash<IRickAndMortyRestApi>()
    ));

    DI.register<IAppConfig>(appConfig);
    runApp(RickAndMortyApp());
    // if (Platform.isMacOS || Platform.isAndroid) {
    //   _startUpAsyncTask();
    // }
  } catch (e, stackTrace) {
    Logger.root.shout(e.toString(), e, stackTrace);
  }
}

http.Client _createPlatformClient() {
  if (Platform.isIOS || Platform.isMacOS) {
    // defaultSessionConfiguration() uses caching; the ephemeral one does not
    // keep a persistent cache. The cache is sized explicitly because the
    // shared default is small.
    final config = URLSessionConfiguration.defaultSessionConfiguration()
      ..cache = URLCache.withCapacity(
        memoryCapacity: 8 << 20, // 8 MB
        diskCapacity: 128 << 20, // 128 MB
      );
    return CupertinoClient.fromSessionConfiguration(config);
  }

  if (Platform.isAndroid) {
    // CacheMode.disk is the persistent HTTP cache (honors max-age, Age and
    // validators). Build ONE engine and share it.
    // In older cronet_http versions build() returns a Future: use
    // CronetClient.fromCronetEngineFuture instead.
    return CronetClient.fromCronetEngine(
      CronetEngine.build(cacheMode: CacheMode.disk, cacheMaxSize: 128 << 20),
    );
  }

  return IOClient();
}
