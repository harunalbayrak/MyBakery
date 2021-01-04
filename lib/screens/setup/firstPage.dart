import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_my_bakery/screens/setup/categories.dart';

class FirstPage extends StatelessWidget {
  void nextPage(BuildContext cx) {
    Navigator.of(cx).push(
      MaterialPageRoute(
        builder: (_) {
          return Categories();
        },
      ),
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
                        "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words",
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
