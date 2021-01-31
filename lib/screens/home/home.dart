import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_my_bakery/screens/administrator/products.dart';
import 'package:flutter_my_bakery/screens/administrator/employees.dart';
import 'package:flutter_my_bakery/screens/administrator/reports.dart';
import 'package:flutter_my_bakery/screens/service/service_main.dart';
import 'package:flutter_my_bakery/screens/tezgahtar/tezgahtar.dart';
import 'package:flutter_my_bakery/screens/tezgahtar/veresiye.dart';
import 'package:flutter_my_bakery/services/databaseService.dart';
import 'package:flutter_my_bakery/shared/constants.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DatabaseService service = DatabaseService("bakery");
  DateFormat dateFormat1 = DateFormat("yyyy-MM-dd");

  int toplamCikanEkmek = 0;
  int dagitimdaSatilanEkmek = 0;
  int toplamKalanEkmek = 0;
  int vitrindenToplamSatisTutari = 0;
  int krediKartiSatisTutari = 0;
  int kasadaOlmasiGerekenTutar = 0;
  int _kalan = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      getBreadData();
    });
  }

  void getBreadData(){
    String currentTime = dateFormat1.format(DateTime.now());
    int sum = 0;



  }

  @override
  Widget build(BuildContext context) {
    int sum = 0;

    String currentTime = dateFormat1.format(DateTime.now());
    service.bakeryRef.child("dailyData").child(currentTime).child("producedBreads").onValue.listen((event){
      var snapshot = event.snapshot;
      Map value = snapshot.value;

      value.forEach((key, value) {
        var xx = value["title"];
        //print('Value is $xx');
        sum += int.parse(xx);
      });
      setState(() {
        toplamCikanEkmek = sum;
        //print(toplamCikanEkmek);
      });
    });

    service.bakeryRef.child("dailyData").child(currentTime).onValue.listen((event){
      var snapshot = event.snapshot;
      Map value = snapshot.value;

      dagitimdaSatilanEkmek = int.parse(value["delivered"]);
      _kalan = toplamCikanEkmek - dagitimdaSatilanEkmek;
    });

    service.bakeryRef.child("dailyData").child(currentTime).child("tx").onValue.listen((event){
      int sumNakit = 0;
      int sumKrediKarti = 0;
      Map x = event.snapshot.value;

      x.forEach((key,value){
        //print(value["Toplam Alınan Ücret"]);
        //print(value["Ödeme Yöntemi"]);

        if(value["Ödeme Yöntemi"] == "Nakit Ödeme"){
          sumNakit += value["Toplam Alınan Ücret"];
        } else if(value["Ödeme Yöntemi"] == "Kredi Kartı"){
          sumKrediKarti += value["Toplam Alınan Ücret"];
        }
      });
      vitrindenToplamSatisTutari = sumNakit;
      krediKartiSatisTutari = sumKrediKarti;
      kasadaOlmasiGerekenTutar = sumNakit + (_kalan * 1.75).toInt();
    });

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
                  myBox2(context,toplamCikanEkmek,dagitimdaSatilanEkmek,vitrindenToplamSatisTutari,krediKartiSatisTutari,kasadaOlmasiGerekenTutar),
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
                          Reports(toplamCikanEkmek: toplamCikanEkmek,dagitimdaSatilanEkmek: dagitimdaSatilanEkmek,toplamKalanEkmek: toplamKalanEkmek,vitrindenToplamSatisTutari: vitrindenToplamSatisTutari,krediKartiSatisTutari: krediKartiSatisTutari,kasadaOlmasiGerekenTutar: kasadaOlmasiGerekenTutar,)),
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

Widget myBox2(BuildContext context, int toplamCikanEkmek, int dagitimdaSatilanEkmek, int vitrindenToplamSatisTutari, int krediKartiSatisTutari, int kasadaOlmasiGerekenTutar) {
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
              "\₺ " + kasadaOlmasiGerekenTutar.toString(),
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
                  MaterialPageRoute(builder: (context) => Reports(toplamCikanEkmek: toplamCikanEkmek,dagitimdaSatilanEkmek: dagitimdaSatilanEkmek,toplamKalanEkmek: 0,vitrindenToplamSatisTutari: vitrindenToplamSatisTutari,krediKartiSatisTutari: krediKartiSatisTutari,kasadaOlmasiGerekenTutar: kasadaOlmasiGerekenTutar,)),
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
