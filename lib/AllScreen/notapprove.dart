import 'package:dashdriver/AllScreen/registrationScreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../configMaps.dart';
import 'mainScreen.dart';
class NotApproved extends StatefulWidget {
  static const String idScreen = "notapprove";
  @override
  _NotApprovedState createState() => _NotApprovedState();
}

class _NotApprovedState extends State<NotApproved> {

  @override
  Widget build(BuildContext context) {
    checkfirebase();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const[
          Center(child:Text("D",style:TextStyle(color: Color(0xff00ACA4),fontFamily: "Brand Bolt",fontSize: 120,fontWeight: FontWeight.bold))),
          Text("Your Account is Not Approved",style:TextStyle(color: Colors.black,fontFamily: "Brand Bolt",fontSize: 18,fontWeight: FontWeight.bold)),
          Text("Please Wait",style:TextStyle(color: Colors.black,fontFamily: "Brand Bolt",fontSize: 18,)),
        ],
      ),
    );
  }

  checkfirebase()async{
    DatabaseReference driversRef = FirebaseDatabase.instance.reference().child("drivers");
    Future<SharedPreferences> _sharedPreferences = SharedPreferences.getInstance();
    driversRef.child(currentfirebaseUSer!.uid).child("approve").once().then((event) {
      if(event!=null) {
         checkstatus = event.snapshot.value.toString();
          print(checkstatus.toString());{
            if (checkstatus=="true") {

                Navigator.pushNamedAndRemoveUntil(
               context, MainScreen.idScreen, (route) => false);
             //displayToastMessage("your are logged in", context);
            }
        }
}
    });
  }
  }
  String? checkstatus="";