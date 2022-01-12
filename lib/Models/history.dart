import 'package:firebase_database/firebase_database.dart';

class History{
  String? paymentMethod;
  String? createdAt;
  String? status;
  String? fares;
  String? pickup;
  String? dropOff;

  History({this.paymentMethod,this.pickup,this.createdAt,this.fares,this.status,this.dropOff});

  History.fromSnapshot(DatabaseEvent dataSnapshot){
    final routeArgs = dataSnapshot.snapshot.value as Map;
    paymentMethod=routeArgs["payment_method"];
    createdAt=routeArgs["created_at"];
    status=routeArgs["status"];
    fares=routeArgs["fares"];
    pickup=routeArgs["pick_Up_Address"];
    dropOff=routeArgs["drop_Off_Location"];
  }
}