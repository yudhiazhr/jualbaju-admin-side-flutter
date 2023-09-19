import 'package:flutter/material.dart';

class PasswordTextFormField extends StatelessWidget {
  final bool obserText;
  final String name;
  final dynamic validator;
  final dynamic prefixIcon;
  final VoidCallback onTap;
  final TextEditingController controller;
  final dynamic onSaved;
 

  PasswordTextFormField({
    required this.controller,
    required this.onTap,
    required this.onSaved,
    required this.name,
    required this.obserText, 
    required this.validator, 
    this.prefixIcon
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onSaved: onSaved,
      obscureText: obserText,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        hintText: name, 
        suffixIcon: GestureDetector(
          onTap: onTap,
          child: Icon(
            obserText == true ? Icons.visibility : Icons.visibility_off,
            color: Colors.black,
          ),
        ),
        hintStyle: TextStyle(color: Colors.grey[700],),
      ),  
    );
  }
}