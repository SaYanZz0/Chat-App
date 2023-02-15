import 'package:chat/chat.dart';
import 'package:equatable/equatable.dart';

abstract class ReceiptEvent extends Equatable {
  const ReceiptEvent();
  factory ReceiptEvent.subscribe(User user) => Subscribed(user);
  factory ReceiptEvent.sent(Receipt receipt) => ReceiptSent(receipt);
  factory ReceiptEvent.receive(Receipt receipt) => ReceiptReceived(receipt);
  @override
  List<Object?> get props => [];
}

class Subscribed extends ReceiptEvent {
  User user;

  Subscribed(this.user);

  @override
  List<Object?> get props => [user];
}

class ReceiptSent extends ReceiptEvent {
  Receipt receipt;

  ReceiptSent(this.receipt);
  @override
  // TODO: implement props
  List<Object?> get props => [receipt];
}

class ReceiptReceived extends ReceiptEvent {
  Receipt receipt;
  ReceiptReceived(this.receipt);

  @override
  // TODO: implement props
  List<Object?> get props => [receipt];
}
