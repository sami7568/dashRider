import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideDetails{
  String? pickup_address;
  String? dropoff_address;
  LatLng? pickup;
  LatLng? dropoff;
  String? rideRequestId;
  String? rider_name;
  String? rider_phone;

  RideDetails({this.pickup_address,this.dropoff_address,this.pickup,this.dropoff,this.rideRequestId,this.rider_phone,this.rider_name});

}