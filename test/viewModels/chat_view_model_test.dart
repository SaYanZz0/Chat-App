import 'package:flutter_newapp/src/ViewModels/chat_view_model.dart';
import 'package:flutter_newapp/src/data/Services/database_contract.dart';
import 'package:flutter_newapp/src/data/models/local_message.dart';
import 'package:flutter_newapp/src/data/models/chat.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:chat/chat.dart';

class IdataSourceMock extends Mock implements IdataSource {}

void main() {
  late ChatViewModel viewModel;
  late IdataSourceMock idataSource;
  final chatId = '123';
  final message = Message(
      from: 'user1',
      to: 'user2',
      contents: 'Hello! How are you?',
      timestamp: DateTime.now());
  final localMessage = LocalMessage(
      chatId: chatId, message: message, receipt: ReceiptStatus.sent);

  setUp(() {
    idataSource = IdataSourceMock();
    viewModel = ChatViewModel(idataSource);
  });

  test('should get messages', () async {
    when(idataSource.findMessages(chatId))
        .thenAnswer((_) async => [localMessage]);

    final result = await viewModel.getMessages(chatId);

    expect(result, [localMessage]);
  });

  test('should delete chat', () async {
    when(idataSource.deleteChat(chatId)).thenAnswer((_) async => null);

    await viewModel.deleteChat(chatId);

    verify(idataSource.deleteChat(chatId)).called(1);
  });

  test('should sent message', () async {
    when(idataSource.addMessage(localMessage)).thenAnswer((_) async => null);

    await viewModel.sentMessage(message);

    verify(idataSource.addMessage(localMessage)).called(1);
  });

  test('should received message', () async {
    when(idataSource.addMessage(localMessage)).thenAnswer((_) async => null);

    await viewModel.receivedMessage(message);

    verify(idataSource.addMessage(localMessage)).called(1);
  });

  test('should update message receipt', () async {
    final receipt = Receipt(
        messageId: '123',
        status: ReceiptStatus.deliverred,
        receipient: 'user1',
        timestamp: DateTime.now());
    when(idataSource.updateMessageReceipt(receipt.messageId!, receipt.status))
        .thenAnswer((_) async => null);

    await viewModel.updateMessageReceipt(receipt);

    verify(idataSource.updateMessageReceipt(receipt.messageId!, receipt.status))
        .called(1);
  });
}
