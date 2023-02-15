import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';
import 'package:flutter_newapp/src/blocs/typing/typing_event.dart';
import 'package:flutter_newapp/src/blocs/typing/typing_state.dart';

class TypingNotificationBloc
    extends Bloc<TypingNotificationEvent, TypingNotificationState> {
  ITypingNotification typingNotificationService;
  StreamSubscription? _subscription;

  TypingNotificationBloc(this.typingNotificationService)
      : super(TypingNotificationState.initial());

  @override
  Stream<TypingNotificationState> mapEventToState(
      TypingNotificationEvent event) async* {
    if (event is Subscribed) {
      if (event.usersWithchat == null) {
        add(NotSubscribed());
        return;
      }
      _subscription?.cancel();
      _subscription = typingNotificationService
          .subscribe(event.user, event.usersWithchat!)
          .listen((typingevent) {
        add(TypingNotificationReceived(typingevent));
      });
    }
    if (event is TypingNotificationReceived) {
      TypingNotificationState.received(event.event);
    }
    if (event is TypingNotificationSent) {
      await typingNotificationService.send(events: event.events);
      TypingNotificationState.sent();
    }
    if (event is NotSubscribed) {
      TypingNotificationState.initial();
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    typingNotificationService.dispose();
    return super.close();
  }
}

// class TypingNotificationBloc
//     extends Bloc<TypingNotificationEvent, TypingNotificationState> {
//   TypingNotificationBloc({
//     required this.repository,
//   }) : super(TypingNotificationState.initial()) {
//     on<Subscribed>(subscribed);
//     on<NotSubscribed>(notSubscribed);
//     on<TypingNotificationSent>(typingNotificationSent);
//     on<TypingNotificationReceived>(typingNotificationReceived);
//   }

//   ITypingNotification repository;
//   StreamSubscription? _subscription;

//   void subscribed(Subscribed event, Emitter<TypingNotificationState> emit) {
//     // code for handling Subscribed event
//     if (event.usersWithchat == null) {
//       emit(TypingNotificationState.initial());
//     }
//     _subscription?.cancel();
//     _subscription = repository
//         .subscribe(event.user, event.usersWithchat!)
//         .listen((typingevent) {
//       emit(TypingNotificationState.received(typingevent));
//     });
//   }

//   void notSubscribed(
//       NotSubscribed event, Emitter<TypingNotificationState> emit) {
//     // code for handling NotSubscribed event
//     TypingNotificationState.initial();
//   }

//   void typingNotificationSent(TypingNotificationSent event,
//       Emitter<TypingNotificationState> emit) async {
//     await repository.send(events: event.events);
//     emit(TypingNotificationState.sent());
//   }

//   void typingNotificationReceived(
//       TypingNotificationReceived event, Emitter<TypingNotificationState> emit) {
//     // code for handling TypingNotificationReceived event
//     emit(TypingNotificationState.received(event.event));
//   }
// }
