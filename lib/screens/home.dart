import 'package:chat_app/models/ChatRoomModel.dart';
import 'package:chat_app/models/FirebaseHelper.dart';
import 'package:chat_app/models/UserModel.dart';
import 'package:chat_app/screens/chat_room_page.dart';
import 'package:chat_app/screens/login.dart';
import 'package:chat_app/screens/search_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);
  final UserModel? userModel;
  final User? firebaseUser;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.popUntil(
                context,
                (route) => route.isFirst,
              );
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ));
            },
            icon: const Icon(Icons.exit_to_app))
      ], title: const Text("Home Screen")),
      body: SafeArea(
          child: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("chat_rooms")
              .where("participants.${widget.userModel!.uid}", isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                QuerySnapshot chatRoomQuerySnapshot = snapshot.data as QuerySnapshot;
                return ListView.builder(
                  itemCount: chatRoomQuerySnapshot.docs.length,
                  itemBuilder: (context, index) {
                    ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                        chatRoomQuerySnapshot.docs[index].data()
                            as Map<String, dynamic>);
                    Map<String, dynamic> participants =
                        chatRoomModel.participants!;

                    List<String>? participantKeys = participants.keys.toList();
                    participantKeys.remove(widget.userModel?.uid.toString());
                    return FutureBuilder(
                      future:
                          FirebaseHelper.getUserModelById(participantKeys[0]),
                      builder: (context, userData) {
                        if (userData.connectionState == ConnectionState.done) {
                          if (userData.data != null) {
                            UserModel targetUser = userData.data as UserModel;
                            return ListTile(
                              onTap: () async {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => ChatRoomPage(
                                        userModel: widget.userModel!,
                                        targetUser: targetUser,
                                        firebaseUser: widget.firebaseUser!,
                                        chatRoomModel: chatRoomModel,
                                      ),
                                    ));
                              },
                              leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      targetUser.profile_pic.toString())),
                              title: Text(targetUser.fullname.toString()),
                              subtitle: Text(
                                  "Last Message: ${chatRoomModel.lastMessage}"),
                            );
                          } else {
                            return const Center(
                              child:
                                  Text("Error Found! Please try again later"),
                            );
                          }
                        } else {
                          return Container();
                        }
                      },
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Container(
                  margin: const EdgeInsets.all(40),
                  child: const Center(
                    child: Text(
                      "Search the user to start conversation!",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: Text("Hurrah!"),
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
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(
                      userModel: widget.userModel!,
                      firebaseUser: widget.firebaseUser!),
                ));
          },
          child: const Icon(Icons.search)),
    );
  }
}
