import 'package:flutter/material.dart';

class ProfileListTile extends StatelessWidget {
  
  final IconData icon;
  final String title;
  final dynamic onTap;

  ProfileListTile ({required this.icon, required this.title, required this.onTap, });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: ListTile(
                    leading: Icon(
                    icon,color: Colors.black, size: 26,),
                    title: Text(title,style: TextStyle(color: Colors.black54),),
                    onTap: onTap,
                    trailing: Container(
                      width: 30 , height: 30,
                      child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.black,),
                    ),
                  ),
      )
    ;
  }
}