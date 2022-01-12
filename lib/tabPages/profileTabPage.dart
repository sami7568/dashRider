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
        backgroundColor: Colors.black87,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                driversInformation!.name! +" ",
                style: TextStyle(
                  fontSize: 65.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Signatra"
                ),
              ),
              Text(
                title + " driver",
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
              SizedBox(
                height: 40.0,
              ),
              InfoCard(
                text: driversInformation!.phone! +" ",
                icon: Icons.phone,
                onPressed: () async {
                  print('this is your phone ');
                },
              ),
              InfoCard(
                text: driversInformation!.email! +" ",
                icon: Icons.email,
                onPressed: () async {
                  print('this is your email ');
                },
              ),
              InfoCard(text: driversInformation!.car_color! + " "+ driversInformation!.car_number!+ " "+ driversInformation!.car_model!+" ",
                  icon: Icons.car_repair,
                  onPressed: ()async{
                      print('this is your car information');
                  }),
              GestureDetector(
                onTap: (){
                  Geofire.removeLocation(driversInformation!.id!);
                  rideRequestRef.onDisconnect();
                  rideRequestRef.remove();
                 // rideRequestRef = null;

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

class InfoCard extends StatelessWidget {
  final String? text;
  final IconData? icon;
  Function? onPressed;

  InfoCard({@required this.text,@required this.icon,@required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed!(),
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
}
