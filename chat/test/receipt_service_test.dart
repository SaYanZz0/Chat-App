import 'package:chat/src/models/receipt.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/receipt/receipt_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

import 'helper.dart';

void main() {
  RethinkDb r = RethinkDb();
  Connection? connection;
  late ReceiptService sut;

  setUp(() async {
    connection = await r.connect(
        host: "localhost", port: 28015, user: "admin", password: "");
    await createDb(r, connection!);
    sut = ReceiptService(r, connection);
  });

  tearDown(() async {
    sut.dispose();
    await cleanDb(r, connection!);
  });

  final user = User.fromJson(
      {'id': '1111', 'active': true, 'lastSeens': DateTime.now()});

  test('sent receipt succesfully', () async {
    Receipt receipt = Receipt(
        receipient: '444',
        messageId: '1234',
        status: ReceiptStatus.deliverred,
        timestamp: DateTime.now());

    final res = await sut.send(receipt);
    expect(res, true);
  });
}
