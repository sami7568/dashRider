import 'package:dashdriver/configMaps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RatingTabPage extends StatefulWidget {
  @override
  _RatingTabPageState createState() => _RatingTabPageState();
}

class _RatingTabPageState extends State<RatingTabPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff00ACA4),
        body:Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            height: 400,
            margin: EdgeInsets.all(15.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(45.0),
            ),
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 50,),
                child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text("Your Ratings", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0,fontFamily: "Brand Bolt",color: Colors.black54),
                ),
                Divider(height: 2.0,thickness: 2.0,),
                SmoothStarRating(
                  rating: starCounter,
                  color: Color(0xff00ACA4),
                  allowHalfRating: true,
                  isReadOnly:true,
                  starCount: 5,
                  size: 45,
                ),
                Text(title,style: TextStyle(fontSize: 30.0,fontFamily: "Brand Bolt",color: Colors.blue),),
                SizedBox(height: 16.0,),
              ],
            )),
          ),
        )
    );
  }
}