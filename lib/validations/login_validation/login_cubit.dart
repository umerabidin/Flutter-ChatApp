import 'package:chat_app/models/UserModel.dart';
import 'package:chat_app/validations/login_validation/login_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(InitialLoginState());

  void isFormValid(String email, String password) {
    emit(InitialLoginState());
    if (email == "") {
      emit(EmailNotValidState("Please enter your email address"));
    } else if (!EmailValidator.validate(email)) {
      emit(EmailNotValidState("Please enter a valid email address"));
    } else if (password == "") {
      emit(PasswordNotValidState("Please enter a password"));
    } else {
      emit(EnableLoginButtonState());
    }
  }

  void login(String email, String password) async {
    emit(LoginLoadingState());
    UserCredential? credentials;
    try {
      credentials = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseException catch (ex) {
      emit(LoginErrorState(ex));
      emit(EnableLoginButtonState());
    }

    if (credentials != null) {
      String uid = credentials.user!.uid;
      DocumentSnapshot userModel =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      UserModel user =
          UserModel.fromMap(userModel.data() as Map<String, dynamic>);
      emit(LoginLoadedState(user));
      emit(EnableLoginButtonState());}
  }
}
