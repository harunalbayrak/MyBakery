import 'package:flutter/material.dart';
import 'package:flutter_my_bakery/screens/tezgahtar/odeme.dart';
import 'package:flutter_my_bakery/services/auth.dart';
import 'package:flutter_my_bakery/shared/loading.dart';
import 'package:flutter_my_bakery/screens/tezgahtar/note.dart';
import 'package:flutter_my_bakery/screens/tezgahtar/expense.dart';
import 'package:flutter_my_bakery/screens/tezgahtar/ekmek.dart';
import 'package:flutter_my_bakery/screens/tezgahtar/veresiye.dart';
import 'package:flutter_my_bakery/screens/home/home.dart';

class Tezgahtar extends StatefulWidget {
  @override
  _TezgahtarState createState() => _TezgahtarState();
}

class _TezgahtarState extends State<Tezgahtar> {
  final AuthService _auth = AuthService();
  bool loading = false;

  int seciliSayfa = 0;
  void sayfaDegistir(int index) {
    setState(() {
      seciliSayfa = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                "Tezgahtar",
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
            body: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/background2.jpg"),
                      fit: BoxFit.cover),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        myBox(
                            context,
                            Icon(
                              Icons.attach_money_outlined,
                              size: 65,
                            ),
                            "Gider Gir",
                            Expense()),
                        SizedBox(width: 10),
                        myBox(
                            context,
                            Icon(
                              Icons.all_out,
                              size: 65,
                            ),
                            "Veresiye",
                            Veresiye()),
                        SizedBox(width: 10),
                        myBox(
                            context,
                            Icon(
                              Icons.fastfood_outlined,
                              size: 65,
                            ),
                            "Ürün sat",
                            Odeme()),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 5),
                        myBox(
                            context,
                            Icon(
                              Icons.note_add,
                              size: 65,
                            ),
                            "Not Al",
                            Note()),
                        SizedBox(width: 10),
                        myBox(
                            context,
                            Icon(
                              Icons.breakfast_dining,
                              size: 65,
                            ),
                            "Ekmek Gir",
                            Ekmek()),
                        SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
