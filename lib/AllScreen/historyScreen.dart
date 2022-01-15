import 'package:dashdriver/AllWidgets/historyItems.dart';
import 'package:dashdriver/dataHandler/appData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text('History'),
            ),
            backgroundColor: Color(0xff00ACA4),
            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.keyboard_arrow_left),
            ),
          ),
          body: ListView.separated(
            padding: EdgeInsets.all(0),
            itemBuilder: (context,index){
              return (Provider.of<AppData>(context,listen:false).tripHistoryDataList!=null)? HistoryItem(
                history: Provider.of<AppData>(context,listen:false).tripHistoryDataList[index],
              ):Text('You have No Ride History');
            },
            separatorBuilder: (BuildContext context,int index)=>Divider(thickness: 3.0,height: 3.0,),
            itemCount: Provider.of<AppData>(context,listen:false).tripHistoryDataList.length,
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
          )
      )
    );
  }
}
