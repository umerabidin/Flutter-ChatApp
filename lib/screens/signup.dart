import 'dart:developer';

import 'package:chat_app/screens/complete_profile_screen.dart';
import 'package:chat_app/validations/signup_validations/signup_cubit.dart';
import 'package:chat_app/validations/signup_validations/signup_states.dart';
import 'package:chat_app/widgets/buttons/Button.dart';
import 'package:chat_app/widgets/textinput.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: ListView(
          children: [
            BlocBuilder<SignUpCubit, SignUpStates>(
              builder: (context, state) {
                if (state is EmailNotValidState) {
                  return Text(state.message,
                      style: TextStyle(color: Colors.red));
                }
                return Container();
              },
            ),
            TextInputField(
              onChanged: (value) {
                BlocProvider.of<SignUpCubit>(context).isFormValid(
                    value.trim(),
                    _passwordController.text.trim(),
                    _cPasswordController.text.trim());
              },
              placeholder: "Email address",
              controller: _emailController,
              icon: Icons.email,
            ),
            SizedBox(
              height: 10,
            ),
            BlocBuilder<SignUpCubit, SignUpStates>(
              builder: (context, state) {
                if (state is PasswordNotValidState) {
                  return Text(state.message,
                      style: TextStyle(color: Colors.red));
                }
                return Container();
              },
            ),
            TextInputField(
                obscureText: true,
                placeholder: "Password",
                onChanged: (value) {
                  BlocProvider.of<SignUpCubit>(context).isFormValid(
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                      _cPasswordController.text.trim());
                },
                controller: _passwordController,
                icon: Icons.visibility),
            SizedBox(
              height: 10,
            ),
            BlocBuilder<SignUpCubit, SignUpStates>(
              builder: (context, state) {
                if (state is PasswordAndConfirmPasswordNotValidState) {
                  return Text(state.message,
                      style: TextStyle(color: Colors.red));
                }
                return Container();
              },
            ),
            TextInputField(
                obscureText: true,
                placeholder: "Confirm Password",
                onChanged: (value) {
                  BlocProvider.of<SignUpCubit>(context).isFormValid(
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                      _cPasswordController.text.trim());
                },
                controller: _cPasswordController,
                icon: Icons.visibility),
            const SizedBox(
              height: 20,
            ),

            BlocConsumer<SignUpCubit, SignUpStates>(
              listener: (context, state) {
                if(state is SignUpErrorState){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.exception.message.toString())));
                }
                if(state is SignUpLoadedState){
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      CompleteProfileScreen(userModel: state.newUser, firebaseUser: state.user!),));
                }

              },
              builder: (context, state) {
                if(state is SignUpLoadingState){
                  return const Center(child: CircularProgressIndicator(),);
                }
                return Button(
                    onPressed: (state is EnableSignUpButtonState)
                    ? () => verifyFields()
                    : null,
                    title: "Complete Profile");
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already have an account?",
              style: TextStyle(fontSize: 16),
            ),
            CupertinoButton(
                child: Text("Login", style: TextStyle(fontSize: 16)),
                onPressed: () => Navigator.pop(context))
          ],
        ),
      ),
    );
  }

  void verifyFields() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    BlocProvider.of<SignUpCubit>(context).singUp(email, password);
  }
}
