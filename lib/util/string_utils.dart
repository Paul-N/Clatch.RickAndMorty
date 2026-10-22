import 'package:intl/intl.dart';

import '../dto/character.dart';
import '../l10n/app_localizations.dart';

extension DateTimeRelative on DateTime {
  String toStringRelativeToday([DateTime? now]) {
    final effectiveNow = now ?? DateTime.now();
    final today = DateTime(effectiveNow.year, effectiveNow.month, effectiveNow.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final checkDate = DateTime(year, month, day);

    if (checkDate == today) {
      return DateFormat.Hm().format(this);
    } else if (checkDate == yesterday) {
      // "Yesterday" is not easily localized via DateFormat without complex logic,
      // usually handled via custom logic or Intl.message
      return "Yesterday";
    } else if (today.difference(checkDate).inDays < 7) {
      return DateFormat.EEEE().format(this);
    } else {
      return DateFormat.yMd().format(this);
    }
  }
}



extension CharacterStatusLocalization on CharacterStatus {

  String? localize(AppLocalizations localizations) {
    switch (this) {
      case CharacterStatus.alive:
        return localizations.characterStatus_alive;
      case CharacterStatus.dead:
        return localizations.characterStatus_dead;
      case CharacterStatus.unknown:
        return localizations.characterStatus_unknown;
    }
  }
}
