import 'package:dashdriver/AllScreen/mainScreen.dart';
import 'package:dashdriver/AllScreen/registrationScreen.dart';
import 'package:dashdriver/configMaps.dart';
import 'package:dashdriver/main.dart';
import 'package:flutter/material.dart';


class CarInfoScreen extends StatefulWidget {
  static const String idScreen="carInfo";
  @override
  _CarInfoScreenState createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {

  TextEditingController carModeltextEditingController=TextEditingController();
  TextEditingController carNumbertextEditingController=TextEditingController();
  TextEditingController carColortextEditingController=TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 70.0,),
             /* Image.asset("images/logo.png",width: 390,height: 250,),
             */ Padding(
                padding: EdgeInsets.fromLTRB(22.0, 22.0, 22.0, 32.0),
                child: Column(
                  children: [
                    SizedBox(height: 12.0,),
                    Text("Enter Car Details",style: TextStyle(fontFamily: "Brand Bolt",fontSize: 24.0),),
                    SizedBox(height: 26.0,),
                    TextField(
                      controller: carModeltextEditingController,
                      decoration: InputDecoration(
                        labelText: "Car Model",
                        hintStyle: TextStyle(color: Colors.grey,fontSize: 10.0),
                      ),
                      style: TextStyle(fontSize: 12.0),
                    ),
                    SizedBox(height: 10.0,),
                    TextField(
                      controller: carNumbertextEditingController,
                      decoration: InputDecoration(
                        labelText: "Car Number",
                        hintStyle: TextStyle(color: Colors.grey,fontSize: 10.0),
                      ),
                      style: TextStyle(fontSize: 12.0),
                    ),
                    SizedBox(height: 10.0,),
                    TextField(
                      controller: carColortextEditingController,
                      decoration: InputDecoration(
                        labelText: "Car Color",
                        hintStyle: TextStyle(color: Colors.grey,fontSize: 10.0),
                      ),
                      style: TextStyle(fontSize: 12.0),
                    ),
                    SizedBox(height:10.0),
                    Row(
                      children: [
                        Text('Ride Type'),
                        SizedBox(width: 20.0,),
                        DropdownButton<String>(
                          value: rideType,
                          items:[
                            DropdownMenuItem(child: Text('Share'),value: "sharing",),
                            DropdownMenuItem(child: Text('private'),value: "private",),
                          ],
                          onChanged: (value){
                            setState(() {
                              rideType=value!;
                            });
                          },

                        ),
                      ],
                    ),SizedBox(height: 42.0,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: RaisedButton(
                        onPressed: (){
                          if(carColortextEditingController.text.isEmpty){
                            displayToastMessage("the color should not be empty", context);
                          }
                          if(carModeltextEditingController.text.isEmpty){
                            displayToastMessage("the model should not be empty", context);
                          }
                          if(carNumbertextEditingController.text.isEmpty){
                            displayToastMessage("the number should not be empty", context);
                          }
                          else{
                            saveDriverCarInfo(context);
                          }
                        },
                        color: Theme.of(context).accentColor,
                        child: Padding(
                          padding: EdgeInsets.all(17.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Next",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color: Colors.white),),
                              Icon(Icons.arrow_forward,color: Colors.white,size: 28,),

                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveDriverCarInfo(context){
    String userId=currentfirebaseUSer!.uid;

    Map carInfoMap=
    {
      "car_color":carColortextEditingController.text,
      "car_number":carNumbertextEditingController.text,
      "car_model":carModeltextEditingController.text,
      "ride_type":rideType,
    };
    driversRef.child(userId).child("car_details").set(carInfoMap);
    Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
  }
}

