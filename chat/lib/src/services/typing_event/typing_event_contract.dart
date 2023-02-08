import '../../models/typing_event.dart';
import '../../models/user.dart';

abstract class ITypingNotification {
  Future<bool?> send({required List<TypingEvent> events});
  Stream<TypingEvent> subscribe(User user, List<String> userIds);
  dispose();
}
