class ChatRoomModel {
  String? chatroomid;
  List<String>? participants;

  ChatRoomModel({this.chatroomid, this.participants});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatroomid = map["uid"];
    participants = map["participants"];
  }

  Map<String, dynamic> toMap() {
    return {
      "chatroomid": chatroomid,
      "participants": participants,
    };
  }
}
