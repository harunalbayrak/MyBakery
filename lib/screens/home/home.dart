import 'package:flutter/material.dart';
import 'package:flutter_my_bakery/screens/administrator/products.dart';
import 'package:flutter_my_bakery/screens/administrator/employees.dart';
import 'package:flutter_my_bakery/screens/administrator/reports.dart';
import 'package:flutter_my_bakery/screens/service/service_main.dart';
import 'package:flutter_my_bakery/screens/tezgahtar/tezgahtar.dart';
import 'package:flutter_my_bakery/screens/tezgahtar/veresiye.dart';
import 'package:flutter_my_bakery/shared/constants.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    double iconSize = MediaQuery.of(context).size.width / 6 - 5;
    double size1 = MediaQuery.of(context).size.height / 80;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background2.jpg"),
                    fit: BoxFit.cover),
              ),
              child: Column(
                children: [
                  SizedBox(height: size1),
                  myBox2(context),
                  SizedBox(height: size1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      myBox(
                          context,
                          Icon(
                            Icons.local_shipping,
                            size: iconSize,
                          ),
                          "Şoför",
                          Service()),
                      SizedBox(width: size1),
                      myBox(
                          context,
                          Icon(
                            Icons.bubble_chart,
                            size: iconSize,
                          ),
                          "Tezgahtar",
                          Tezgahtar()),
                      SizedBox(width: size1),
                      myBox(
                          context,
                          Icon(
                            Icons.fastfood,
                            size: iconSize,
                          ),
                          "Ürünler",
                          Products()),
                    ],
                  ),
                  SizedBox(height: size1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      myBox(
                          context,
                          Icon(
                            Icons.file_copy,
                            size: iconSize,
                          ),
                          "Raporlar",
                          Reports()),
                      SizedBox(width: size1),
                      myBox(
                          context,
                          Icon(
                            Icons.people,
                            size: iconSize,
                          ),
                          "Çalışanlar",
                          Employees()),
                      SizedBox(width: size1),
                      myBox(
                          context,
                          Icon(
                            Icons.all_out,
                            size: iconSize,
                          ),
                          "Veresiyeler",
                          Veresiye()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget myBox(BuildContext context, Icon icon, String string, Widget function) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => function),
      );
    },
    child: Container(
      alignment: Alignment.topRight,
      decoration: BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      width: MediaQuery.of(context).size.width / 3 - 10,
      height: MediaQuery.of(context).size.width / 3 - 10,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            Text(
              string,
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w700,
                  fontSize: 17),
            )
          ],
        ),
      ),
    ),
  );
}

Widget myBox2(BuildContext context) {
  double size1 = MediaQuery.of(context).size.height / 30;
  double size2 = MediaQuery.of(context).size.height / 40;

  return Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(30.0))),
    width: MediaQuery.of(context).size.width - 10,
    height: MediaQuery.of(context).size.width / 4 - 10,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: size1 / 2,
            ),
            Text(
              "\₺ 370,345",
              style: textStyle4,
            ),
            Text(
              "Çarşamba",
              style: textStyle4,
            ),
          ],
        ),
        Column(
          children: [
            SizedBox(
              height: size2,
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Reports()),
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.black),
              ),
              colorBrightness: Brightness.light,
              color: Colors.purple[200],
              splashColor: Colors.purple[600],
              child: Text(
                "Bugünün Raporu",
                style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
              ),
            )
          ],
        ),
      ],
    ),
  );
}
