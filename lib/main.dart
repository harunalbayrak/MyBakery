import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_my_bakery/screens/authenticate/sign_in.dart';
import 'package:flutter_my_bakery/screens/home/bottom_bar_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_my_bakery/services/databaseService.dart';

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
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  DatabaseService service = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            var workersReference = service.workersReference;
            String email = snapshot.data.email;
            //TODO
            return BottomBarState();
          }
          return SignIn();
        });
  }
}
