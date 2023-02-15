import 'package:flutter/material.dart';

class TextInputField extends StatefulWidget {
  const TextInputField(
      {super.key,
      this.obscureText = false,
      this.placeholder = "",
      this.expands = false,
      this.icon,
      required this.onChanged,
      required this.controller,
      this.keyboardType = TextInputType.name});

  final bool obscureText;
  final String placeholder;
  final bool expands;
  final IconData? icon;
  final Function onChanged;
  final TextEditingController controller;
  final TextInputType keyboardType;

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        expands: widget.expands,
        obscureText: widget.obscureText,
        onChanged: (value) {
          widget.onChanged(value);
        },
        decoration: InputDecoration(
          alignLabelWithHint: true,
          prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
          prefixIconColor: Colors.blue,
          contentPadding: const EdgeInsets.all(10),
          border: const OutlineInputBorder(),
          labelText: widget.placeholder,
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
}
