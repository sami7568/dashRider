import 'package:dashdriver/AllScreen/mainScreen.dart';
import 'package:dashdriver/AllScreen/registrationScreen.dart';
import 'package:dashdriver/AllWidgets/progressDialog.dart';
import 'package:dashdriver/configMaps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
class LoginScreen extends StatelessWidget {
  static const String idScreen = "login";

  TextEditingController emailTextEditingController= TextEditingController();
  TextEditingController passwordTextEditingController= TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 130.0,),
             const Center(child:Text(
                "D",
                style: TextStyle(fontSize: 130,fontFamily: "Brand Bolt",color:Color(0xff00ACA4),fontWeight: FontWeight.bold,),
              )),
             const Padding(
               padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
               child:Text(
                "Welcome back!",
                style: TextStyle(fontSize: 32,fontFamily: "Brand Bolt",color:Colors.black,fontWeight: FontWeight.bold),
              )),
              const SizedBox(height: 15,),
              const Padding(
                padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
                child:Text(
                "Please login to Your Account!",
                style: TextStyle(fontSize: 18,fontFamily: "Brand Bolt"),
              )),
              Padding(padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 15.0,),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                        fillColor: Color(0xff00ACA4),
                        hintText: "Email Address",
                        hintStyle: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    const  SizedBox(height: 15.0,),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        fillColor: Colors.black,
                        hintText: "Password",
                        hintStyle: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    const  SizedBox(height: 24.0,),
                    RaisedButton(
                      color: Color(0xff00ACA4),
                      textColor: Colors.white,
                      child: SizedBox(
                        height: 50.0,
                        child: const Center(
                          child:Text(
                            "Login",
                            style:  TextStyle(fontFamily: "Brand Bolt", fontSize: 18.0),
                          ),
                        ),
                      ),

                      onPressed: (){
                        if(!emailTextEditingController.text.contains("@")){
                          displayToastMessage("Email address is not correct", context);
                        }
                        else if(passwordTextEditingController.text.isEmpty){
                          displayToastMessage("please provide password", context);
                        }
                        else {
                          loginAndAuthenticateUser(context);
                        }
                      },
                    )
                  ],
                ),
              ),
              SizedBox(height: 30,),
              FlatButton(
                onPressed: ()
                {
                  Navigator.pushNamedAndRemoveUntil(context, RegistrationScreen.idScreen, (route) => false);
                },
                child: const Center(child:Text(
                  "Register here",
                  style:TextStyle(color:Colors.black,fontSize: 20),
                )),
              )
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  void loginAndAuthenticateUser(BuildContext context)async
  {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return ProgressDialog(message: "Authenticating Please Wait",);
      }
    );
    final  User? firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text).catchError((errMsg){
          Navigator.pop(context);
          displayToastMessage("Error :"+ errMsg.toString(), context);
    })).user;

    if(firebaseUser !=null){
      driversRef.child(firebaseUser.uid).once().then((DatabaseEvent snap){
      if(snap.snapshot.value!=null) {
        currentfirebaseUSer=firebaseUser;
        Navigator.pushNamedAndRemoveUntil(
            context, MainScreen.idScreen, (route) => false);
        displayToastMessage("your are logged in", context);}
      else{
        Navigator.pop(context);
        _firebaseAuth.signOut();
        displayToastMessage("you don't have an account", context);
      }
      });
    }
    else
    {
      Navigator.pop(context);
      displayToastMessage("no account for this record! please register first", context);
    }
  }
}
