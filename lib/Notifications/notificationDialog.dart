import 'package:dashdriver/AllScreen/newRideScreen.dart';
import 'package:dashdriver/AllScreen/registrationScreen.dart';
import 'package:dashdriver/Models/rideDetails.dart';
import 'package:dashdriver/configMaps.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class NotificationDialog extends StatelessWidget {

  final RideDetails? rideDetails;

  NotificationDialog({this.rideDetails});

  @override
  Widget build(BuildContext context) {

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),),
      backgroundColor: Colors.transparent,
      elevation: 1.0,
      child:Container(
        margin: EdgeInsets.all(15.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
/*            SizedBox(height:10.0),*/
            Image.asset('images/taxi.png',width: 100,),
            Text("New Ride Request", style: TextStyle(fontFamily: "Brand Bolt", fontSize: 20.0),),
            Padding(
              padding:EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("images/pickicon.png",height: 16.0,width: 16.0,),
                      Expanded(
                        child:Container(
                          child: Text(rideDetails!.pickup_address!, style: TextStyle(fontSize: 18.0),),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("images/desticon.png",height: 16.0,width: 16.0,),
                      Expanded(
                        child: Container(
                          child: Text(rideDetails!.dropoff_address!, style: TextStyle(fontSize: 18.0),),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0,),
                ],
              ),
            ),
            Divider(thickness: 2.0,),
/*            SizedBox(height: 8.0,),*/
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(color: Colors.red),
                    ),
                    color: Colors.white,
                    textColor: Colors.black87,
                    padding: EdgeInsets.all(8.0),
                    onPressed: (){
                      assetAudioPlayer.stop();
                     Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  SizedBox(width: 20.0,),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.black),
                    ),
                    onPressed: (){
                      assetAudioPlayer.stop();
                     checkAvailablityOfRide(context);
                    },
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Text(
                      'Accept'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),

                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void checkAvailablityOfRide(context){
    print("cheking available driver");
    DatabaseReference rideRequestReff = FirebaseDatabase.instance.reference().child("drivers").child(currentfirebaseUSer!.uid).child("newRide");

    rideRequestReff.once().then((DatabaseEvent dataSnapshot){
      Navigator.pop(context);

      print("checking available driver");
      String theRideId="";
      if(dataSnapshot.snapshot.value!=null){
        theRideId = dataSnapshot.snapshot.value.toString();
        print("newRide id: $theRideId");
      }
      else{
        displayToastMessage("ride not exist", context);
      }
      if(theRideId==rideDetails!.rideRequestId){
        rideRequestReff.set("accepted");
        print("ride accepted");
       // if(noOfPassengers>=maxNumberOfRidersSeats){

        //check this one here uncomment
        // AssistantMethods.disableHomeTabLiveLocationUpdates();
       /// }
      //  else{
          print("going to new ride screen ");
          Navigator.push(context,MaterialPageRoute(builder:(context)=>NewRideScreen(rideDetails:rideDetails)));
        //}
      }
      else if(theRideId=="cancelled"){
        print("ride is cancelled");
        displayToastMessage("ride has been cancelled", context);
      }
      else if(theRideId=="timeout"){
        displayToastMessage("Ride has time out", context);
      }
      else{
        displayToastMessage("ride not exist", context);
      }
    });
  }
}
