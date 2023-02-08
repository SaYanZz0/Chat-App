import 'dart:convert';

import 'package:chat/chat.dart';

class LocalMessage {
  String? chatId;
  Message? message;
  ReceiptStatus? receipt;
  String? _id;
  String? get id => _id;

  LocalMessage({
    required this.chatId,
    required this.message,
    required this.receipt,
  });

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'contents': message!.contents,
      'receipt': receipt!.value(),
      'id': message!.id,
      'sender': message!.from,
      'receiver': message!.to,
      'received_at': message!.timestamp.toString()
    };
  }

  factory LocalMessage.fromMap(Map<String, dynamic> json) {
    final message = Message(
        from: json['sender'],
        to: json['receiver'],
        contents: json['contents'],
        timestamp: DateTime.parse(json['received_at']));
    final localMessage = LocalMessage(
        chatId: json['chat_id'],
        message: message,
        receipt: EnumParsing.fromString(json['receipt']));
    localMessage._id = json['id'];
    return localMessage;
  }
}
