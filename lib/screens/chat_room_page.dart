import 'package:chat_app/main.dart';
import 'package:chat_app/models/ChatRoomModel.dart';
import 'package:chat_app/models/MessageModel.dart';
import 'package:chat_app/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModel userModel;
  final UserModel targetUser;
  final User firebaseUser;
  final ChatRoomModel chatRoomModel;

  const ChatRoomPage(
      {super.key,
      required this.userModel,
      required this.targetUser,
      required this.firebaseUser,
      required this.chatRoomModel});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController _sendMessageController = TextEditingController();

  void sendMessage() async {
    String message = _sendMessageController.text.trim();
    _sendMessageController.clear();

    if (message != "") {
      MessageModel newMessage = MessageModel(
          messageId: uuid.v1(),
          createdon: DateTime.now(),
          sender: widget.userModel.uid,
          text: message,
          seen: false);
      FirebaseFirestore.instance.collection("chat_rooms").doc(widget.chatRoomModel.chatroomid)
          .collection("messages").doc(newMessage.messageId).set(newMessage.toMap());

      widget.chatRoomModel.lastMessage = message;
      FirebaseFirestore.instance.collection("chat_rooms")
          .doc(widget.chatRoomModel.chatroomid).set(widget.chatRoomModel.toMap());

    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
                backgroundImage: NetworkImage(widget.userModel.profile_pic!)),
            const SizedBox(
              width: 10,
            ),
            Text(widget.userModel.fullname.toString())
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                  child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chat_rooms")
                      .doc(widget.chatRoomModel.chatroomid)
                      .collection("messages")
                      .orderBy("createdon", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot dataSnapshot =
                            snapshot.data as QuerySnapshot;
                        return ListView.builder(
                          reverse: true,
                          itemCount: dataSnapshot.docs.length,
                          itemBuilder: (context, index) {
                            MessageModel currentMessage = MessageModel.fromMap(
                                dataSnapshot.docs[index].data()
                                    as Map<String, dynamic>);
                            return Row(
                              mainAxisAlignment: (currentMessage.sender ==
                                      widget.userModel.uid)
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: (currentMessage.sender ==
                                              widget.userModel.uid)
                                          ? Colors.grey
                                          : Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(3))),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    currentMessage.text.toString(),
                                    style:  TextStyle(
                                        color: (currentMessage.sender ==
                                                widget.userModel.uid)
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: 15),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return const Text(
                            "An error occurred!, please check your internet connection");
                      } else {
                        return const Center(
                          child: Text("Say hi! to your new friend!"),
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              )),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                color: Colors.grey[200],
                child: Row(
                  children: [
                    Flexible(
                        child: TextField(
                            maxLines: null,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Send Message"),
                            onChanged: (onChanged) {},
                            controller: _sendMessageController)),
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      onPressed: () {
                        sendMessage();
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
