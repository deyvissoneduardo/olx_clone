import 'package:flutter/material.dart';

class TextFildCuston extends StatelessWidget {
  final TextEditingController controller;
  final bool obscure;
  final bool autofocus;
  final String hint;
  final TextInputType type;

  TextFildCuston({
    @required this.controller,
    @required this.hint,
    this.obscure = false,
    this.autofocus = false,
    this.type = TextInputType.text
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      child: TextField(
        controller: this.controller,
        obscureText: this.obscure,
        autofocus: this.autofocus,
        keyboardType: this.type,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: this.hint,
            filled: true,
            fillColor: Colors.white,
            hintStyle: TextStyle(fontSize: 20)),
      ),
    );
  }
}
