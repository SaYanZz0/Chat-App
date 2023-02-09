import 'package:chat/src/models/message.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/encryption/encryption_service_impl.dart';
import 'package:chat/src/services/message/message_service_implem.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

import 'helper.dart';

void main() {
  RethinkDb r = RethinkDb();
  Connection? connection;
  late MessageService sut;

  setUp(() async {
    connection = await r.connect(host: "127.0.0.1", port: 28015);
    final encryption = EncryptionService(Encrypter(AES(Key.fromLength(32))));
    await createDb(r, connection!);
    sut = MessageService(r, connection, encryption: encryption);
  });

  tearDown(() async {
    sut.dispose();
    await cleanDb(r, connection!);
  });

  final user = User.fromJson({
    'id': '1234',
    'active': true,
    'lastSeen': DateTime.now(),
  });

  final user2 = User.fromJson({
    'id': '1111',
    'active': true,
    'lastSeen': DateTime.now(),
  });
  test('sent message successfully', () async {
    Message message = Message(
      from: user.id,
      to: '3456',
      timestamp: DateTime.now(),
      contents: 'this is a message',
    );

    final res = await sut.send([message]);
    expect(res.id, isNotEmpty);
  });

  test('Subscribe and Succesfully get messages', () async {
    Message message = Message(
        from: user.id,
        to: user2.id,
        timestamp: DateTime.now(),
        contents: 'First Message');

    Message message2 = Message(
        from: user.id,
        to: user2.id,
        timestamp: DateTime.now(),
        contents: 'First Message');

    await sut.send([message]);
    await sut.send([message2]);

    sut.messages(activeUser: user2).listen(expectAsync1((message) {
          expect(message.to, user2.id);
          expect(message.id, isNotEmpty);
          expect(message.contents, 'First Message');
        }, count: 2));
  });
}
