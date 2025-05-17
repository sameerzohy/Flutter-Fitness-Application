import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String hintText;
  final bool isObscureText;
  final TextEditingController controller;
  const AuthTextField({
    super.key,
    required this.hintText,
    this.isObscureText = false,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Color.fromRGBO(182, 180, 194, 0.5),
        prefixIcon:
            hintText == 'Full Name'
                ? Icon(Icons.person, color: Colors.white)
                : hintText == 'Email'
                ? Icon(Icons.email_outlined, color: Colors.white)
                : Icon(Icons.lock, color: Colors.white),
        contentPadding: EdgeInsets.symmetric(vertical: 15),
        hintText: hintText,
      ),
      style: TextStyle(fontSize: 20),
      validator: (value) {
        if (value == null || value.isEmpty) return '$hintText is not entered';
        return null;
      },
      obscureText: isObscureText,
      controller: controller,
      autocorrect: false,
    );
  }
}
