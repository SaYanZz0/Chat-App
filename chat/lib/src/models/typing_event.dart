enum Typing { start, stop }

extension TypingParser on Typing {
  String value() {
    return this.toString().split('.').last;
  }

  static Typing fromString(String? event) {
    return Typing.values.firstWhere((element) => element.value() == event);
  }
}

class TypingEvent {
  final String? from;
  final String? to;
  final Typing event;
  String? chatId;
  String? _id;
  String? get id => _id;

  TypingEvent(
      {required this.from,
      required this.to,
      required this.event,
      required this.chatId});

  Map<String, dynamic> toJson() => {
        'chat_id': chatId,
        'from': from,
        'to': to,
        'event': event.value(),
      };

  factory TypingEvent.fromJson(Map<String, dynamic> json) {
    var event = TypingEvent(
      chatId: json['chat_id'],
      from: json['from'],
      to: json['to'],
      event: TypingParser.fromString(json['event']),
    );
    event._id = json['id'];
    return event;
  }
}
