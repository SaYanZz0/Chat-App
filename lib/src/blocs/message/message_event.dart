import 'package:chat/chat.dart';
import 'package:equatable/equatable.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();
  factory MessageEvent.onSubscribed(User user) => Subscribed(user);
  factory MessageEvent.onMessageSent(List<Message> messages) =>
      MessageSent(messages);
  @override
  List<Object?> get props => [];
}

class Subscribed extends MessageEvent {
  final User user;

  Subscribed(this.user);

  @override
  List<Object?> get props => [user];
}

class MessageSent extends MessageEvent {
  final List<Message> messages;
  MessageSent(this.messages);

  @override
  List<Object> get props => [messages];
}

class MessageReceived extends MessageEvent {
  MessageReceived(this.message);

  final Message message;

  @override
  List<Object> get props => [message];
}
