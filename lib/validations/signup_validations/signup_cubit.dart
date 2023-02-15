import 'dart:io';

import 'package:chat_app/models/UserModel.dart';
import 'package:chat_app/validations/signup_validations/signup_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpCubit extends Cubit<SignUpStates> {
  SignUpCubit() : super(InitialSignUpState());

  void isFormValid(String email, String password, String confirmPassword) {
    emit(InitialSignUpState());
    if (email == "") {
      emit(EmailNotValidState("Please enter your email address"));
    } else if (!EmailValidator.validate(email)) {
      emit(EmailNotValidState("Please enter a valid email address"));
    } else if (password == "") {
      emit(PasswordNotValidState("Please enter a password"));
    } else if (password != confirmPassword) {
      emit(PasswordAndConfirmPasswordNotValidState(
          "Please check your password again"));
    } else {
      emit(EnableSignUpButtonState());
    }
  }

  void singUp(String email, String password) async {
    emit(SignUpLoadingState());
    UserCredential? credentials;
    try {
      credentials = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseException catch (ex) {
      emit(SignUpErrorState(ex));
      emit(EnableSignUpButtonState());
    }

    if (credentials != null) {
      String uid = credentials.user!.uid;
      UserModel newUser =
          UserModel(uid: uid, fullname: "", email: email, profile_pic: "");

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(newUser.toMap())
          .then((value) {
        emit(SignUpLoadedState(credentials?.user, newUser));
      });

      // emit(SignUpLoadedState(credentials.user));
    }
  }

  void completeSignUpProcess(
      String fullName, File? imagePath, UserModel userModel) async {
    emit(SignUpLoadingState());
    if (fullName == "") {
      emit(FullNameNotValidState("Please enter full name"));
    } else if (imagePath == null) {
      emit(UserImageNullState("Please choose your image"));
    } else {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref("profile_pictures")
          .child(userModel.uid.toString())
          .putFile(imagePath);

      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();
      userModel.fullname = fullName;
      userModel.profile_pic = imageUrl;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(userModel.uid)
          .set(userModel.toMap())
          .catchError((onError) {
        emit(SignUpErrorState(onError));
      }).then((value) => emit(SignUpCompleteState("")));
    }
  }
}
