import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_my_bakery/shared/constants.dart';
import 'package:intl/intl.dart';

class Reports extends StatefulWidget {
  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  Widget build(BuildContext context) {
    double size1 = MediaQuery.of(context).size.height / 50;
    double size2 = MediaQuery.of(context).size.height / 10;
    double size3 = MediaQuery.of(context).size.height / 20;

    int toplamCikanEkmek = 1200;
    int dagitimdaSatilanEkmek = 100;
    int toplamKalanEkmek = 1000;
    int veresiyeSatilanEkmek = 100;

    int vitrindenToplamSatisTutari = 300;
    int krediKartiSatisTutari = 400;
    int kasadaOlmasiGerekenTutar = 500;

    DateFormat dateFormat = DateFormat("dd.MM.yyyy");
    String currentTime = dateFormat.format(DateTime.now());
    DateTime minTime = DateTime(2018, 12, 5);
    DateTime maxTime = DateTime.now();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Reports",style: TextStyle(fontFamily: "Poppins"),),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: LayoutBuilder(builder: (context,constraints){
        return SingleChildScrollView(
          child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth, minHeight: constraints.maxHeight),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/images/background3.jpg"),fit: BoxFit.cover),
                ),
                child: Column(
                  children: [
                    SizedBox(height: size1,),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 20,
                        height: MediaQuery.of(context).size.height / 3 + 10,
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(30.0))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(currentTime,style: TextStyle(fontFamily: "Poppins",color: Colors.white),),
                                    Icon(Icons.keyboard_arrow_right ,color: Colors.white,),
                                  ],
                                ),
                                color: Colors.indigo,
                                onPressed: () {
                                  DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  minTime: minTime,
                                  maxTime: maxTime, onChanged: (date) {
                                    print('change $date');
                                  }, onConfirm: (date) {
                                    print('confirm $date');
                                  }, currentTime: DateTime.now(), locale: LocaleType.tr);
                                },
                              ),
                              Column(
                                children: [
                                  Text("Vitrinden toplam satış tutarı",style: textStyle(Colors.green),),
                                  Text("₺ " + vitrindenToplamSatisTutari.toString(), style: textStyle(Colors.green),),
                                ],
                              ),
                              SizedBox(height: size1,),
                              Column(
                                children: [
                                  Text("Kredi kartı ile yapılan satış tutarı",style: textStyle(Colors.purple),),
                                  Text("₺ " + krediKartiSatisTutari.toString(), style: textStyle(Colors.purple),),
                                ],
                              ),
                              SizedBox(height: size1,),
                              Column(
                                children: [
                                  Text("Kasada olması gereken tutar",style: textStyle(Colors.blue),),
                                  Text("₺ " + kasadaOlmasiGerekenTutar.toString(), style: textStyle(Colors.blue),),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size1,),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3 - 20,
                            height: MediaQuery.of(context).size.height / 4 - 20,
                            child: Container(
                              decoration: BoxDecoration(color: Color(0xff633333),borderRadius: BorderRadius.all(Radius.circular(30.0))),
                              child: Column(
                                children: [
                                  Image(image: AssetImage('assets/images/bread.png'),width: size2,),
                                  SizedBox(height: size1,),
                                  Text("Toplam Çıkan Ekmek",style: textStyle2,textAlign: TextAlign.center,),
                                  SizedBox(height: size1,),
                                  Text(toplamCikanEkmek.toString() ,style: textStyle3,textAlign: TextAlign.center,)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: size1,),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3 - 20,
                            height: MediaQuery.of(context).size.height / 4 - 20,
                            child: Container(
                              decoration: BoxDecoration(color: Color(0xff2b516c),borderRadius: BorderRadius.all(Radius.circular(30.0))),
                              child: Column(
                                children: [
                                  Image(image: AssetImage('assets/images/bread.png'),width: size2,),
                                  SizedBox(height: size1,),
                                  Text("Dağıtımda Satılan Ekmek",style: textStyle2,textAlign: TextAlign.center,),
                                  SizedBox(height: size1,),
                                  Text(dagitimdaSatilanEkmek.toString() ,style: textStyle3,textAlign: TextAlign.center,)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: size1,),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3 - 20,
                            height: MediaQuery.of(context).size.height / 4 - 20,
                            child: Container(
                              decoration: BoxDecoration(color: Color(0xff773774),borderRadius: BorderRadius.all(Radius.circular(30.0))),
                              child: Column(
                                children: [
                                  Image(image: AssetImage('assets/images/bread.png'), width: size2,),
                                  SizedBox(height: size1,),
                                  Text("Toplam Kalan Ekmek",style:  textStyle2,textAlign: TextAlign.center,),
                                  SizedBox(height: size1,),
                                  Text(toplamKalanEkmek.toString() ,style: textStyle3,textAlign: TextAlign.center,)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size1,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 20,
                      height: MediaQuery.of(context).size.height / 10,
                      child: Container(
                        decoration: BoxDecoration(color: Color(0xff31402c),borderRadius: BorderRadius.all(Radius.circular(30.0))),
                        child: Row(
                          children: [
                            Image(image: AssetImage('assets/images/bread.png'),width: size2,),
                            SizedBox(width: size3 - 10,),
                            Text("Veresiye Satılan Ekmek",style: textStyle2,textAlign: TextAlign.center,),
                            SizedBox(width: size3,),
                            Text(veresiyeSatilanEkmek.toString() ,style: textStyle3,textAlign: TextAlign.center,)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
          ),
        );
      },),
    );
  }
}

