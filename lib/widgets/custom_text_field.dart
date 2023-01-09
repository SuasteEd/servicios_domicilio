import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {
  final Size size;
  final String labelText;
  final IconData icon;
  final bool obscureText;
  final TextEditingController controller;
  final TextInputType type;
  const CustomInput(
      {Key? key,
      required this.size,
      required this.labelText,
      required this.icon,
      required this.obscureText,
      required this.controller,
      required this.type})
      : super(key: key);

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width - 50,
      child: TextField(
        autocorrect: false,
        controller: widget.controller,
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
            widget.labelText,
            style: const TextStyle(color: Colors.white),
          ),
          icon: Icon(
            widget.icon,
            color: Colors.white,
            size: 50,
          ),
        ),
        keyboardType: widget.type,
        cursorColor: Colors.white,
        obscureText: widget.obscureText,
      ),
    );
  }
}
