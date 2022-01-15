import 'package:dashdriver/AllScreen/registrationScreen.dart';
import 'package:dashdriver/Models/pushNotificationModel.dart';
import 'package:dashdriver/tabPages/earningTabPage.dart';
import 'package:dashdriver/tabPages/homeTabPage.dart';
import 'package:dashdriver/tabPages/profileTabPage.dart';
import 'package:dashdriver/tabPages/ratingTabPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class MainScreen extends StatefulWidget {
  static const String idScreen = "main";
  @override
  _MainScreenState createState() => _MainScreenState();
}
class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late final FirebaseMessaging _messaging;

  TabController? tabController;
  int selectedIndex=0;
  void onItemClicked(int index){
    setState(() {
      selectedIndex=index;
      tabController!.index=selectedIndex;
    });
  }
  @override
  void initState() {

    tabController= TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
  tabController!.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          HomeTabPage(),
          EarningTabPage(),
          RatingTabPage(),
          ProfileTabPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home),
          label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card),
            label: 'Earning',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star),
            label: 'Rating',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person),
            label: 'Profile',
          ),
          ],
        unselectedItemColor: Colors.black54,
        selectedItemColor: Color(0xff00ACA4),
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 12.0),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,
      ),
    );
  }
}
