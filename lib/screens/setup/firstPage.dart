import 'dart:ui';

import 'package:flutter/material.dart';

import 'categories.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final _nameController = TextEditingController();
  void nextPage(BuildContext cx) {
    if (_nameController.text.isNotEmpty) {
      Navigator.of(cx).push(
        MaterialPageRoute(
          builder: (_) {
            return Categories(bakeryName: _nameController.text);
          },
        ),
      );
    } else
      showAlertDialog(cx);
  }

  showAlertDialog(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("İşletme adı boş bırakılamaz."),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/images/setupbg.jpeg",
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Column(
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    color: Colors.white70,
                    child: ListTile(
                      title: Container(
                        margin: EdgeInsets.only(bottom: 10, top: 5),
                        child: Text(
                          "HOŞGELDİNİZ",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      subtitle: Text(
                        "İşletmenizin adını girip alttaki butonuna tıklayarak fırınınızı oluşturmaya başlayabilirsiniz.",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          wordSpacing: 0.75,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.only(left: 18, right: 5, bottom: 10),
                  color: Colors.white70,
                  child: TextField(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      fontFamily: "Poppins",
                    ),
                    decoration: InputDecoration(labelText: 'İşletme adı :'),
                    controller: _nameController,
                    // onChanged: (val) {
                    //   titleInput = val;
                    // },
                  ),
                ),
                Container(
                  alignment: Alignment(0.6, 0),
                  child: RaisedButton(
                    onPressed: () => nextPage(context),
                    child: Text("BAŞLAYALIM"),
                    color: Colors.blueGrey,
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          )
        ],
      ),
    );
  }
}
