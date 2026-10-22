import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty/pages/characters_page.dart';
import 'package:rick_and_morty/services/di.dart';
import 'package:rick_and_morty/services/rickandmorty_service.dart';
import 'package:rick_and_morty/view_models/characters_viewmodel.dart';
import 'main.dart' show navigatorKey;

class RickAndMortyApp extends StatelessWidget {
  const RickAndMortyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var rmService = DI.resolveOrCrash<IRickAndMortyService>();
    return MaterialApp(
      title: 'Rick and Morty',
      theme: ThemeData(colorSchemeSeed: Colors.teal),
      darkTheme: ThemeData(colorSchemeSeed: Colors.teal, brightness: Brightness.dark),
      home: CharactersPage(viewModel: CharactersViewModel(service: rmService), httpClient: DI.resolveOrCrash<http.Client>()),
      navigatorKey: navigatorKey,
    );
  }
}