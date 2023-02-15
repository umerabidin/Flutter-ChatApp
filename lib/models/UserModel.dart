class UserModel {
  String? uid;
  String? fullname;
  String? email;
  String? profile_pic;

  UserModel({this.uid, this.fullname, this.email, this.profile_pic});

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    email = map["email"];
    fullname = map["fullname"];
    profile_pic = map["profilepic"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullname": fullname,
      "email": email,
      "profilepic": profile_pic,
    };
  }
}
