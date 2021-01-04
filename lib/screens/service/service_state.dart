import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_my_bakery/screens/service/service_main.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My Bakery",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.blueGrey,
        primarySwatch: Colors.amber,
      ),
      home: Service(),
    );
  }
}
