import 'dart:io';

import 'package:chat_app/models/UserModel.dart';
import 'package:chat_app/screens/home.dart';
import 'package:chat_app/validations/signup_validations/signup_cubit.dart';
import 'package:chat_app/validations/signup_validations/signup_states.dart';
import 'package:chat_app/widgets/buttons/Button.dart';
import 'package:chat_app/widgets/dialogs/alert_dialog.dart';
import 'package:chat_app/widgets/textinput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfileScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const CompleteProfileScreen(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    void cropImage(XFile pickFile) async {
      CroppedFile? file = await ImageCropper().cropImage(
        sourcePath: pickFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 20,
      );

      if (file != null) {
        setState(() {
          imageFile = File(file.path);
        });
      }
    }

    void selectImage(ImageSource imageSource) async {
      XFile? pickFile = await ImagePicker().pickImage(source: imageSource);
      if (pickFile != null) {
        cropImage(pickFile);
      }
    }

    void showPhotoOptions() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Upload Profile Picture"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.gallery);
                  },
                  leading: Icon(Icons.photo_album),
                  title: Text("Select from Gallery"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.camera);
                  },
                  leading: Icon(Icons.camera_alt),
                  title: Text("Select from Camera"),
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Complete Profile"),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: CupertinoButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  showPhotoOptions();
                },
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage:
                      (imageFile != null) ? FileImage(imageFile!) : null,
                  child: (imageFile == null)
                      ? const Icon(
                          Icons.person,
                          size: 100,
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: BlocConsumer<SignUpCubit, SignUpStates>(
                  listener: (context, state) {
                    if (state is UserImageNullState) {
                      showImageNullDialog();
                    }
                    if(state is SignUpErrorState){
                      showCupertinoDialog(context: context, builder: (context) {
                        return AppDialog(title: "Firebase Exception",content: state.exception.message.toString(),);
                      },);
                    }
                    if (state is SignUpCompleteState) {
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const HomeScreen(),
                          ));
                    }
                  },
                  builder: (context, state) {
                    if (state is FullNameNotValidState) {
                      return Text(state.message,
                          style: TextStyle(color: Colors.red));
                    }
                    if(state is SignUpLoadingState){
                      return Center(child: CircularProgressIndicator(),);
                    }
                    return Container();
                  },
                )),
            TextInputField(
              onChanged: (value) {},
              icon: Icons.person,
              controller: _fullNameController,
              placeholder: "Full Name",
            ),
            const SizedBox(
              height: 20,
            ),
            Button(
                onPressed: () {
                  BlocProvider.of<SignUpCubit>(context).completeSignUpProcess(
                      _fullNameController.text.trim(),
                      imageFile,
                      widget.userModel!);

                  // Navigator.popUntil(context, (route) => route.isFirst);
                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => const HomeScreen(),
                  //     ));
                },
                title: "Signup")
          ],
        ),
      ),
    );
  }

  void showImageNullDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => const AppDialog(
          title: "Umer",
          content: "Please choose your image first!",
          isCancelButton: false),
    );
  }
}
