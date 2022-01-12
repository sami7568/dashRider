import 'package:dashdriver/Models/history.dart';
import 'package:dashdriver/assistant/assistantMethods.dart';
import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
  final History? history;
  HistoryItem({this.history});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),

      child: (history!.createdAt!=null)?Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Row(
              children: <Widget>[
                Image.asset("images/pickicon.png",height: 16,width: 16,),
                SizedBox(height: 18,),
                Expanded(child: Container(child: Text(history!.pickup!,style: TextStyle(fontFamily: "Brand Bolt"),overflow: TextOverflow.ellipsis,),)),
                SizedBox(height: 5.0,),
                Text('\$${history!.fares}',style: TextStyle(fontFamily: "Brand Bolt",fontSize: 16,color: Colors.black),),
              ],
            ),
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Image.asset("images/desticon.png",height: 16,width: 16,),
              SizedBox(width: 18.0,),
              Expanded(
                child: Text(history!.dropOff!,style: TextStyle(fontSize: 18.0),overflow: TextOverflow.ellipsis,),
              ),
            ],
          ),
          SizedBox(height: 15.0,),
          Text(AssistantMethods.formatTripDate(history!.createdAt!),style: TextStyle(color: Colors.grey),),
        ],
      ):Container(
        child: Text("there is no history right now",style:TextStyle(fontSize: 30)),
      )
    );
  }
}
