import 'package:dashdriver/AllScreen/loginScreen.dart';
import 'package:dashdriver/AllWidgets/progressDialog.dart';
import 'package:dashdriver/configMaps.dart';
import 'package:dashdriver/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'carInfoScreen.dart';

class RegistrationScreen extends StatelessWidget {
  static const String idScreen = "registration";

  TextEditingController nameTextEditingController= TextEditingController();
  TextEditingController emailTextEditingController= TextEditingController();
  TextEditingController passwordTextEditingController= TextEditingController();
  TextEditingController phoneTextEditingController= TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 85.0,),
              Text("SHARIFY",style:TextStyle(color: Colors.white,fontFamily: "Brand Bolt",fontSize: 35,)),
              SizedBox(
                height:15.0,
              ),
              Text(
                "Register as Driver",
                style: TextStyle(fontSize: 24,fontFamily: "Brand Bolt",color:Colors.white),
              ),
              SizedBox(height:10.0),
              Padding(padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10.0,),
                    TextField(
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.name,
                      obscureText: true,
                      decoration: InputDecoration(
                        fillColor: Color(0x225C0D0D),
                        labelText:"Name",
                        hintText: "e.g: john cena",
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
                    SizedBox(height: 10.0,),
                    TextField(
                      controller: emailTextEditingController,
                      obscureText: true,
                      keyboardType:TextInputType.emailAddress,
                      decoration: InputDecoration(
                        fillColor: Color(0x225C0D0D),
                        labelText:"Email",
                        hintText: "e.g: john@gmail.com",
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
                    SizedBox(height: 10.0,),
                    TextField(
                      controller: phoneTextEditingController,
                      obscureText: true,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        fillColor: Color(0x225C0D0D),
                        labelText:"Phone",
                        hintText: "0920302304949",
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
                    SizedBox(height: 10.0,),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        fillColor: Color(0x225C0D0D),
                        labelText:"Password",
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
                            "Create Account",
                            style:  TextStyle(fontFamily: "Brand Bolt", fontSize: 18.0),
                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24),
                      ),
                      onPressed: (){
                        if(nameTextEditingController.text.length<=3){
                          displayToastMessage("name must be at least 3 characters", context);
                        }
                        else if(!emailTextEditingController.text.contains("@")){

                          displayToastMessage("Email address is not correct", context);
                        }
                        else if(phoneTextEditingController.text.isEmpty){
                          displayToastMessage("Phone Number is mandatory", context);
                        }
                        else if(passwordTextEditingController.text.length<6){
                          displayToastMessage("Password is too short must be at least 6 characters", context);
                        }
                        else{
                          registerNewUser(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
              FlatButton(
                onPressed: ()
                {
                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                },
                child: Text(
                    "Already have an account? Login here",
                  style:TextStyle(color: Colors.white)
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  void registerNewUser(BuildContext context)async {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return ProgressDialog(message: "Registering Please Wait",);
        }
    );

    final  User? firebaseUser = (await _firebaseAuth
        .createUserWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text).catchError((errMsg){
      Navigator.pop(context);
          displayToastMessage("Error :"+ errMsg.toString(), context);
    })).user;

    if(firebaseUser !=null){
      Map userDataMap= {
        "name":nameTextEditingController.text.trim(),
        "email":emailTextEditingController.text.trim(),
        "phone":phoneTextEditingController.text.trim(),
        "password":passwordTextEditingController.text.trim(),
      };

      currentfirebaseUSer = firebaseUser;
      driversRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMessage("Congratulations your account is created", context);
     Navigator.pushNamed(context, CarInfoScreen.idScreen);
    }
    else
      {
        Navigator.pop(context);
        displayToastMessage("New User Account has not been created", context);
      }
  }
}

displayToastMessage(String message,BuildContext context){
  Fluttertoast.showToast(msg: message);
}
