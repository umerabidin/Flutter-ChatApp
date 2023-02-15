import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  const Button({Key? key, required this.onPressed, required this.title})
      : super(key: key);
  final Function()? onPressed;
  final String title;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: Size(
              double.infinity,
              40,
            )),
            onPressed: widget.onPressed,
            child: Text(widget.title))
        : CupertinoButton(
            pressedOpacity: 0.8,
            color: Theme.of(context).colorScheme.secondary,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
            onPressed: widget.onPressed,
            child: Text(widget.title));
  }
}
