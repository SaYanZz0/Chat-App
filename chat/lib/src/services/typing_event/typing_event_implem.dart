import 'dart:async';

import 'package:chat/src/models/user.dart';
import 'package:chat/src/models/typing_event.dart';
import 'package:chat/src/services/typing_event/typing_event_contract.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

import '../user/user_services_contract.dart';

class TypingNotificationService implements ITypingNotification {
  final Connection? connection;
  final RethinkDb r;

  final controller = StreamController<TypingEvent>.broadcast();
  StreamSubscription? _changefeed;
  IUserService? _userService;

  TypingNotificationService(this.r, this.connection, this._userService);
  @override
  dispose() {
    _changefeed?.cancel();
    controller.close();
  }

  @override
  Future<bool?> send({required List<TypingEvent> events}) async {
    final receivers =
        await _userService!.fetch(events.map((e) => e.to).toList());
    if (receivers.isEmpty) return false;

    events
        .retainWhere((event) => receivers.map((e) => e.id).contains(event.to));
    final data = events.map((e) => e.toJson()).toList();
    Map record = await r
        .table('typing_events')
        .insert(data, {'conflict': 'update'}).run(connection!);

    return record['inserted'] >= 1;
  }

  @override
  Stream<TypingEvent> subscribe(User user, List<String> userIds) {
    _startReceivingTypingEvents(user, userIds);
    return controller.stream;
  }

  _startReceivingTypingEvents(User user, List<String?> userIds) {
    _changefeed = r
        .table('typing_events')
        .filter((event) {
          return event('to')
              .eq(user.id)
              .and(r.expr(userIds).contains(event('from')));
        })
        .changes({'include_initial': true})
        .run(connection!)
        .asStream()
        .cast<Feed>()
        .listen((event) {
          event
              .forEach((feedData) {
                if (feedData['new_val'] == null) return;
                final typing = _eventFromFeed(feedData);
                controller.sink.add(typing);
                _removeEvent(typing);
              })
              .catchError((err) => {print(err)})
              .onError((error, stackTrace) => print(error));
        });
  }

  _eventFromFeed(feedData) {
    return TypingEvent.fromJson(feedData['new_val']);
  }

  _removeEvent(TypingEvent typing) {
    r.table('typing_events').filter({'chat_id': typing.chatId}).delete(
        {'return_changes': false}).run(connection!);
  }
}
