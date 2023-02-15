import 'package:chat/chat.dart';
import 'package:equatable/equatable.dart';

abstract class TypingNotificationState extends Equatable {
  const TypingNotificationState();
  factory TypingNotificationState.initial() => TypingNotificationInitial();
  factory TypingNotificationState.sent() => TypingNotificationSentSuccess();
  factory TypingNotificationState.received(TypingEvent event) =>
      TypingNotificationReceivedSuccess(event);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class TypingNotificationInitial extends TypingNotificationState {}

class TypingNotificationSentSuccess extends TypingNotificationState {}

class TypingNotificationReceivedSuccess extends TypingNotificationState {
  TypingEvent event;
  TypingNotificationReceivedSuccess(this.event);

  @override
  List<Object?> get props => [event];
}
