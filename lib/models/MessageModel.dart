class MessageModel {
  String? messageId;
  String? sender;
  String? text;
  DateTime? createdon;
  bool? seen;

  MessageModel({this.messageId,this.sender, this.text, this.createdon, this.seen});

  MessageModel.fromMap(Map<String, dynamic> map) {
    sender = map["sender"];
    messageId = map["messageId"];
    text = map["text"];
    createdon = map["createdon"].toDate();
    seen = map["seen"];
  }

  Map<String, dynamic> toMap() {
    return {
      "messageId": messageId,
      "sender": sender,
      "text": text,
      "seen": seen,
      "createdon": createdon,
    };
  }
}
