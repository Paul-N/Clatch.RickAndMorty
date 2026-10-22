import 'package:flutter/foundation.dart';

import '../model/results.dart';
import '../mvvm/command.dart';
import '../services/rickandmorty_service.dart';

final class CharacterDetailsViewModel extends ChangeNotifier {
  final int id;
  late final IRickAndMortyService _service;

  late AsyncCommand0 loadCommand;

  bool _loading = false;

  bool get loading => _loading;

  String? _error;

  String? get error => _error;

  String? _notFoundMessage;

  String? get notFoundMessage => _notFoundMessage;

  String? _name;

  String? get name => _name;

  Uri? _userPic;

  Uri? get userPic => _userPic;

  String? _status;

  String? get status => _status;

  String? _species;

  String? get species => _species;

  String? _origin;

  String? get origin => _origin;

  String? _location;

  String? get location => _location;

  CharacterDetailsViewModel({
    required IRickAndMortyService service,
    required this.id,
  }) {
    _service = service;
    loadCommand = AsyncCommand0(_load);
  }

  Future<void> _load() async {
    //Отображение имени, изображения, статуса, вида, происхождения и текущей локации.

    _error = null;
    _notFoundMessage = null;
    _loading = true;

    notifyListeners();

    final details = await _service.getCharacterById(id).result;

    // Superseded by a newer call (or canceled on dispose): that call owns the
    // state now, so leave `_loading` and the lists alone.
    if (details.value case final Fail f when f.isCanceled) return;

    _loading = false;
    details.split(
      (success) {
        final character = success.value;
        _name = character.name;
        _userPic = Uri.tryParse(character.image);
        _status = character.status.toString();
        _species = character.species;
        _origin = character.origin.name;
        _location = character.location.name;
      },
      (notFound) {
        _notFoundMessage = notFound.description;
      },
      (fail) {
        _error = fail.description ?? 'Something went wrong.';
      },
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _service
        .cancelPending(); // a late result must not touch a disposed notifier
    super.dispose();
  }
}
