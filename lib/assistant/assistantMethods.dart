
import 'package:dashdriver/AllScreen/registrationScreen.dart';
import 'package:dashdriver/Models/directionDetails.dart';
import 'package:dashdriver/Models/history.dart';
import 'package:dashdriver/assistant/requestAssistant.dart';
import 'package:dashdriver/configMaps.dart';
import 'package:dashdriver/dataHandler/appData.dart';
import 'package:dashdriver/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AssistantMethods {
  static Future<DirectionDetails> obtainPlaceDirectionDetail(
      LatLng initialPosition, LatLng finalPosition) async {
    String directionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";
    print(directionUrl);
    var res = await RequestAssistant.getRequest(directionUrl);
    if (res == "failed") {
      return null!;
    }
    print("res: $res");
    DirectionDetails directionDetails = DirectionDetails();
    directionDetails.encodedPoint = res['routes'][0]["overview_polyline"]["points"];
    print("this is encoded ");
    print(directionDetails.encodedPoint);
    directionDetails.distanceText =
        res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue =
        res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.durationText =
        res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue =
        res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }

  static int calcltfare(DirectionDetails directionDetails) {

    double? timeTraveledFares = (directionDetails.durationValue! / 60) * 0.20;
    double? distanceTraveledFares = (directionDetails.distanceValue! / 1000) * 0.20;
    double? totalFareAmmount = (timeTraveledFares+ distanceTraveledFares);
    //totalFareAmmount = totalFareAmmount*150;
    return totalFareAmmount.truncate();

  }

  static void disableHomeTabLiveLocationUpdates() {
    homeTabPageStreamSubscription!.pause();
    if(currentfirebaseUSer!=null){
      Geofire.removeLocation(currentfirebaseUSer!.uid);
    }
    else{
     print("no user");
    }
  }

  static void enableHomeTabLiveLocationUpdates() {
    homeTabPageStreamSubscription!.resume();
    Geofire.setLocation(currentfirebaseUSer!.uid, currentPosition!.latitude,
        currentPosition!.longitude);
  }

  static void retrieveHistoryInfo(context) {
    //retrieve and display earnings
    driversRef
        .child(currentfirebaseUSer!.uid)
        .child("earnings")
        .once()
        .then((DatabaseEvent dataSnapshot) {
      if (dataSnapshot.snapshot.value != null) {
        String earnings = dataSnapshot.snapshot.value.toString();
        Provider.of<AppData>(context, listen: false).updateEarnings(earnings);
      } else {
       // displayToastMessage("no Earnings yet", context);
      }
    });

    //retrieve and display history
    driversRef
        .child(currentfirebaseUSer!.uid)
        .child("history")
        .once()
        .then((DatabaseEvent dataSnapshot) {
      if (dataSnapshot.snapshot.value != null) {
        //update the total number of trip counts
        dynamic keys = dataSnapshot.snapshot.value as Map;
        int tripCounter = keys!.length;
        Provider.of<AppData>(context, listen: false)
            .updateTripCounter(tripCounter);
        //update trip keys to providers
        List<String> tripHistoryKeys = [];
        keys.forEach((key, value) {
          tripHistoryKeys.add(key);
        });
        Provider.of<AppData>(context, listen: false)
            .updatTripKeys(tripHistoryKeys);
        obtainTripRequestHistoryData(context);
      }
    });
  }

  static void obtainTripRequestHistoryData(context) {
    var keys = Provider.of<AppData>(context, listen: false).tripHistoryKeys;
    for (String key in keys) {
      newRequestsRef.child(key).once().then((DatabaseEvent snapshot) {
        if (snapshot.snapshot.value != null) {
          var history = History.fromSnapshot(snapshot);
          Provider.of<AppData>(context, listen: false)
              .updateTripHistoryData(history);
        }
      });
    }
  }

  static String formatTripDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate =
        "${DateFormat.MMMd().format(dateTime)},${DateFormat.y().format(dateTime)},${DateFormat.jm().format(dateTime)}";
    return formattedDate;
  }
}
