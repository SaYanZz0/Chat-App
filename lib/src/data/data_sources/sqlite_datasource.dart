import 'package:chat/chat.dart';
import 'package:chat/src/models/receipt.dart';
import 'package:flutter_newapp/src/data/data_sources/database_contract.dart';
import 'package:flutter_newapp/src/models/local_message.dart';
import 'package:flutter_newapp/src/models/chat.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteDatasource implements IdataSource {
  final Database _db;

  SqfliteDatasource(this._db);

  @override
  Future<void> addChat(Chat chat) async {
    await _db.insert('chats', chat.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> addMessage(LocalMessage message) async {
    await _db.insert('messages', message.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> deleteChat(String chatId) async {
    final batch = _db.batch();
    batch.delete('messages', where: 'chat_id = ?', whereArgs: [chatId]);
    batch.delete('chats', where: 'id = ?', whereArgs: [chatId]);
    await batch.commit(noResult: true);
  }

  @override
  Future<List<Chat>> findAllChats() async {
    return _db.transaction((txn) async {
      final listOfChatMaps =
          await txn.query('chats', orderBy: 'updated_at DESC');

      if (listOfChatMaps.isEmpty) return [];

      return await Future.wait(listOfChatMaps.map<Future<Chat>>((row) async {
        final unread = Sqflite.firstIntValue(await txn.rawQuery(
            'SELECT COUNT(*) FROM MESSAGES WHERE chat_id = ? AND receipt = ?',
            [row['id'], 'deliverred']));

        final mostRecentMessage = await txn.query('messages',
            where: 'chat_id = ?',
            whereArgs: [row['id']],
            orderBy: 'created_at DESC',
            limit: 1);
        final chat = Chat.fromMap(row);
        chat.unread = unread;
        if (mostRecentMessage.isNotEmpty) {
          chat.mostRecent = LocalMessage.fromMap(mostRecentMessage.first);
        }
        return chat;
      }));
    });
  }

  @override
  Future<Chat> findChat(String chatId) async {
    return await _db.transaction((txn) async {
      final listOfChatMaps = await txn.query(
        'chats',
        where: 'id = ?',
        whereArgs: [chatId],
      );

      if (listOfChatMaps.isEmpty) return Future.value(null);

      final unread = Sqflite.firstIntValue(await txn.rawQuery(
          'SELECT COUNT(*) FROM MESSAGES WHERE chat_id = ? AND receipt = ?',
          [chatId, 'deliverred']));

      final mostRecentMessage = await txn.query('messages',
          where: 'chat_id = ?',
          whereArgs: [chatId],
          orderBy: 'created_at DESC',
          limit: 1);
      final chat = Chat.fromMap(listOfChatMaps.first);
      chat.unread = unread;
      if (mostRecentMessage.isNotEmpty) {
        chat.mostRecent = LocalMessage.fromMap(mostRecentMessage.first);
      }
      return chat;
    });
  }

  @override
  Future<List<LocalMessage>> findMessages(String chatId) async {
    final listOfMessagesmap =
        await _db.query('messages', where: 'chat_id = ?', whereArgs: [chatId]);
    return listOfMessagesmap
        .map<LocalMessage>((map) => LocalMessage.fromMap(map))
        .toList();
  }

  @override
  Future<void> updateMessage(LocalMessage message) async {
    await _db.update('messages', message.toMap(),
        where: 'id = ?',
        whereArgs: [message.message!.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> updateMessageReceipt(
      String messageId, ReceiptStatus status) async {
    await _db.update('messages', {'receipt': status.value()},
        where: 'id = ?', whereArgs: [messageId]);
  }
}
