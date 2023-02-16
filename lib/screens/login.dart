import 'package:chat_app/screens/home.dart';
import 'package:chat_app/screens/signup.dart';
import 'package:chat_app/validations/login_validation/login_cubit.dart';
import 'package:chat_app/validations/login_validation/login_states.dart';
import 'package:chat_app/widgets/buttons/Button.dart';
import 'package:chat_app/widgets/textinput.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Chat App",
                    style: TextStyle(
                        fontSize: 40,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, state) {
                        if (state is EmailNotValidState) {
                          return Text(state.message,
                              style: TextStyle(color: HexColor("#5F211CFF")));
                        }
                        return Container();
                      },
                    ),
                  ),
                  TextInputField(
                      icon: Icons.email,
                      placeholder: "Email address",
                      onChanged: (value) {
                        BlocProvider.of<LoginCubit>(context).isFormValid(
                            _emailController.text.trim(),
                            _passwordController.text.trim());
                      },
                      controller: _emailController),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, state) {
                        if (state is PasswordNotValidState) {
                          return Text(state.message,
                              style: const TextStyle(color: Colors.red));
                        }
                        return Container();
                      },
                    ),
                  ),
                  TextInputField(
                    placeholder: "Password",
                    obscureText: true,
                    onChanged: (value) {
                      BlocProvider.of<LoginCubit>(context).isFormValid(
                          _emailController.text.trim(),
                          _passwordController.text.trim());
                    },
                    controller: _passwordController,
                    icon: Icons.visibility_off,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  BlocConsumer<LoginCubit, LoginState>(
                    listener: (context, state) {
                      if (state is LoginErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(state.exception.message.toString())));
                      }
                      if (state is LoginLoadedState) {
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(userModel: state.user!, firebaseUser: state.firebaseUser!,),
                            ));
                      }
                    },
                    builder: (context, state) {
                      if (state is LoginLoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Button(
                          onPressed: (state is EnableLoginButtonState)
                              ? () => signIn()
                              : null,
                          title: "Sign In");
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Don't have an account?",
              style: TextStyle(fontSize: 16),
            ),
            CupertinoButton(
                child: const Text("Signup", style: TextStyle(fontSize: 16)),
                onPressed: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const SignUpPage(),
                    )))
          ],
        ),
      ),
    );
  }

  signIn() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    BlocProvider.of<LoginCubit>(context).login(email, password);
  }
}
