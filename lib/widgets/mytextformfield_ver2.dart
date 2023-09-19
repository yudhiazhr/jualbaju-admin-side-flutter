import 'package:flutter/material.dart';

class MyTextFormFieldVer2 extends StatelessWidget {
  final dynamic validator;
  final TextEditingController controller;
  final String name;
  final dynamic prefixIcon;
  final dynamic onSaved;
 

  MyTextFormFieldVer2 ({required this.controller, required this.name, required this.prefixIcon, required this.validator, required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: 1, 
      keyboardType: TextInputType.multiline,
      maxLines: null,
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