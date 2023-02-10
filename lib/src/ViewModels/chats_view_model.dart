import 'package:chat/chat.dart';
import 'package:flutter_newapp/src/ViewModels/base_view_model.dart';
import 'package:flutter_newapp/src/data/Services/database_contract.dart';
import 'package:flutter_newapp/src/data/models/chat.dart';
import 'package:flutter_newapp/src/data/models/local_message.dart';

class ChatsViewModel extends BaseViewModel {
  IdataSource _idataSource;
  IUserService _userService;

  ChatsViewModel(this._idataSource, this._userService) : super(_idataSource);

  Future<List<Chat>> getChats() async {
    final chats = await _idataSource.findAllChats();
    await Future.forEach(chats, (Chat chat) async {
      final ids = chat.membersId!.map<String>((e) => e.keys.first).toList();
      final users = await _userService.fetch(ids);
      chat.members = users;
    });
    return chats;
  }

  Future<void> receivedMessage(Message message) async {
    final chatId = message.groupId ?? message.from;

    final localMessage = LocalMessage(
        chatId: chatId, message: message, receipt: ReceiptStatus.deliverred);
    await addMessage(localMessage);
  }
}
