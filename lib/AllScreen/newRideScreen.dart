import 'dart:async';

import 'package:dashdriver/AllWidgets/collectFareDialog.dart';
import 'package:dashdriver/AllWidgets/progressDialog.dart';
import 'package:dashdriver/Models/rideDetails.dart';
import 'package:dashdriver/assistant/assistantMethods.dart';
import 'package:dashdriver/assistant/mapKitAssistant.dart';
import 'package:dashdriver/configMaps.dart';
import 'package:dashdriver/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NewRideScreen extends StatefulWidget {
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final RideDetails? rideDetails;
  NewRideScreen({this.rideDetails});
  @override
  _NewRideScreenState createState() => _NewRideScreenState();
}

class _NewRideScreenState extends State<NewRideScreen> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newRideGoogleMapController;

  Set<Marker> markersSet= Set<Marker>();
  Set<Circle> circleSet = Set<Circle>();
  Set<Polyline> polyLineSet = Set<Polyline>();
  List<LatLng> polylineCoordinates=[];
  PolylinePoints polylinePoints= PolylinePoints();
  double mapPaddingFromBottom=0;
  var geolocator= Geolocator();
  //var locationOptions= LocationOptions(accuracy: LocationAccuracy.bestForNavigation);
  late BitmapDescriptor animatingMarkerIcon;
  late Position myPosition;
  String status="accepted";
  String durationRide="";
  bool isRequestingDirection=false;
  String btn_title="Arrived";
  Color btn_color=Colors.blueAccent;
  late Timer timer;
  int durationCounter=0;

  @override
  void initState() {
    super.initState();
    acceptRideRequest();
  }

  void createIconMarker(){
    if(animatingMarkerIcon==null){
      ImageConfiguration imageConfiguration=createLocalImageConfiguration(context,size: Size(2,2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car-ios.png")
      .then((value)
      {
       animatingMarkerIcon=value;
      });
    }
  }

  void getRideLiveLocationUpdates(){
    LatLng oldPos=LatLng(0,0);
    rideStreamSubscription = Geolocator.getPositionStream().listen((Position position) {
      currentPosition=position;
      myPosition=position;
      LatLng mPosition=LatLng(position.latitude,position.longitude);

      var rot= MapKitAssistant.getMarkerRotation(oldPos.latitude, oldPos.longitude, myPosition.latitude, myPosition.longitude);
      Marker animatingMarker=Marker(
        markerId:MarkerId("animating"),
        position: mPosition,
        icon: animatingMarkerIcon,
        rotation: rot.toDouble(),
        infoWindow: InfoWindow(title: "current Location"),
      );
      setState(() {
        CameraPosition cameraPosition=new CameraPosition(target: mPosition,zoom: 17);
        newRideGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
        
        markersSet.removeWhere((marker) => marker.markerId.value=="animating");
        markersSet.add(animatingMarker);
      });
      oldPos= mPosition;
      updateRideDetails();

      String? rideRequestId=widget.rideDetails!.rideRequestId;

      Map LocMap=
      {
        "latitude" : currentPosition!.latitude.toString(),
        "longitude": currentPosition!.longitude.toString(),
      };
      newRequestsRef.child(rideRequestId!).child("driver_location").set(LocMap);
    });
  }


  @override
  Widget build(BuildContext context) {
    createIconMarker();

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapPaddingFromBottom),
            // googlemap
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: NewRideScreen._kGooglePlex,
            myLocationEnabled: true,
            markers: markersSet,
            circles: circleSet,
            polylines: polyLineSet,
             onMapCreated: (GoogleMapController controller) async {
              _controllerGoogleMap.complete(controller);
              newRideGoogleMapController = controller;

              setState(() {
                mapPaddingFromBottom=265.0;
              });
              var currentLatLng=LatLng(currentPosition!.latitude,currentPosition!.longitude);
              var pickUpLatLng=widget.rideDetails!.pickup;

             await getPlaceDirection(currentLatLng, pickUpLatLng!);
             getRideLiveLocationUpdates();
            },
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 16.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              height: 270.0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                child: Column(
                  children: [
                    Text(
                      durationRide,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "Brand Bolt",
                          color: Colors.deepPurple),
                    ),
                    SizedBox(
                      height: 6.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.rideDetails!.rider_name!,
                          style: TextStyle(
                              fontFamily: "Brand Bolt", fontSize: 24.0),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Icon(Icons.phone_android),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 26.0,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'images/pickicon.png',
                          height: 16.0,
                          width: 16.0,
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              widget.rideDetails!.pickup_address!,
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'images/desticon.png',
                          height: 16.0,
                          width: 16.0,
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              widget.rideDetails!.dropoff_address!,
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 26.0,
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: RaisedButton(
                          onPressed: () async
                          {
                            if(status=="accepted"){
                              status="arrived";
                            String rideRequestId =widget.rideDetails!.rideRequestId!;
                            newRequestsRef.child(rideRequestId).child("status").set(status);

                            setState(() {
                              btn_title="Start Trip";
                              btn_color= Colors.blue;
                            });
                            showDialog(
                              context:context,
                              barrierDismissible: false,
                              builder: (BuildContext context)=>ProgressDialog(message: "Please Wait... "),
                            );
                            await getPlaceDirection(widget.rideDetails!.pickup!, widget.rideDetails!.dropoff!);
                            Navigator.pop(context);
                            }
                            else if(status=="arrived"){
                              status="onride";
                              String rideRequestId =widget.rideDetails!.rideRequestId!;
                              newRequestsRef.child(rideRequestId).child("status").set(status);

                              setState(() {
                                btn_title="End Trip";
                                btn_color= Colors.black;
                              });
                              initTimer();
                            }
                            else if(status=="onride"){
                              endTheTrip();
                            }
                          },
                          color: btn_color,
                          child: Padding(
                            padding: EdgeInsets.all(17.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  btn_title,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Icon(
                                  Icons.directions_car,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> getPlaceDirection(LatLng pickUpLatlng,LatLng dropOffLatlng)async{
    showDialog(
        context: context,
        builder: (BuildContext context)=>ProgressDialog(message: "Please Wait")
    );
print("pickup :  $pickUpLatlng , drop of : $dropOffLatlng");
    var details=await AssistantMethods.obtainPlaceDirectionDetail(pickUpLatlng, dropOffLatlng);

    Navigator.pop(context);

    print("this is encoded points :: ");
    print(details.encodedPoint);

    PolylinePoints polylinePoints=PolylinePoints();
    List<PointLatLng> decodedPolylinePointResult = polylinePoints.decodePolyline(details.encodedPoint!);

    polylineCoordinates.clear();
    if(decodedPolylinePointResult.isNotEmpty){
      decodedPolylinePointResult.forEach((PointLatLng pointLatLng) {
        polylineCoordinates.add(LatLng(pointLatLng.latitude,pointLatLng.longitude));
      });
    }
    polyLineSet.clear();
    setState(() {
      Polyline polyline=Polyline(
        color:Colors.black,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: polylineCoordinates,
        width:5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polyLineSet.add(polyline);
    });

    LatLngBounds latLngBounds;
    if(pickUpLatlng.latitude>dropOffLatlng.latitude && pickUpLatlng.longitude > dropOffLatlng.longitude){
      latLngBounds=LatLngBounds(southwest: dropOffLatlng,northeast: pickUpLatlng);
    }
    else if(pickUpLatlng.longitude > dropOffLatlng.longitude){
      latLngBounds=LatLngBounds(southwest: LatLng(pickUpLatlng.latitude,dropOffLatlng.longitude),northeast: LatLng(dropOffLatlng.latitude,pickUpLatlng  .longitude));
    }

    else if(pickUpLatlng.latitude > dropOffLatlng.latitude){
      latLngBounds=LatLngBounds(southwest: LatLng(dropOffLatlng.latitude,pickUpLatlng.longitude),northeast: LatLng(pickUpLatlng.latitude,dropOffLatlng.longitude));
    }
    else{
      latLngBounds=LatLngBounds(southwest: pickUpLatlng,northeast: dropOffLatlng);
    }
    newRideGoogleMapController.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds,70));

    Marker pickUpLocMarker=Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        position: pickUpLatlng,
        markerId: MarkerId("pickUpId")
    );

    Marker dropOffLocMarker=Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: dropOffLatlng,
      markerId: MarkerId("dropOffId"),
    );

    setState(() {
      markersSet.add(pickUpLocMarker);
      markersSet.add(dropOffLocMarker);
    });

    Circle pickUpLocCircle=Circle(
        fillColor: Colors.blueAccent,
        center:pickUpLatlng,
        radius: 12,
        strokeColor: Colors.blue,
        circleId: CircleId("pickUpId")
    );

    Circle dropOffLocCircle=Circle(
        fillColor: Colors.purple,
        center:dropOffLatlng,
        radius: 12,
        strokeColor: Colors.purple,
        circleId: CircleId("dropOffId")
    );

    setState(() {
      circleSet.add(pickUpLocCircle);
      circleSet.add(dropOffLocCircle);

    });

  }

  void acceptRideRequest(){
    print("accepted ride");
    String rideRequestId=widget.rideDetails!.rideRequestId!;
    newRequestsRef.child(rideRequestId).child("status").set("accepted");
    newRequestsRef.child(rideRequestId).child("driver_name").set(driversInformation!.name);
    newRequestsRef.child(rideRequestId).child("driver_phone").set(driversInformation!.phone);
    newRequestsRef.child(rideRequestId).child("driver_id").set(driversInformation!.id);
    newRequestsRef.child(rideRequestId).child("car_details").set('${driversInformation!.car_color} -${driversInformation!.car_model}');

    Map LocMap=
        {
          "latitude" : currentPosition!.latitude.toString(),
          "longitude": currentPosition!.longitude.toString(),
        };
    newRequestsRef.child(rideRequestId).child("driver_location").set(LocMap);
    print("driver location set");
    driversRef.child(currentfirebaseUSer!.uid).child("history").child(rideRequestId).set(true);
  }

  void updateRideDetails()async{

    if(isRequestingDirection==false){
      isRequestingDirection=true;

      if(myPosition==null){
        return;
      }
      var postLatLng=LatLng(myPosition.latitude,myPosition.longitude);
      LatLng destinationLatLng;
      if(status=="accepted"){
        destinationLatLng=widget.rideDetails!.pickup!;
      }
      else{
        destinationLatLng=widget.rideDetails!.dropoff!;
      }
      var directionDetails =await AssistantMethods.obtainPlaceDirectionDetail(postLatLng, destinationLatLng);
      if(directionDetails!=null){
        setState(() {
          durationRide =  directionDetails.durationText!;
        });
      }
      isRequestingDirection=false;
    }

  }

  void initTimer(){
    const interval=Duration(seconds:1);
    timer = Timer.periodic(interval, (timer) {
      durationCounter=durationCounter+1;
    });
  }

  void endTheTrip()async{
    timer.cancel();

    showDialog(
      context:context,
      barrierDismissible: false,
      builder: (BuildContext context)=>ProgressDialog(message: "Please Wait... "),
    );
    var currentLatLng =   LatLng(myPosition.latitude,myPosition.longitude);
    var directionDetails=await AssistantMethods.obtainPlaceDirectionDetail(widget.rideDetails!.pickup!, currentLatLng);

    Navigator.pop(context);
    int fareAmount = AssistantMethods.calcltfare(directionDetails);

    String rideRequestId= widget.rideDetails!.rideRequestId!;
    newRequestsRef.child(rideRequestId).child("fares").set(fareAmount.toString());
    newRequestsRef.child(rideRequestId).child("status").set("ended");
    rideStreamSubscription!.cancel();

    showDialog(
      context:context,
      barrierDismissible: false,
      builder: (BuildContext context)=>CollectFareDialog(paymentMethod: widget.rideDetails!.payment_method,fareAmount: fareAmount,),
    );
    saveEarning(fareAmount);
  }

  void saveEarning(int fareAmount){
    DatabaseReference driversRef = FirebaseDatabase.instance.reference().child("drivers");
    driversRef.child(currentfirebaseUSer!.uid).child("earnings").once().then((DatabaseEvent dataSnapshot){
      if(dataSnapshot.snapshot!=null){
        double oldEarnings = double.parse(dataSnapshot.snapshot.value.toString());
        double totalEarnings = fareAmount + oldEarnings;

        driversRef.child(currentfirebaseUSer!.uid).child("earnings").set(totalEarnings.toStringAsFixed(2));
      }
      else{
        double totalEarnings = fareAmount.toDouble();
        driversRef.child(currentfirebaseUSer!.uid).child("earnings").set(totalEarnings.toStringAsFixed(2));
      }
    });
  }
}
