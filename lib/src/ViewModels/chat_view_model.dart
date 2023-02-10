import 'dart:ffi';

import 'package:chat/chat.dart';
import 'package:flutter_newapp/src/ViewModels/base_view_model.dart';
import 'package:flutter_newapp/src/data/Services/database_contract.dart';
import 'package:flutter_newapp/src/data/models/local_message.dart';

class ChatViewModel extends BaseViewModel {
  IdataSource _idataSource;
  String _chatId = '';

  ChatViewModel(this._idataSource) : super(_idataSource);

  Future<List<LocalMessage>> getMessages(String chatId) async {
    final messages = await _idataSource.findMessages(chatId);
    if (messages.isNotEmpty) _chatId = chatId;
    return messages;
  }

  Future<void> deleteChat(String chatId) async {
    await _idataSource.deleteChat(chatId);
  }

  Future<void> sentMessage(Message message) async {
    final chatId = message.groupId ?? message.to;

    final localMessage = LocalMessage(
        chatId: chatId, message: message, receipt: ReceiptStatus.sent);
    if (_chatId.isNotEmpty) await _idataSource.addMessage(localMessage);
    _chatId = localMessage.chatId!;
    await addMessage(localMessage);
  }

  Future<void> receivedMessage(Message message) async {
    final chatId = message.groupId ?? message.from;

    final localMessage = LocalMessage(
        chatId: chatId, message: message, receipt: ReceiptStatus.deliverred);

    if (_chatId.isEmpty) _chatId = localMessage.chatId!;
    _chatId = localMessage.chatId!;
    await addMessage(localMessage);
  }

  Future<void> updateMessageReceipt(Receipt receipt) async {
    await _idataSource.updateMessageReceipt(receipt.messageId!, receipt.status);
  }
}
