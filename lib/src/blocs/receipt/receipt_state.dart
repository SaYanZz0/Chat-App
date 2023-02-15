import 'package:chat/chat.dart';
import 'package:equatable/equatable.dart';

abstract class ReceiptState extends Equatable {
  const ReceiptState();

  factory ReceiptState.initial() => ReceiptInitial();
  factory ReceiptState.sent(Receipt receipt) => ReceiptSentSuccess(receipt);
  factory ReceiptState.received(Receipt receipt) =>
      ReceiptReceivedSuccess(receipt);
  @override
  List<Object?> get props => throw UnimplementedError();
}

class ReceiptInitial extends ReceiptState {}

class ReceiptSentSuccess extends ReceiptState {
  Receipt receipt;
  ReceiptSentSuccess(this.receipt);

  @override
  List<Object?> get props => [receipt];
}

class ReceiptReceivedSuccess extends ReceiptState {
  Receipt receipt;
  ReceiptReceivedSuccess(this.receipt);

  @override
  List<Object?> get props => [receipt];
}
