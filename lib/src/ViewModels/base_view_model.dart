import 'package:flutter/foundation.dart';
import 'package:flutter_newapp/src/data/Services/database_contract.dart';
import 'package:flutter_newapp/src/data/models/chat.dart';
import 'package:flutter_newapp/src/data/models/local_message.dart';

class BaseViewModel {
  IdataSource _idataSource;

  BaseViewModel(this._idataSource);

  @protected
  Future<void> addMessage(LocalMessage message) async {
    if (!await _existingChat(message.chatId)) {
      final chat = Chat(message.chatId, ChatType.private, membersId: [
        {message.chatId: ''}
      ]);
      await createNewChat(chat);
    }

    await _idataSource.addMessage(message);
  }

  Future<bool> _existingChat(String? chatId) async {
    return await _idataSource.findChat(chatId!) != null;
  }

  Future<void> createNewChat(Chat chat) async {
    await _idataSource.addChat(chat);
  }
}
