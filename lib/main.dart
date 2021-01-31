import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_my_bakery/screens/authenticate/sign_in.dart';
import 'package:flutter_my_bakery/screens/home/bottom_bar_state.dart';
import 'package:flutter_my_bakery/screens/service/service_main.dart';
import 'package:flutter_my_bakery/screens/setup/firstPage.dart';
import 'package:flutter_my_bakery/screens/tezgahtar/tezgahtar.dart';
import 'package:flutter_my_bakery/services/databaseService.dart';

String role;
Map bakery;



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My Bakery",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DatabaseService service = DatabaseService('bakery');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    service.bakeryReference.once().then((onValue){
      Map data = onValue.value;
      bakery = data["bakery"];
      //print(bakery);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User> snapshot) {
          //print(length);
          if (snapshot.hasData && snapshot.data != null) {
            Firestore.instance
                .collection('users')
                .document(snapshot.data.uid)
                .get()
                .then((DocumentSnapshot snapshot2) {
              Map x = snapshot2.data();
              //print(x);

              setState(() {
                role = x["role"];
              });
            });


            //print("role:");
            //print(role);

            if(bakery == null) {
              return FirstPage();
            } else if (role == "Yönetici" ||
                role == "Yonetici" ||
                role == "yönetici" ||
                role == "yonetici") {
              return BottomBarState();
            } else if (role == "Tezgahtar" || role == "tezgahtar") {
              return Tezgahtar();
            } else if (role == "Şoför" ||
                role == "Soför" ||
                role == "Şofor" ||
                role == "Sofor") {
              return Service();
            }
          }
          return SignIn();
        });
  }

  String getRole(String docID) {
    Firestore.instance
        .collection('users')
        .document(docID)
        .get()
        .then((DocumentSnapshot snapshot) {
      Map x = snapshot.data();
      print(x["role"]);

      return x["role"];
    });
  }
}
