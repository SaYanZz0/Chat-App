import 'package:chat/chat.dart';
import 'package:flutter_newapp/src/ViewModels/chats_view_model.dart';
import 'package:flutter_newapp/src/data/Services/database_contract.dart';
import 'package:flutter_newapp/src/data/models/chat.dart';
import 'package:flutter_newapp/src/data/models/local_message.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDatasource extends Mock implements IdataSource {
  @override
  Future<List<Chat>> findAllChats() {
    return super.noSuchMethod(Invocation.method(#findAllChats, []),
        returnValue: Future<List<Chat>>.value([]));
  }

  @override
  Future<Chat> findChat(String? chatId) {
    return super.noSuchMethod(Invocation.method(#findChat, [chatId]),
        returnValue: Future<Chat>.value());
  }

  @override
  Future<void> addChat(Chat? chat) {
    return super.noSuchMethod(Invocation.method(#addChat, [chat]),
        returnValue: Future<void>.value());
  }

  @override
  Future<void> addMessage(LocalMessage? message) {
    return super.noSuchMethod(Invocation.method(#addMessage, [message]),
        returnValue: Future<void>.value());
  }
}

class MockUserService extends Mock implements IUserService {}

void main() {
  late ChatsViewModel sut;
  late MockDatasource mockDatasource;
  late MockUserService mockUserService;

  setUp(() {
    mockDatasource = MockDatasource();
    mockUserService = MockUserService();
    sut = ChatsViewModel(mockDatasource, mockUserService);
  });

  final message = Message.fromJson({
    'from': '111',
    'to': '222',
    'contents': 'hey',
    'timestamp': DateTime.parse("2021-04-01"),
    'id': '4444'
  });

  test('initial chats return empty list', () async {
    when(mockDatasource.findAllChats()).thenAnswer((_) async => []);
    expect(await sut.getChats(), isEmpty);
  });

  test('returns list of chats', () async {
    final chat = Chat('123', ChatType.private);
    when(mockDatasource.findAllChats()).thenAnswer((_) async => [chat]);
    final chats = await sut.getChats();
    expect(chats, isNotEmpty);
  });

  test('creates a new chat when receiving message for the first time',
      () async {
    when(mockDatasource.findChat(any))
        .thenAnswer((_) async => Future.value(null));
    await sut.receivedMessage(message);
    verify(mockDatasource.addChat(any)).called(1);
  });

  test('add new message to existing chat', () async {
    final chat = Chat('123', ChatType.private);
    when(mockDatasource.findChat(any)).thenAnswer((_) async => chat);
    await sut.receivedMessage(message);
    verifyNever(mockDatasource.addChat(any));
    verify(mockDatasource.addMessage(any)).called(1);
  });
}
