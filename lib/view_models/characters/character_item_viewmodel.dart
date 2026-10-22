import '../../dto/character.dart';
import '../../util/string_utils.dart';

final class CharacterItemViewModel {
  final String name;
  final CharacterStatus status;
  final String userPic;
  final int id;

  CharacterItemViewModel({
    required this.name,
    required this.status,
    required this.userPic,
    required this.id,
  });

  factory CharacterItemViewModel.fromCharacter(Character c) {
    return CharacterItemViewModel(
      id: c.id,
      name: c.name,
      status: c.status,
      userPic: c.image,
    );
  }
}
