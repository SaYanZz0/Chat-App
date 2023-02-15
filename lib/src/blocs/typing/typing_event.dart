import 'package:chat/chat.dart';
import 'package:equatable/equatable.dart';

abstract class TypingNotificationEvent extends Equatable {
  const TypingNotificationEvent();
  factory TypingNotificationEvent.onSubscribed(User user,
          {List<String>? usersWithChat}) =>
      Subscribed(user, usersWithchat: usersWithChat);
  factory TypingNotificationEvent.onTypingEventSent(List<TypingEvent> events) =>
      TypingNotificationSent(events);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class Subscribed extends TypingNotificationEvent {
  final User user;
  final List<String>? usersWithchat;

  const Subscribed(this.user, {this.usersWithchat});

  @override
  // TODO: implement props
  List<Object?> get props => [user, usersWithchat];
}

class NotSubscribed extends TypingNotificationEvent {}

class TypingNotificationSent extends TypingNotificationEvent {
  final List<TypingEvent> events;
  const TypingNotificationSent(this.events);

  @override
  // TODO: implement props
  List<Object?> get props => [events];
}

class TypingNotificationReceived extends TypingNotificationEvent {
  final TypingEvent event;

  const TypingNotificationReceived(this.event);
  @override
  // TODO: implement props
  List<Object?> get props => [event];
}
