import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final Size size;
  final String labelText;
  final IconData icon;
  final bool obscureText;
  final TextEditingController controller;
  final TextInputType type;
  final FocusNode focus;
  final Function()? editing;
  final TextInputAction? action;
  const CustomInput(
      {Key? key,
      required this.size,
      required this.labelText,
      required this.icon,
      required this.obscureText,
      required this.controller,
      required this.type,
      required this.focus,
      this.editing,
      this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width - 50,
      child: TextField(
        autocorrect: false,
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2.5, color: Colors.white),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2.5, color: Colors.white),
            borderRadius: BorderRadius.circular(20),
          ),
          label: Text(
            labelText,
            style: const TextStyle(color: Colors.white),
          ),
          icon: Icon(
            icon,
            color: Colors.white,
            size: 50,
          ),
        ),
        keyboardType: type,
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white),
        obscureText: obscureText,
        focusNode: focus,
        onEditingComplete: editing,
        textInputAction: action,
      ),
    );
  }

  void requestFocus(BuildContext context, FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }
}
