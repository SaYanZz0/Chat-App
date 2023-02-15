import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_newapp/src/blocs/receipt/receipt_event.dart';
import 'package:flutter_newapp/src/blocs/receipt/receipt_state.dart';

class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
  final IReceiptService _receiptService;
  StreamSubscription? _subscription;

  ReceiptBloc(this._receiptService) : super(ReceiptState.initial());

  @override
  Stream<ReceiptState> mapEventToState(ReceiptEvent event) async* {
    if (event is Subscribed) {
      await _subscription?.cancel();
      _subscription = _receiptService
          .receipts(event.user)
          .listen((receipt) => add(ReceiptReceived(receipt)));
    }

    if (event is ReceiptReceived) {
      yield ReceiptState.received(event.receipt);
    }
    if (event is ReceiptSent) {
      await _receiptService.send(event.receipt);
      yield ReceiptState.sent(event.receipt);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _receiptService.dispose();
    return super.close();
  }
}

// class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
//   ReceiptBloc({
//     required this.receiptService,
//   }) : super(ReceiptState.initial()) {
//     on<Subscribed>(subscribed);
//     on<ReceiptSent>(receiptSent);
//     on<ReceiptReceived>(receiptReceived);
//   }

//   final IReceiptService receiptService;
//   StreamSubscription? _subscription;

//   void subscribed(Subscribed event, Emitter<ReceiptState> emit) async {
//     await _subscription?.cancel();
//     _subscription = receiptService.receipts(event.user).listen((receipt) {
//       add(ReceiptReceived(receipt));
//       emit(ReceiptState.received(receipt));
//     });
//   }

//   void receiptSent(ReceiptSent event, Emitter<ReceiptState> emit) async {
//     await _receiptService.send(event.receipt);
//     emit(ReceiptState.sent(event.receipt));
//   }

//   void receiptReceived(ReceiptReceived event, Emitter<ReceiptState> emit) {
//     emit(ReceiptState.received(event.receipt));
//   }
// }
