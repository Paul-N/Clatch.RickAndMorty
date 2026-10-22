// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Rick and Morty';

  @override
  String get character => 'Character';

  @override
  String get couldNotLoadCharacter => 'Couldn’t load character';

  @override
  String get characterNotFound => 'Character not found';

  @override
  String get characterDetailsUnavailable => 'Character details are unavailable';

  @override
  String get origin => 'Origin';

  @override
  String get lastKnownLocation => 'Last known location';

  @override
  String get noLocationDetailsAvailable => 'No location details available';

  @override
  String get tryAgain => 'Try again';

  @override
  String get characters => 'Characters';

  @override
  String get searchByName => 'Search by name';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get couldNotLoadCharacters => 'Couldn’t load characters';

  @override
  String noResultsFor(Object query) {
    return 'No results for $query';
  }

  @override
  String get noCharactersYet => 'No characters yet';

  @override
  String get tryDifferentName => 'Try a different name.';

  @override
  String couldNotLoadMore(Object error) {
    return 'Couldn’t load more: $error';
  }

  @override
  String get characterStatus_alive => 'Alive';

  @override
  String get characterStatus_dead => 'Dead';

  @override
  String get characterStatus_unknown => 'Unknown';
}
