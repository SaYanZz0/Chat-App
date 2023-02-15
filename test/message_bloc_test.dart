import 'package:chat/chat.dart';
import 'package:flutter_newapp/src/blocs/message/message_bloc.dart';
import 'package:flutter_newapp/src/blocs/message/message_event.dart';
import 'package:flutter_newapp/src/blocs/message/message_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FakeMessageService extends Mock implements IMessageService {}

void main() {
  late MessageBloc sut;
  late IMessageService messageService;
  late User user;

  setUp(() {
    messageService = FakeMessageService();
    user = User(
        username: 'test', photoUrl: '', active: true, lastSeen: DateTime.now());
    sut = MessageBloc(messageService: messageService);
  });

  tearDown(() => sut.close());

  test('it should emit initial state before Subscription',
      () => expect(sut.state, MessageInitial()));

  test('should emit message sent state when message is sent', () {
    final message = Message(
        from: '1234',
        to: '123',
        timestamp: DateTime.now(),
        contents: 'Hellllo');
    when(messageService.send([message]))
        .thenAnswer((_) async => Future.value());
    sut.add(MessageEvent.onMessageSent([message]));
    expectLater(sut.stream, emits(MessageState.sent(message)));
  });
/** 
  test('should emit messages received from service', () {
    final message = Message(
      from: '123',
      to: '456',
      contents: 'test message',
      timestamp: DateTime.now(),
    );

    when(messageService.messages(activeUser: anyNamed('activeUser')))
        .thenAnswer((_) => Stream.fromIterable([message]));

    sut.add(MessageEvent.onSubscribed(user));
    expectLater(
        sut.stream, emitsInOrder([MessageReceivedSuccesfully(message)]));
  });

  */
}
