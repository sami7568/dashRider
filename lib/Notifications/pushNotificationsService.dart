import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dashdriver/Models/rideDetails.dart';
import 'package:dashdriver/Notifications/notificationDialog.dart';
import 'package:dashdriver/configMaps.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io' show Platform;
import '../main.dart';

class PushNotificationsService{
 final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
 Future initialize(context) async {
   // workaround for onLaunch: When the app is completely closed (not in the background) and opened directly from the push notification
   firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
     print("new requesst");
     if (message != null){
       retrieveRideRequestInfo(getRideRequestId(message.data), context);
   }
   });

   // onMessage: When the app is open and it receives a push notification
   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
     if (message != null) {
       retrieveRideRequestInfo(getRideRequestId(message.data), context);
     }
   });

   // replacement for onResume: When the app is in the background and opened directly from the push notification.
   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
     if (message != null) {
       retrieveRideRequestInfo(getRideRequestId(message.data), context);
     }
   });
 }

 getToken() async
  {
    String? token =await firebaseMessaging.getToken();
    print('this is token');
    print(token);
    driversRef.child(currentfirebaseUSer!.uid).child("token").set(token);
    firebaseMessaging.subscribeToTopic("alldrivers");
    firebaseMessaging.subscribeToTopic("allusers");
  }

   String getRideRequestId(Map<String, dynamic> message){
    String rideRequestId="";
    print("getting ride resquest id");
    if (Platform.isAndroid) {
      print('this is rider request id');
      rideRequestId = message['ride_request_id'];
      print(rideRequestId.toString());
    }
    else{
     print('this is rider request id');
      rideRequestId = message['ride_request_id'];
      print(rideRequestId);
    }
    return rideRequestId;
  }

   void retrieveRideRequestInfo(String ride_request_id, BuildContext context){
   print("retrieving ride request Information");
   print(ride_request_id);
    newRequestsRef.child(ride_request_id).once().then((DatabaseEvent dataSnapshot){
      if(dataSnapshot.snapshot.value!=null){
        print("alert for riding: assign to a rider ");
        assetAudioPlayer.open(Audio("sounds/alert.mp3"));
        assetAudioPlayer.play();
        final routeArgs = dataSnapshot.snapshot.value as Map;
        double pickupLocationLat= double.parse(routeArgs['pickUp']['latitude'].toString());
        double pickupLocationLng= double.parse(routeArgs['pickUp']['longitude'].toString());
        String pickUpAddress= routeArgs['pick_Up_Address'].toString();
        print("recieved pickup from ridrequest ");
        double dropoffLocationLat = double.parse(routeArgs['dropOff']['latitude'].toString());
        double dropoffLocationLng = double.parse(routeArgs['dropOff']['longitude'].toString());
        String dropOffAddress = routeArgs['drop_Off_Location'].toString();
        String rider_name = routeArgs["rider_name"];
        String rider_phone = routeArgs["rider_phone"];

        RideDetails rideDetails=RideDetails();
        rideDetails.rideRequestId=ride_request_id;
        rideDetails.pickup_address=pickUpAddress;
        rideDetails.dropoff_address=dropOffAddress;
        rideDetails.pickup = LatLng(pickupLocationLat,pickupLocationLng);
        rideDetails.dropoff = LatLng(dropoffLocationLat,dropoffLocationLng);
        rideDetails.rider_name= rider_name;
        rideDetails.rider_phone=  rider_phone;

        print('information::');
        print(rideDetails.pickup_address);
        print(rideDetails.dropoff_address);
        
        showDialog(
        context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => NotificationDialog(rideDetails:rideDetails),
        );
      }
      else{
        print('no data recieve');
      }
    });
  }
}
