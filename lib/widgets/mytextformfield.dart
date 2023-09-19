import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final dynamic validator;
  final TextEditingController controller;
  final String name;
  final dynamic prefixIcon;
  final dynamic onSaved;
 

  MyTextFormField ({required this.controller, required this.name, required this.prefixIcon, required this.validator, required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onSaved: onSaved,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
       hintText: name,
          hintStyle: TextStyle(
          color: Colors.grey[700],),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
       ),
     );
  }
}