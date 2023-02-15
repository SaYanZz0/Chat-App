import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';
import 'package:flutter_newapp/src/blocs/message/message_event.dart';
import 'package:flutter_newapp/src/blocs/message/message_state.dart';

// class MessageBloc extends Bloc<MessageEvent, MessageState> {
//   final IMessageService _messageService;
//   StreamSubscription? _subscription;
//   MessageBloc(this._messageService) : super(MessageState.initial());

//   @override
//   Stream<MessageState> mapEventToState(MessageEvent event) async* {
//     if (event is Subscribed) {
//       await _subscription?.cancel();
//       _subscription = _messageService
//           .messages(activeUser: event.user)
//           .listen((message) => add(MessageReceived(message)));
//     }

//     if (event is MessageReceived) {
//       yield MessageState.received(event.message);
//     }
//     if (event is MessageSent) {
//       final message = await _messageService.send(event.messages);
//       yield MessageState.sent(message);
//     }
//   }

//   @override
//   Future<void> close() {
//     _subscription?.cancel();
//     _messageService.dispose();
//     return super.close();
//   }
// }

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc({
    required this.messageService,
  }) : super(MessageState.initial()) {
    on<Subscribed>(subscribed);
    on<MessageSent>(messageSent);
    on<MessageReceived>(messageReceived);
  }

  final IMessageService messageService;
  StreamSubscription? _subscription;

  void subscribed(Subscribed event, Emitter<MessageState> emit) async {
    await _subscription?.cancel();
    _subscription =
        messageService.messages(activeUser: event.user).listen((message) {
      add(MessageReceived(message));
      emit(MessageState.received(message));
    });
  }

  void messageSent(MessageSent event, Emitter<MessageState> emit) async {
    final message = await messageService.send(event.messages);
    emit(MessageState.sent(message));
  }

  void messageReceived(MessageReceived event, Emitter<MessageState> emit) {
    emit(MessageState.received(event.message));
  }
}
