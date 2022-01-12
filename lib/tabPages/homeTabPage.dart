import 'dart:async';
import 'package:dashdriver/AllScreen/loginScreen.dart';
import 'package:dashdriver/AllScreen/registrationScreen.dart';
import 'package:dashdriver/Models/drivers.dart';
import 'package:dashdriver/Notifications/pushNotificationsService.dart';
import 'package:dashdriver/assistant/assistantMethods.dart';
import 'package:dashdriver/configMaps.dart';
import 'package:dashdriver/main.dart';
import 'package:dashdriver/tabPages/earningTabPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class HomeTabPage extends StatefulWidget {
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(34.015137, 71.524918),
    zoom: 14.4746,
  );

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;
  bool isDriverAvailable = false;
  bool switchStatus = false;

  void locatePosition() async {
    print("this is going to search current position");

    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("error");
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position =  await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    currentPosition=position;
    print("position : ");
   // print(position);

    LatLng latlngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latlngPosition, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  void initState() {
    super.initState();
    getCurrentDriverInfo();
    locatePosition();
    print("initstate called");
  }

  void getCurrentDriverInfo() async {
    currentfirebaseUSer = await FirebaseAuth.instance.currentUser;
    driversRef
        .child(currentfirebaseUSer!.uid)
        .once()
        .then((DatabaseEvent dataSnapshot) {
      if (dataSnapshot.snapshot.value != null) {
        driversInformation = Drivers.fromSnapshot(dataSnapshot);
        print("driversINfo::");
        print(driversInformation!.name);
      }
    });

    PushNotificationsService pushNotificationService =
        PushNotificationsService();
   // pushNotificationService.initialize(context);
    pushNotificationService.getToken();
    AssistantMethods.retrieveHistoryInfo(context);
    getRatings();
    getRideType();
  }

  @override
  void deactivate() {
    super.deactivate();
    print("deactivate");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
             title: Center(child: Text('Driver App')),
      ),
      drawer: Drawer(

        child: ListView(
          children: [
            Container(
              height: 155.0,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Row(
                  children: [
                    Image.asset(
                      "images/user_icon.png",
                      height: 65.0,
                      width: 65.0,
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height:40),
                        Text(
                        (currentfirebaseUSer!.displayName!=null)?currentfirebaseUSer!.displayName!.toUpperCase():"USER",
                          style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: "Brand Bolt",
                              color: Colors.black87),
                          textAlign: TextAlign.start,
                        ),
                        Row(
                         children: [
                           Text(driverStatusText,style:TextStyle(fontSize:18.0,color:driverStatusColor)),
                           SizedBox(width:50.0),
                           FlutterSwitch(
                               width: 63.0,
                               height: 30.0,
                               valueFontSize: 15.0,
                               toggleSize: 25.0,
                               value: switchStatus,
                               borderRadius: 30.0,
                               padding: 8.0,
                               showOnOff: true,
                               activeColor: Colors.green,
                               onToggle: (val) {
                                 setState(() {
                                   switchStatus = val;
                                   if (isDriverAvailable != true) {
                                     setState(() {
                                       driverStatusColor = Colors.white;
                                       driverStatusText = "Online";
                                       isDriverAvailable = true;
                                     });
                                     makeDriverOnlineNow();
                                     displayToastMessage("you are online now", context);
                                     getLocationLiveUpdates();
                                   }
                                   else {
                                     setState(() {
                                       driverStatusColor = Colors.black;
                                       driverStatusText = "Offline";
                                       isDriverAvailable = false;
                                     });
                                     makeDriverOfflineNow();
                                     displayToastMessage("your are offline now", context);
                                   }

                                 });}
                           )
                         ], 
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.0),
            // drawer body controller
            ListTile(
              leading: Icon(Icons.inbox),
              title: Text(
                "Inbox",
                style: TextStyle(fontSize: 15.0),
              ),
            ),
            ListTile(
              leading: Icon(Icons.format_list_numbered),
              title: Text(
                "Number Plate",
                style: TextStyle(fontSize: 15.0),
              ),
            ),
            GestureDetector(
              onTap:(){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>EarningTabPage(),));
              },
              child:  ListTile(
                leading: Icon(Icons.attach_money_sharp),
                title: Text(
                  "Earnings",
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.drive_eta_rounded),
              title: Text(
                "Driver Refers",
                style: TextStyle(fontSize: 15.0),
              ),
            ),
            ListTile(
              leading: Icon(Icons.help_sharp),
              title: Text(
                "Help",
                style: TextStyle(fontSize: 15.0),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person_pin),
              title: Text(
                "Profile",
                style: TextStyle(fontSize: 15.0),
              ),
            ),
            GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, LoginScreen.idScreen, (route) => false);
                makeDriverOfflineNow();
              },
              child: ListTile(
                leading: Icon(Icons.close),
                title: Text(
                  "Log Out",
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
            ),
          ],
        ),
      ),

      body: Stack(
        children: [
          GoogleMap(
            // googlemap
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: HomeTabPage._kGooglePlex,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            compassEnabled: true,
            mapToolbarEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              locatePosition();
            },
          ),
         /* Container(
            height: 40.0,
            width: double.infinity,
          *//*  color: Colors.blue,*//*
          ),*/
/*          Positioned(
            top: 20,
            left: 0.0,
            right: 0.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.blue),
                              ),
                          ),

                      ),
                    onPressed: () {
                      if (isDriverAvailable != true) {
                        setState(() {
                          driverStatusColor = Colors.blue;
                          driverStatusText = "Online";
                          isDriverAvailable = true;
                        });
                        makeDriverOnlineNow();
                        displayToastMessage("you are online now", context);
                        getLocationLiveUpdates();
                      }
                      else {
                        setState(() {
                          driverStatusColor = Colors.black;
                          driverStatusText = "Offline";
                          isDriverAvailable = false;
                        });
                        makeDriverOfflineNow();
                        displayToastMessage("your are offline now", context);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            driverStatusText,
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          SizedBox(width:10),
                          Icon(
                            Icons.phone_android,
                            color: Colors.blue,
                            size: 28,
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),*/
        ],
      ),
    );
  }

  void makeDriverOnlineNow() async {

    print("you pressed online");
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    print('current position');
    print(currentPosition);
    Geofire.initialize("availableDrivers");
    Geofire.setLocation(currentfirebaseUSer!.uid, currentPosition!.latitude,
        currentPosition!.longitude);
   print("current firebase user id");
    print(currentfirebaseUSer!.uid);
    rideRequestRef.set("searching");
    rideRequestRef.onValue.listen((event) {});
  }

  void getLocationLiveUpdates() {
    homeTabPageStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      if (isDriverAvailable == true) {
        Geofire.setLocation(
            currentfirebaseUSer!.uid, position.latitude, position.longitude);
      }
      LatLng latLng = LatLng(position.latitude, position.longitude);
      newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  void makeDriverOfflineNow() {
    Geofire.removeLocation(currentfirebaseUSer!.uid);
    DatabaseReference rideRequestRef = FirebaseDatabase.instance.reference().child("drivers").child(currentfirebaseUSer!.uid).child("newRide");
    rideRequestRef.onDisconnect();
    rideRequestRef.remove();
    rideRequestRef = null!;
    displayToastMessage("you are offline now", context);
  }

  getRideType() {
    driversRef
        .child(currentfirebaseUSer!.uid)
        .child("car_details")
        .child("ride_type")
        .once()
        .then((DatabaseEvent snapshot) {
      if (snapshot.snapshot.value != null) {
        setState(() {
          rideType = snapshot.snapshot.value.toString();
        });
      }
    });
    print("ride type");
    print(rideType);
  }

  getRatings() {
    //update ratings
    driversRef
        .child(currentfirebaseUSer!.uid)
        .child("ratings")
        .once()
        .then((DatabaseEvent dataSnapshot) {
      if (dataSnapshot.snapshot.value != null) {
        double ratings = double.parse(dataSnapshot.snapshot.value.toString());
        setState(() {
          starCounter = ratings;
        });
        if(starCounter==0){

          setState(() {
            title="No Ratings Yet";
          });
          return;
        }
        if (starCounter <= 1.5) {
          setState(() {
            title = "Very Bad";
          });
          return;
        }
        if (starCounter <= 2.5) {
          setState(() {
            title = "Bad";
          });
          return;
        }
        if (starCounter <= 3.5) {
          setState(() {
            title = "Good";
          });
          return;
        }
        if (starCounter <= 4.5) {
          setState(() {
            title = "Very Good";
          });
          return;
        }
        if (starCounter <= 5) {
          setState(() {
            title = "Excellent";
          });
          return;
        }
      }
    });
  }
}