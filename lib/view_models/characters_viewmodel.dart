import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rick_and_morty/dto/character.dart';
import 'package:rick_and_morty/dto/paged_response.dart';
import 'package:rick_and_morty/model/results.dart';

import '../mvvm/command.dart';
import '../services/rickandmorty_service.dart';
import 'characters/character_item_viewmodel.dart';

final class CharactersViewModel extends ChangeNotifier {
  final IRickAndMortyService _service;

  late AsyncCommand0 loadCommand;

  final List<CharacterItemViewModel> _characters = [];
  List<CharacterItemViewModel> get characters => _characters;

  String? _query;
  String? get query => _query;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  String? _notFoundMessage;
  String? get notFoundMessage => _notFoundMessage;

  Uri? _next;
  Uri? get next => _next;

  Timer? _debounce;

  CharactersViewModel({required this._service}) {
    loadCommand = AsyncCommand0(_load);
  }

  Future<void> _load() async {
    await _fetch(firstPage: true);
  }

  Future<void> refresh() => _fetch(firstPage: true, refresh: true);

  Future<void> _fetch({required bool firstPage, bool refresh = false}) async {
    if (!firstPage && (_loading || _next == null || _error != null)) return;

    _loading = true;
    if (firstPage) {
      _characters.clear();
      _next = null;
      _error = null;
    }
    notifyListeners();

    final outcome =
        await (firstPage
                ? _service.getCharacters(
                    filter: _query?.isEmpty != false
                        ? null
                        : CharacterFilter(name: _query),
                    refresh: refresh,
                  )
                : _service.getCharactersByUri(_next!))
            .value;

    // Superseded by a newer call (or canceled on dispose): that call owns the
    // state now, so leave `_loading` and the lists alone.
    if (outcome.value case final Fail f when f.isCanceled) return;

    _loading = false;
    outcome.split(
      (success) {
        _characters.addAll(
          success.value.results.map(
            (c) => CharacterItemViewModel.fromChatItem(c),
          ),
        );
        _next = _nextOf(success.value);
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

  void onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final q = value.trim();
      if (q == _query) return;
      _query = q;
      _fetch(firstPage: true);
    });
  }

  void retry() {
    _error = null;
    _fetch(firstPage: false);
  }

  void loadMore() => _fetch(firstPage: false);

  static Uri? _nextOf(PagedResponse<Character> page) {
    final next = page.info?.next?.toString();
    return next == null ? null : Uri.tryParse(next);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _service
        .cancelPending(); // a late result must not touch a disposed notifier
    super.dispose();
  }
}
