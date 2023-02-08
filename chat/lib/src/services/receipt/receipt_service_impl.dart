import 'dart:async';

import 'package:chat/src/models/user.dart';
import 'package:chat/src/models/receipt.dart';
import 'package:chat/src/services/receipt/receipt_service_contract.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

class ReceiptService implements IReceiptService {
  final Connection? _connection;
  final RethinkDb r;

  final _controller = StreamController<Receipt>.broadcast();
  StreamSubscription? _changefeed;

  ReceiptService(this.r, this._connection);

  @override
  dispose() {
    _changefeed?.cancel();
    _controller.close();
  }

  @override
  Stream<Receipt> receipts(User user) {
    _startReceivingReceipts(user);
    return _controller.stream;
  }

  @override
  Future<bool> send(Receipt receipt) async {
    Map record =
        await r.table('receipts').insert(receipt.toJson()).run(_connection!);
    return record['inserted'] == 1;
  }

  _startReceivingReceipts(user) {
    _changefeed = r
        .table('receipts')
        .filter({'receipient': user.id})
        .changes({'include_initial': true})
        .run(_connection!)
        .asStream()
        .cast<Feed>()
        .listen((event) {
          event
              .forEach((feedData) {
                if (feedData['new_val'] == null) return;
                final receipt = _receiptFromFeed(feedData);
                _controller.sink.add(receipt);
                _removeDeliverredReceipt(receipt);
              })
              .catchError((err) => {print(err)})
              .onError((error, stackTrace) => print(error));
        });
  }

  _receiptFromFeed(feedData) {
    return Receipt.fromJson(feedData['new_val']);
  }

  _removeDeliverredReceipt(Receipt receipt) {
    r
        .table('receipts')
        .get(receipt.id)
        .delete({'return_changes': false}).run(_connection!);
  }
}
