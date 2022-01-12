import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dashdriver/Models/allUsers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'Models/drivers.dart';

int noOfPassengers=1;
String mapKey="AIzaSyAdCZ8sH4YKUOVNFLlhIm1onR001uJIPAM";

int numberOfRidersSeatsCount=0;
int maxNumberOfRidersSeats=4;


Position? currentPosition;

User? firebaseUser;
final assetAudioPlayer = AssetsAudioPlayer();
Users? userCurrentInfo;
Drivers? driversInformation;

User? currentfirebaseUSer;
Color driverStatusColor = Colors.black;
String driverStatusText="Offline";
StreamSubscription<Position>? homeTabPageStreamSubscription;
StreamSubscription<Position>? rideStreamSubscription;
String title="No ratings Yet";

double starCounter=0.0;
String rideType="sharing";
