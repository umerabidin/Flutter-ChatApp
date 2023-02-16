import 'package:chat_app/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  static Future<UserModel?> getUserModelById(String uid) async {
    UserModel? usermodel;
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    if (documentSnapshot.data() != null)
      usermodel =
          UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);

    return usermodel;
  }
}
