import 'package:firebase_database/firebase_database.dart';

class Users{
  String? id;
  String? name="john";
  String? email;
  String? phone;

  Users({this.id,this.name,this.email,this.phone});

  Users.fromSnapShot(DatabaseEvent dataSnapshot){
    final routeArgs = dataSnapshot.snapshot.value as Map;
    id=dataSnapshot.snapshot.key;
    name=routeArgs["name"];
    email=routeArgs["email"];
    phone=routeArgs["phone"];
  }

}