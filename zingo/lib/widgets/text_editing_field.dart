import 'package:flutter/material.dart';

class TextEditingField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isRequired;
  final String validationText;
  final String value;
  final bool isPassword;
  final Function(String) onChanged;
  final Function(String) validator;

  TextEditingField(
      {Key key,
      this.hintText,
      this.controller,
      this.isRequired,
      this.validationText,
      this.value,
      this.isPassword,
      this.onChanged,
      this.validator})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextFormField(
        obscureText: isPassword ?? false,
        onChanged: onChanged,
        validator: validator ??
            (value) {
              if (isRequired) {
                if (value == "") return validationText;
              }
              return null;
            },
        initialValue: value,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white70,
          hintText: hintText,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 28.0, vertical: 18.0),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 18.0,
        ),
      ),
    );
  }
}
