import 'package:dashdriver/AllScreen/historyScreen.dart';
import 'package:dashdriver/dataHandler/appData.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
class EarningTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height:20.0),
              Text("Total Earnings",style: TextStyle(color: Colors.blueAccent,fontSize: 20.0),),
              Text("\$${Provider.of<AppData>(context,listen:false).earnings}",style: TextStyle(color: Colors.blueAccent,fontSize: 50,fontFamily: "Brand Bolt"),),
            ],
          ),
        ),
        Divider(height:2.0,thickness: 2.0,),
        FlatButton(
          padding: EdgeInsets.all(0),
            onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>HistoryScreen()));
            },
            child:Padding(
              padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
              child: Row(
                children: [
                  Image.asset("images/car-ios.png",width: 50,),
                  SizedBox(height: 16,),
                  Text("Total Trips",style: TextStyle(fontSize: 20),),
                  Expanded(child: Container(child:Text(Provider.of<AppData>(context,listen:false).tripCount.toString(),textAlign: TextAlign.end,style:TextStyle(fontSize: 20)),),),
                ],
              ),
            )
        ),
        Divider(height: 2.0,thickness: 2.0,),
        /*Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child:Text('\n\nMore You Ride, The More You Earn \n\nClick on Total Trips to see the trip History',style:TextStyle(fontSize:20)),
          ),
        )*/
      ],
    );
  }
}
