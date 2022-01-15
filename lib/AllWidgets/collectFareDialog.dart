import 'package:dashdriver/assistant/assistantMethods.dart';
import 'package:dashdriver/configMaps.dart';
import 'package:flutter/material.dart';

class CollectFareDialog extends StatelessWidget {
  final String? paymentMethod;
  final int? fareAmount;

  CollectFareDialog({this.paymentMethod,this.fareAmount});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        height: 440,
        margin: EdgeInsets.all(15.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(55.0),
        ),
        child: Padding(
        padding: EdgeInsets.symmetric(vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Text("Trip Fare (" + rideType.toUpperCase() + ")",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
                SizedBox(height: 30,),
                Divider(thickness: 3,),
              ],
            ),
            Text(fareAmount.toString(),style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold, fontFamily: "Brand Bolt"),),
            Padding(
                padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                child:MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)
                ),
                onPressed: () async
                {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  AssistantMethods.enableHomeTabLiveLocationUpdates();
                },
                color:Color(0xff00ACA4),
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20,horizontal: 0),
                    child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Collect Cash",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Icon(
                      Icons.attach_money_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                )))),
          ],
        )),
      ),
    );
  }
}
