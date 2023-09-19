import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {

  final VoidCallback onPressed;
  final String name;
  MyButton ({required this.name, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black,
                        child: MaterialButton(
                        minWidth: 200,
                          onPressed : onPressed,
                        child: Text(
                          name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,  color: Colors.white),
                        ),
                      ),
                    );
  }
}