// @dart=2.9
import 'package:dashdriver/AllScreen/loginScreen.dart';
import 'package:dashdriver/AllScreen/mainScreen.dart';
import 'package:dashdriver/AllScreen/notapprove.dart';
import 'package:dashdriver/AllScreen/registrationScreen.dart';
import 'package:dashdriver/configMaps.dart';
import 'package:dashdriver/dataHandler/appData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dashdriver/Notifications/pushNotificationsService.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  currentfirebaseUSer =FirebaseAuth.instance.currentUser;
  runApp(MyApp());
}

DatabaseReference usersRef = FirebaseDatabase.instance.reference().child("users");
DatabaseReference driversRef = FirebaseDatabase.instance.reference().child("drivers");
DatabaseReference newRequestsRef = FirebaseDatabase.instance.reference().child("rideRequest");
DatabaseReference rideRequestRef = FirebaseDatabase.instance.reference().child("drivers").child(currentfirebaseUSer.uid).child("newRide");

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=>AppData(),
      child: MaterialApp(
        title: 'Uber Driver',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: FirebaseAuth.instance.currentUser==null? LoginScreen.idScreen : NotApproved.idScreen,
        routes: {
          RegistrationScreen.idScreen: (context) => const RegistrationScreen(),
          LoginScreen.idScreen: (context) => LoginScreen(),
          MainScreen.idScreen :(context) => MainScreen(),
          NotApproved.idScreen:(context) => NotApproved(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}



