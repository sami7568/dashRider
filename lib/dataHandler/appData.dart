import 'package:dashdriver/Models/history.dart';
import 'package:flutter/cupertino.dart';

class AppData extends ChangeNotifier{

  String earnings="0";
  int? tripCount=0;
  List<String> tripHistoryKeys=[];
  List<History> tripHistoryDataList=[];


  void updateEarnings(String updateEarnings){
    earnings=updateEarnings;
    notifyListeners();
  }

  void updateTripCounter(int? tripCounter){
    tripCount = tripCounter!;
    notifyListeners();
  }

  void updatTripKeys(List<String> newKeys){
    tripHistoryKeys=newKeys;
    notifyListeners();
  }

  void updateTripHistoryData(History eachhistory){
    tripHistoryDataList.add(eachhistory);
    notifyListeners();
  }
}