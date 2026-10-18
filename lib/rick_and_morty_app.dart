import 'package:flutter/material.dart';
import 'package:rick_and_morty/pages/characters_page.dart';
import 'package:rick_and_morty/rest_api/rm_rest_api.dart';
import 'package:rick_and_morty/services/di.dart';
import 'main.dart' show navigatorKey;

class RickAndMortyApp extends StatelessWidget {
  const RickAndMortyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick and Morty',
      theme: ThemeData(colorSchemeSeed: Colors.teal),
      darkTheme: ThemeData(colorSchemeSeed: Colors.teal, brightness: Brightness.dark),
      home: CharactersPage(api: DI.resolveOrCrash<IRickAndMortyRestApi>(), onSelected: (c) { /* open details */ }),
      navigatorKey: navigatorKey,
    );
  }
}