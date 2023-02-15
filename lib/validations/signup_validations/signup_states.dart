import 'package:chat_app/models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class SignUpStates {}

class InitialSignUpState extends SignUpStates {}

class EmailNotValidState extends SignUpStates {
  String message;
  EmailNotValidState(this.message);

}class FullNameNotValidState extends SignUpStates {
  String message;
  FullNameNotValidState(this.message);

}class UserImageNullState extends SignUpStates {
  String message;
  UserImageNullState(this.message);

}class SignUpCompleteState extends SignUpStates {
  String message;
  SignUpCompleteState(this.message);

}

class PasswordNotValidState extends SignUpStates {
  String message;
  PasswordNotValidState(this.message);

}

class PasswordAndConfirmPasswordNotValidState extends SignUpStates {
  String message;
  PasswordAndConfirmPasswordNotValidState(this.message);

}

class EnableSignUpButtonState extends SignUpStates {}
class SignUpLoadingState extends SignUpStates {}
class SignUpLoadedState extends SignUpStates {
  User? user;
  UserModel newUser;
  SignUpLoadedState( this.user, this. newUser);

}
class SignUpErrorState extends SignUpStates {
  FirebaseException exception;
  SignUpErrorState(this.exception);

}
