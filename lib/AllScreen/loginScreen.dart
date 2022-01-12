import 'package:dashdriver/AllScreen/mainScreen.dart';
import 'package:dashdriver/AllScreen/registrationScreen.dart';
import 'package:dashdriver/AllWidgets/progressDialog.dart';
import 'package:dashdriver/configMaps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../main.dart';
class LoginScreen extends StatelessWidget {
  static const String idScreen = "login";

  TextEditingController emailTextEditingController= TextEditingController();
  TextEditingController passwordTextEditingController= TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 130.0,),
              /*Image(
                image: AssetImage('images/taxi.png'),
                width: 390.0,
                height: 250.0,
                alignment: Alignment.center,
              ),*/
              Text(
                "SHARIFY",
                style: TextStyle(fontSize: 35,fontFamily: "Brand Bolt",color:Colors.white),
              ),
              SizedBox(
                height:20.0,
              ),
              Text(
                "Login as Driver",
                style: TextStyle(fontSize: 24,fontFamily: "Brand Bolt",color:Colors.white),
              ),
              Padding(padding: EdgeInsets.all(25.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 15.0,),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        fillColor: Color(0x225C0D0D),
                        labelText:"Email",
                        hintText: "e.g: Albert John",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(23.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white,width: 2.0),
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        labelStyle: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white
                        ),
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 10.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 15.0,),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        fillColor: Color(0x225C0D0D),
                        labelText:"password",
                        hintText: "e.g: ******",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(23.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white,width: 2.0),
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        labelStyle: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white
                        ),
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 10.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.0,),
                    RaisedButton(
                      color: Color(0x9a095ed7),
                      textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Login",
                            style:  TextStyle(fontFamily: "Brand Bolt", fontSize: 18.0),
                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24),
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
              FlatButton(
                onPressed: ()
                {
                  Navigator.pushNamedAndRemoveUntil(context, RegistrationScreen.idScreen, (route) => false);
                },
                child: Text(
                  "Do not have account? Register here",
                  style:TextStyle(color:Colors.white,),
                ),
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
