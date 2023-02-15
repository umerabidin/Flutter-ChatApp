class MessageModel {
  String? sender;
  String? text;
  DateTime? createdon;
  bool? seen;

  MessageModel({this.sender, this.text, this.createdon, this.seen});

  MessageModel.fromMap(Map<String, dynamic> map) {
    sender = map["sender"];
    text = map["text"];
    createdon = map["createdon"];
    seen = map["seen"];
  }

  Map<String, dynamic> toMap() {
    return {
      "sender": sender,
      "createdon": createdon,
      "seen": seen,
      "createdon": createdon,
    };
  }
}
