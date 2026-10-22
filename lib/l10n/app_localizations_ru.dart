// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Rick and Morty';

  @override
  String get character => 'Персонаж';

  @override
  String get couldNotLoadCharacter => 'Не удалось загрузить персонажа';

  @override
  String get characterNotFound => 'Персонаж не найден';

  @override
  String get characterDetailsUnavailable => 'Детали персонажа недоступны';

  @override
  String get origin => 'Происхождение';

  @override
  String get lastKnownLocation => 'Последнее местоположение';

  @override
  String get noLocationDetailsAvailable => 'Местоположение неизвестно';

  @override
  String get tryAgain => 'Повторить';

  @override
  String get characters => 'Персонажи';

  @override
  String get searchByName => 'Искать по имени';

  @override
  String get clearSearch => 'Очистить поиск';

  @override
  String get couldNotLoadCharacters => 'Не удалось загрузить персонажей';

  @override
  String noResultsFor(Object query) {
    return 'Нет результатов для $query';
  }

  @override
  String get noCharactersYet => 'Персонажей пока нет';

  @override
  String get tryDifferentName => 'Попробуйте другое имя.';

  @override
  String couldNotLoadMore(Object error) {
    return 'Не удалось загрузить больше: $error';
  }

  @override
  String get characterStatus_alive => 'Жив';

  @override
  String get characterStatus_dead => 'Мертв';

  @override
  String get characterStatus_unknown => 'Неизвестен';
}
