import 'package:flutter/foundation.dart';
import '../mvvm/command.dart';
import '../services/rickandmorty_service.dart';

final class CharacterDetailsViewModel extends ChangeNotifier {
  final int id;
  final IRickAndMortyService _service;

  late AsyncCommand0 loadCommand;

  CharacterDetailsViewModel({required this._service, required this.id}) {
    loadCommand = AsyncCommand0(_load);
  }

  Future<void> _load() async {

  }

  @override
  void dispose() {

    _service
        .cancelPending(); // a late result must not touch a disposed notifier
    super.dispose();
  }
}
