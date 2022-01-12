import 'package:dashdriver/tabPages/earningTabPage.dart';
import 'package:dashdriver/tabPages/homeTabPage.dart';
import 'package:dashdriver/tabPages/profileTabPage.dart';
import 'package:dashdriver/tabPages/ratingTabPage.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  static const String idScreen = "main";
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
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
        items: <BottomNavigationBarItem>[
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
        selectedItemColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 12.0),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,
      ),
    );
  }
}
