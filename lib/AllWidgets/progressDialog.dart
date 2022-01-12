
import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {

  String? message;
  ProgressDialog({this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        margin: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(1.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: <Widget>[
              SizedBox(width: 6.0,),
              CircularProgressIndicator( valueColor: AlwaysStoppedAnimation<Color>(Colors.green),),
              SizedBox(width: 26.0,),
              Text(
                message!,
                style: TextStyle(color: Colors.green,fontSize: 10.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
