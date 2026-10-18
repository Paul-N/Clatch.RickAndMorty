import 'dart:io';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:rick_and_morty/rest_api/rm_rest_api.dart';
import 'package:rick_and_morty/services/app_config.dart';
import 'package:rick_and_morty/services/compilation_environment_app_config.dart';
import 'package:rick_and_morty/services/di.dart';
import 'package:rick_and_morty/rick_and_morty_app.dart';

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
    DI.register<http.Client>(http.Client());
    DI.register<IRickAndMortyRestApi>(RickAndMortyRestApi(
      client: DI.resolveOrCrash<http.Client>(),
      baseUrl: appConfig.backendHomeUrl,
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

// Future<void> _startUpAsyncTask() async {
//   WidgetsBinding.instance.addPostFrameCallback((_) async {
//     final service = DI.resolve<IMonitoringService>();
//     try {
//       await service?.checkIfDatabaseIsAvailable(true);
//     } catch (e) {
//       debugPrint("Startup task error: $e");
//     }
//   });
// }

//-------------

/*void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}*/
