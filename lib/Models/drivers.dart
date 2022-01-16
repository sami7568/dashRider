import 'package:firebase_database/firebase_database.dart';

class Drivers{
  String? name;
  String? email;
  String? phone;
  String? id;
  String? car_model;
  String? car_color;
  String? car_number;
  String? ride_type;

  Drivers({this.name,this.email,this.phone,this.id,this.car_color,this.car_model,this.car_number,this.ride_type});

  Drivers.fromSnapshot(DatabaseEvent dataSnapshot){
    final routeArgs = dataSnapshot.snapshot.value as Map;
    id=dataSnapshot.snapshot.key;
    phone=routeArgs['phone'];
    email=routeArgs['email'];
    name=routeArgs['name'];
    car_color=routeArgs['car_color'];
    car_model=routeArgs['car_model'];
    car_number=routeArgs['car_number'];
    ride_type=routeArgs['ride_type'];
  }
}