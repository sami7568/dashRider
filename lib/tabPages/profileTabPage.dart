import 'package:dashdriver/AllScreen/loginScreen.dart';
import 'package:dashdriver/configMaps.dart';
import 'package:dashdriver/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';

class ProfileTabPage extends StatelessWidget {
  static const String idScreen = "profile";
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: Color(0xff00ACA4),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                driversInformation!.name!.isNotEmpty?
                driversInformation!.name!: "sami ",
                style: TextStyle(
                  fontSize: 45.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Signatra"
                ),
              ),
              Text(
                title.isEmpty?" driver":title,
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.blueGrey[200],
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Brand Regular"
                ),
              ),
              SizedBox(
                height: 20,
                width: 200,
                child: Divider(
                  color: Colors.white,
                ),
              ),
              InfoCard(driversInformation==null? " 38048747679":driversInformation!.phone, Icons.phone,),
              InfoCard(driversInformation==null ?" sami@gmail.com":driversInformation!.email!,
                 Icons.email
              ),
              InfoCard( driversInformation==null?"BMW Black 930A" :driversInformation!.car_color!+" " +driversInformation!.car_model!+" "+driversInformation!.car_number!,Icons.car_repair),
              GestureDetector(
                onTap: (){
                  Geofire.removeLocation(driversInformation!.id!);
                  rideRequestRef.onDisconnect();
                  rideRequestRef.remove();
                  rideRequestRef = null;
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                },
                child: Card(
                  color: Colors.red,
                  margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 110.0),
                  child: ListTile(
                    trailing: Icon(
                      Icons.follow_the_signs_outlined,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Sign Out",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: "Brand Bolt",
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

InfoCard(String? text, IconData? icon){
  return GestureDetector(
    onTap: null,
    child: Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 25.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.black87,
        ),
        title: Text(
            text!,
            style:TextStyle(
                color: Colors.black87,
                fontSize: 16.0,
                fontFamily: "Brand Bolt"
            )
        ),

      ),
    ),
  );
}