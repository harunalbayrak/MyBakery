import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_my_bakery/services/databaseService.dart';
import 'package:flutter_my_bakery/shared/bottom_bar.dart';
import 'package:flutter_my_bakery/shared/loading.dart';
import 'package:flutter_my_bakery/services/auth.dart';
import 'package:flutter_my_bakery/shared/states.dart' as states;

class BottomBarState extends StatefulWidget {
  @override
  _BottomBarStateState createState() => _BottomBarStateState();
}

class _BottomBarStateState extends State<BottomBarState> {
  DatabaseService service = DatabaseService('bakery');
  final AuthService _auth = AuthService();
  bool loading = false;

  int _currentIndex = 0;
  List<Widget> _children = states.children;

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                "bakery",
                style: TextStyle(fontFamily: "Poppins"),
              ),
              centerTitle: true,
              backgroundColor: Colors.blueGrey,
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.blueGrey[100],
                  ),
                  label: Text(
                    "Exit",
                    style: TextStyle(
                        color: Colors.blueGrey[100], fontFamily: "Poppins"),
                  ),
                  onPressed: () async {
                    setState(() => loading = true);
                    dynamic result = await _auth.signOut();
                    if (result == null) {
                      setState(() {
                        loading = false;
                      });
                    }
                  },
                )
              ],
            ),
            body: _children[_currentIndex],
            bottomNavigationBar:
                myBottomNavigationBar(_currentIndex, onTappedBar),
          );
  }
}
