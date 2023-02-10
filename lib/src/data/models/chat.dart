import 'dart:convert';

import 'package:chat/chat.dart';

import 'local_message.dart';

enum ChatType { private, group }

extension EnumParsing on ChatType {
  String value() {
    return this.toString().split('.').last;
  }

  static ChatType fromString(String status) {
    return ChatType.values.firstWhere((element) => element.value() == status);
  }
}

class Chat {
  List<Message>? messages = [];
  ChatType? type;
  String? id;
  int? unread = 0;
  LocalMessage? mostRecent;
  List<User>? members;
  List<Map>? membersId;
  String? name;

  Chat(this.id, this.type,
      {this.membersId,
      this.members,
      this.name,
      this.messages,
      this.mostRecent});

  toMap() => {
        'id': id,
        'name': name,
        'type': type!.value(),
        'members': membersId!.map((e) => jsonEncode(e)).join(",")
      };
  factory Chat.fromMap(Map<String, dynamic> map) => Chat(
        map['id'],
        EnumParsing.fromString(map['type']),
        membersId:
            List<Map>.from(map['members'].split(",").map((e) => jsonDecode(e))),
        name: map['name'],
      );
}
