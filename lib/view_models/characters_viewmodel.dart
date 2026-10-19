import 'package:flutter/foundation.dart';
import '../mvvm/command.dart';
import '../rest_api/rm_rest_api.dart';
import 'characters/character_item_viewmodel.dart';

final class CharactersViewModel extends ChangeNotifier {
  final IRickAndMortyRestApi _restApi;
  late AsyncCommand0 loadCommand;

  List<CharacterItemViewModel> _characters = [];

  List<CharacterItemViewModel> get characters => _characters;

  CharactersViewModel({required this._restApi}) {
    loadCommand = AsyncCommand0(_load)..execute();
  }

  Future<void> _load() async {
    try {
      final chatListResponseRes = await _restApi.getCharacters();
      chatListResponseRes.split(
            (chatListResponse) {
          _characters = chatListResponse.results.map((charactersItem) => CharacterItemViewModel.fromChatItem(charactersItem)).toList();
        },
            (problem) {},
            (fail) {},
      );
    } finally {
      notifyListeners();
    }
  }
}