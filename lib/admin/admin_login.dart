import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../api_connection/api_connection.dart';
import '../users/model/user.dart';
import '../widgets/mybutton.dart';
import '../widgets/mytextformfield.dart';
import '../widgets/passwordtextformfield.dart';
import 'admin_dashboard.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}
class _AdminLoginScreenState extends State<AdminLoginScreen> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obserText=true;

  loginAdminNow() async
  {
    try
    {
      var res = await http.post(
        Uri.parse(API.adminLogin),
        body: {
          "admin_email": emailController.text.trim(),
          "admin_password": passwordController.text.trim(),
        },
      );

      if(res.statusCode == 200) //from flutter app the connection with api to server - success
      {
        var resBodyOfLogin = jsonDecode(res.body);
        if(resBodyOfLogin['success'] == true)
        {
          Fluttertoast.showToast(msg: "Dear Admin, you are logged-in Successfully.");

          Future.delayed(const Duration(milliseconds: 2000), ()
          {
            Get.to(() =>AdminDashboard());
          });
        }
        else
        {
          Fluttertoast.showToast(msg: "Incorrect Credentials.\nPlease write correct password or email and Try Again.");
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    }
    catch(errorMsg)
    {
      print("Error :: " + errorMsg.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
          ],
        ),
        height: 70,
        width: double.infinity,
        decoration:BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(topLeft: Radius.elliptical(400, 80), topRight: Radius.elliptical(400, 80)),
        ),
      ),           
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.only(left: 40, right: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SizedBox(height: 60,),
                Text("Welcome", style: TextStyle(fontSize: 18,),),
                Text("Back again fam's", style: TextStyle(fontSize: 32,),),
                SizedBox(height: 35,),
                Text("Admin", style: TextStyle(fontSize: 32,),),
                SizedBox(height: 20,),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                  ),
                  child: Column(
                    children: <Widget>[
                      
      
                    //Email
                    MyTextFormField(
                      controller: emailController, 
                      name: "Email admin", 
                      prefixIcon: Icon(Icons.email_rounded), 
                      validator: (value) {
                            if (value!.isEmpty) {
                              return ("Please Enter Your Email Admin");
                            }
                            // reg expression for email validation
                            if (!RegExp("^[a-zA-z0-9+_.-]+@[[a-zA-z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return ("Please Enter a valid email");
                            }
                            return null;
                          },
                          onSaved: (value) {
                          emailController.text = value!;
                          },
                        ),
                      
                        SizedBox(height: 10),
      
                      // Password
                      PasswordTextFormField(
                        controller: passwordController, 
                        name: "Password",
                        prefixIcon: Icon(Icons.lock_rounded),
                        obserText: obserText, 
                        onTap: () {
                            setState(() {
                              obserText =!obserText;
                            });
                        } ,
                        validator: (value) {
                            RegExp regex = RegExp(r'^.{6,}$');
                            if (value!.isEmpty) {
                              return ("Password is required for login");
                            }
                            if (!regex.hasMatch(value)) {
                              return ("Enter Valid Password(Min. 6 Character)");
                            }
                            return null;
                          },
                          onSaved: (value) {
                            passwordController.text = value!;
                          },
                        ),
                        SizedBox(height: 30,),

                        MyButton(
                          name: "Login", 
                          onPressed: () {
                            if(_formKey.currentState!.validate()) {
                              loginAdminNow();
                            }
                          }
                          ),
                          SizedBox(height: 10,),
                         
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}