import 'package:flutter/cupertino.dart';
//import 'package:rick_and_morty/pages/tabbed_home_page.dart';
import 'main.dart' show navigatorKey;

class RickAndMortyApp extends StatelessWidget {
  const RickAndMortyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Rick and Morty',
      theme: CupertinoThemeData(brightness: Brightness.dark),
      home: const /*TabbedHomePage*/Text(/*title:*/ 'Rick and Morty'),
      navigatorKey: navigatorKey,
    );
  }
}