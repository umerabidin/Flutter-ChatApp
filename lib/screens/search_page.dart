import 'dart:developer';

import 'package:chat_app/main.dart';
import 'package:chat_app/models/ChatRoomModel.dart';
import 'package:chat_app/models/UserModel.dart';
import 'package:chat_app/screens/chat_room_page.dart';
import 'package:chat_app/widgets/buttons/Button.dart';
import 'package:chat_app/widgets/textinput.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const SearchPage(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  Future<ChatRoomModel?> getChatRoomModel(UserModel targetUser) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("chat_rooms")
        .where("participants.${widget.userModel.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();

    if (querySnapshot.docs.length>0) {
      var docData = querySnapshot.docs[0].data();
      ChatRoomModel existingChatRoom = ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      return existingChatRoom;
    } else {
      ChatRoomModel newChatRoom = ChatRoomModel(
          chatroomid: uuid.v1(),
          lastMessage: "",
          createdon: DateTime.now(),
          participants: {
            widget.userModel.uid.toString(): true,
            targetUser.uid.toString(): true
          });

      await FirebaseFirestore.instance
          .collection("chat_rooms")
          .doc(newChatRoom.chatroomid)
          .set(newChatRoom.toMap());

      return newChatRoom;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextInputField(
              onChanged: (value) {
                setState(() {});
              },
              controller: _searchController,
              icon: Icons.search,
              placeholder: "Search",
            ),
            const SizedBox(
              height: 20,
            ),
            Button(
                onPressed: () {
                  setState(() {});
                },
                title: "Search"),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where("email", isEqualTo: _searchController.text.trim())
                  .where("email", isNotEqualTo: widget.userModel.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot querySnapshot =
                        snapshot.data as QuerySnapshot;
                    if (querySnapshot.docs.length > 0) {
                      Map<String, dynamic> userMap =
                          querySnapshot.docs[0].data() as Map<String, dynamic>;
                      UserModel searchedUser = UserModel.fromMap(userMap);
                      return Container(
                        child: ListTile(
                          onTap: () async {
                            ChatRoomModel? chatRoomModel =
                                await getChatRoomModel(searchedUser);
                            if (chatRoomModel != null) {

                              // Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => ChatRoomPage(
                                      userModel: widget.userModel,
                                      targetUser: searchedUser,
                                      firebaseUser: widget.firebaseUser,
                                      chatRoomModel: chatRoomModel,
                                    ),
                                  ));
                            }
                          },
                          trailing: Icon(Icons.keyboard_arrow_right),
                          leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(searchedUser.profile_pic!)),
                          title: Text(searchedUser.fullname.toString()),
                          subtitle: Text(searchedUser.email.toString()),
                        ),
                      );
                    }
                    return Center(
                      child: Text("No results found"),
                    );
                  } else if (snapshot.hasError) {
                    return Text("An error occourd!");
                  } else {
                    return Text("No results found");
                  }
                } else {
                  return CircularProgressIndicator();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
