import '../../dto/character.dart';
import '../../util/string_utils.dart';

final class CharacterItemViewModel {
  final String name;
  final String status;
  final String userPic;

  CharacterItemViewModel({
    required this.name,
    required this.status,
    required this.userPic,
  });

  factory CharacterItemViewModel.fromChatItem(Character chatItem) {
    return CharacterItemViewModel(
      name: chatItem.name,
      status: chatItem.status.toString(), //TODO: localize
      userPic: chatItem.image,
    );
  }
}
