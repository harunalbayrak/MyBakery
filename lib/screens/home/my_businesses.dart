import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_my_bakery/services/databaseService.dart';
import 'dart:math';

List<Color> colorList = [Colors.red,Colors.purple,Colors.teal,Colors.indigo];

var rng = new Random();
var randomNum = rng.nextInt(3);

class MyBusinesses extends StatefulWidget {
  @override
  _MyBusinessesState createState() => _MyBusinessesState();
}

class _MyBusinessesState extends State<MyBusinesses> {
  DatabaseService service = DatabaseService('bakery');

  @override
  Widget build(BuildContext context) {
    final contextW = MediaQuery.of(context).size.width;
    final contextH = MediaQuery.of(context).size.height;

    final sizeW = contextW / 20;
    final sizeH = contextH / 20;

    return StreamBuilder<Event>(
      stream: service.bakeryReference.onValue,
      builder: (context,snapshot){
        Map data = {};
        List item = [];

        if(snapshot.hasData) {
          data = snapshot.data.snapshot.value;
          if(data == null){
            return Scaffold(
              appBar: AppBar(
                title: Text("Employees",style: TextStyle(fontFamily: "Poppins"),),
                centerTitle: true,
                backgroundColor: Colors.blueGrey,
              ),
            );
          }
          data.forEach(
                  (index, data) => item.add({"key": index, ...data}));
        }

        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState){
          case ConnectionState.waiting:
            return  Container(
              height: 200.0,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black45),
              ),
            );
          default: return ListView.builder(
              itemCount: item.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: sizeW,
                      minHeight: sizeH,
                      maxWidth: sizeW + 20,
                      maxHeight: sizeH + 20,
                    ),
                    child: Icon(Icons.store,color: colorList[randomNum],),
                  ),
                  title: Text(item[index]["key"],style: TextStyle(fontFamily: "Poppins"),),
                );
              },
            );
        }
      },
    );
  }
}
