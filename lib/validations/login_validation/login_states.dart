import 'package:chat_app/models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginState {}

class InitialLoginState extends LoginState {}

class EmailNotValidState extends LoginState {
  String message;
  EmailNotValidState(this.message);

}

class PasswordNotValidState extends LoginState {
  String message;
  PasswordNotValidState(this.message);

}

class PasswordAndConfirmPasswordNotValidState extends LoginState {
  String message;
  PasswordAndConfirmPasswordNotValidState(this.message);

}

class EnableLoginButtonState extends LoginState {}
class LoginLoadingState extends LoginState {}
class LoginLoadedState extends LoginState {
  UserModel? user;
  User? firebaseUser;
  LoginLoadedState(this.user, this.firebaseUser);

}
class LoginErrorState extends LoginState {
  FirebaseException exception;
  LoginErrorState(this.exception);

}
