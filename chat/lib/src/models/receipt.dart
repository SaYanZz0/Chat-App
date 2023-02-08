enum ReceiptStatus { sent, deleivred, read }

extension EnumParsing on ReceiptStatus {
  String value() {
    return toString().split('.').last;
  }

  static ReceiptStatus fromString(String status) {
    return ReceiptStatus.values
        .firstWhere((element) => element.value() == status);
  }
}

class Receipt {
  final String? receipient;
  final String? messageId;
  final ReceiptStatus status;
  final DateTime? timestamp;
  String? _id;
  String? get id => _id;

  Receipt(
      {required this.receipient,
      required this.messageId,
      required this.status,
      required this.timestamp});

  Map<String, dynamic> toJson() => {
        'receipient': receipient,
        'messageId': messageId,
        'status': status.value(),
        'timestamp': timestamp
      };

  factory Receipt.fromJson(Map<String, dynamic> json) {
    var receipt = Receipt(
        receipient: json['receipient'],
        messageId: json['messageId'],
        status: EnumParsing.fromString(json['status']),
        timestamp: json['timestamp']);
    receipt._id = json['id'];
    return receipt;
  }
}
