import 'package:chat/chat.dart';
import 'package:equatable/equatable.dart';

abstract class MessageState extends Equatable {
  const MessageState();
  factory MessageState.initial() => MessageInitial();
  factory MessageState.sent(Message message) => MessageSentSuccesfully(message);
  factory MessageState.received(Message message) =>
      MessageReceivedSuccesfully(message);
  @override
  List<Object> get props => [];
}

class MessageInitial extends MessageState {}

class MessageSentSuccesfully extends MessageState {
  final Message message;
  const MessageSentSuccesfully(this.message);

  @override
  List<Object> get props => [message];
}

class MessageReceivedSuccesfully extends MessageState {
  final Message message;
  const MessageReceivedSuccesfully(this.message);

  @override
  List<Object> get props => [message];
}
