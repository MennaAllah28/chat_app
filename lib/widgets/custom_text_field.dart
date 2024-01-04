import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField(
      {this.obscureText = false, this.onChanged, this.hintText});
  bool? obscureText;
  String? hintText;
  Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText!,
      validator: (data) {
        if (data!.isEmpty) {
          return 'field is required ';
        }
      },
      onChanged: onChanged,
      decoration: InputDecoration(
          hintText: hintText,
          helperStyle: TextStyle(
            color: Colors.white,
          ),
          // مش ضاغط عليه
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          border: OutlineInputBorder(
              //العام

              borderSide: BorderSide(color: Colors.white))),
    );
  }
}
