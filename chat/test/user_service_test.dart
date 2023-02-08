import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/user/user_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

import 'helper.dart';

void main() {
  RethinkDb r = RethinkDb();
  Connection? connection;
  late UserService sut;

  setUp(() async {
    connection = await r.connect(
        host: "localhost", port: 28015, user: "admin", password: "");
    await createDb(r, connection!);
    sut = UserService(r, connection);
  });

  tearDown(() async {
    await cleanDb(r, connection!);
  });

  tearDownAll(() {
    r.dbDrop('test').run(connection!).then((value) => print(value));
  });

  test('creates a new user document in database', () async {
    final user = User(
      username: 'test',
      photoUrl: 'url',
      active: true,
      lastSeen: DateTime.now(),
    );
    final userWithId = await sut.connect(user);
    expect(userWithId.id, isNotEmpty);
  });
}
