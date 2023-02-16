import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/models/FirebaseHelper.dart';
import 'package:chat_app/models/UserModel.dart';
import 'package:chat_app/screens/home.dart';
import 'package:chat_app/screens/login.dart';
import 'package:chat_app/validations/login_validation/login_cubit.dart';
import 'package:chat_app/validations/signup_validations/signup_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  User? firebaseUser = FirebaseAuth.instance.currentUser;
  if (firebaseUser != null) {
    UserModel? user = await FirebaseHelper.getUserModelById(firebaseUser.uid);
    if (user != null) {
      runApp( MyApp(userModel: user, firebaseUser: firebaseUser,));
    }
  } else {
    runApp( MyAppLoggedIn());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.userModel, required this.firebaseUser});

  final UserModel? userModel;
  final User? firebaseUser;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SignUpCubit()),
        BlocProvider(create: (context) => LoginCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(
          userModel: userModel,
          firebaseUser: firebaseUser,
        ),
      ),
    );
  }
}

class MyAppLoggedIn extends StatelessWidget {
  const MyAppLoggedIn({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SignUpCubit()),
        BlocProvider(create: (context) => LoginCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
