// @dart=2.9
import 'package:dashdriver/AllScreen/loginScreen.dart';
import 'package:dashdriver/AllScreen/mainScreen.dart';
import 'package:dashdriver/AllScreen/newRideScreen.dart';
import 'package:dashdriver/AllScreen/notapprove.dart';
import 'package:dashdriver/AllScreen/registrationScreen.dart';
import 'package:dashdriver/configMaps.dart';
import 'package:dashdriver/dataHandler/appData.dart';
import 'package:dashdriver/tabPages/homeTabPage.dart';
import 'package:dashdriver/tabPages/profileTabPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dashdriver/Notifications/pushNotificationsService.dart';

import 'Notifications/notificationDialog.dart';


// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print('Handling a background message ${message.messageId}');
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging fcm = FirebaseMessaging.instance;
  currentfirebaseUSer =FirebaseAuth.instance.currentUser;
  runApp(MyApp());
}

DatabaseReference usersRef = FirebaseDatabase.instance.reference().child("users");
DatabaseReference driversRef = FirebaseDatabase.instance.reference().child("drivers");
DatabaseReference newRequestsRef = FirebaseDatabase.instance.reference().child("rideRequest");
DatabaseReference rideRequestRef = FirebaseDatabase.instance.reference().child("drivers").child(currentfirebaseUSer.uid).child("newRide");

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  @override
  void initState() {
    FirebaseMessaging.instance.getInitialMessage().then((message) {if(message!=null){
        final routeFromMessage= message.data;
        print(routeFromMessage);
        PushNotificationsService().initialize(context);
        /*Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileTabPage(),
          ),
        );*/
      }});
    //foreground message
    FirebaseMessaging.onMessage.listen((message) {
      if(message.notification!=null){
        print(message.notification.body);
        print(message.notification.title);
        PushNotificationsService().initialize(context);

      }
        else{
          print("null message");
      }
     // LocalNotificationService.display(message);
    });
    //only works when the app is in the background and open
    //when user tap on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if(message.data!=null){
        final routeFromMesssage = message.data;
       /* Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileTabPage(),
          ),
        );*/

       PushNotificationsService().initialize(context);

        print(routeFromMesssage);
      }
    });
    super.initState();
  } // This widget is the root of your application.
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





