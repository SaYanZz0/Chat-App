import 'package:chat/chat.dart';
import 'package:flutter_newapp/src/data/data_sources/sqlite_datasource.dart';
import 'package:flutter_newapp/src/models/chat.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

class MockSqfliteDatabase extends Mock implements Database {}

class MockTransaction extends Mock implements Transaction {}

class MockBatch extends Mock implements Batch {}

void main() {
  late SqfliteDatasource sut;
  late MockSqfliteDatabase database;
  MockBatch batch;

  setUp(() {
    database = MockSqfliteDatabase();
    sut = SqfliteDatasource(database);
    batch = MockBatch();
  });

  final message = Message.fromJson({
    'from': '111',
    'to': '222',
    'timestamp': DateTime.now(),
    'contents': 'hello world'
  });

  test('Testing the insert of Chat Succesfully', () async {
    final chat = Chat('1111', ChatType.private, membersId: []);
    when(database.insert('chats', chat.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace))
        .thenReturn(Future.value(1));

    await sut.addChat(chat);
    verify(database.insert('chats', chat.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace))
        .called(1);
  });
}
