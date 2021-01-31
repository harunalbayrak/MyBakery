import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_my_bakery/models/Worker.dart';
import 'package:flutter_my_bakery/services/databaseService.dart';
import 'package:flutter_my_bakery/shared/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

String uid;

class Employees extends StatefulWidget {
  @override
  _EmployeesState createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees> {
  DatabaseService service = DatabaseService('bakery');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final contextW = MediaQuery.of(context).size.width;
    final contextH = MediaQuery.of(context).size.height;

    final sizeW = contextW / 20;
    final sizeH = contextH / 20;

    final image = Image(image: AssetImage('assets/images/icons/user.png'));

    TextEditingController controller = TextEditingController();
    TextEditingController controller2 = TextEditingController();
    TextEditingController controller3 = TextEditingController();

    return StreamBuilder<Event>(
      stream: service.workersReference.onValue,
      builder: (context, snapshot) {
        Map data = {};
        List item = [];
        if (snapshot.hasData) {
          data = snapshot.data.snapshot.value;
          if (data == null) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Employees",
                  style: TextStyle(fontFamily: "Poppins"),
                ),
                centerTitle: true,
                backgroundColor: Colors.blueGrey,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  confirmationPopup(context, image, 0, 0, "", controller,
                      controller2, controller3);
                },
                child: Icon(Icons.add),
              ),
            );
          }
          data.forEach((index, data) => item.add({"key": index, ...data}));
        }

        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container(
              height: 200.0,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black45),
              ),
            );
          default:
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Employees",
                  style: TextStyle(fontFamily: "Poppins"),
                ),
                centerTitle: true,
                backgroundColor: Colors.blueGrey,
              ),
              body: ListView.builder(
                itemCount: item.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onLongPress: () {
                      controller.text = item[index]["name"];
                      controller2.text = item[index]["job"];
                      controller3.text = item[index]["mail"];
                      uid = item[index]["key"];
                      confirmationPopup(
                          context,
                          image,
                          1,
                          index,
                          item[index]["mail"],
                          controller,
                          controller2,
                          controller3);
                    },
                    onTap: () {
                      controller.text = item[index]["name"];
                      controller2.text = item[index]["job"];
                      controller3.text = item[index]["mail"];
                      uid = item[index]["key"];
                      confirmationPopup(
                          context,
                          image,
                          1,
                          index,
                          item[index]["mail"],
                          controller,
                          controller2,
                          controller3);
                    },
                    leading: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: sizeW,
                        minHeight: sizeH,
                        maxWidth: sizeW + 20,
                        maxHeight: sizeH + 20,
                      ),
                      child: image,
                    ),
                    title: Text(
                      item[index]["name"],
                      style: TextStyle(fontFamily: "Poppins"),
                    ),
                    trailing: Text(
                      item[index]["job"],
                      style: TextStyle(fontFamily: "Poppins"),
                    ),
                  );
                },
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  confirmationPopup(context, image, 0, 0, "", controller,
                      controller2, controller3);
                },
                child: Icon(Icons.add),
              ),
            );
        }
      },
    );
  }

  confirmationPopup(
      BuildContext dialogContext,
      Widget image,
      int val,
      int index,
      String mail,
      TextEditingController controller,
      TextEditingController controller2,
      TextEditingController controller3) {
    final contextW = MediaQuery.of(context).size.width;
    final sizeW = contextW / 20;

    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: false,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(
          fontFamily: "Poppins", fontWeight: FontWeight.bold, fontSize: sizeW),
      animationDuration: Duration(milliseconds: 400),
    );

    Alert(
        context: dialogContext,
        style: alertStyle,
        title: val == 0 ? "Çalışan ekle" : "Çalışanı düzenle",
        content: Column(
          children: [
            SizedBox(
              height: sizeW,
            ),
            image,
            SizedBox(
              height: sizeW,
            ),
            TextFormField(
              controller: controller,
              style: textStyle1,
              decoration: textInputDecoration.copyWith(
                labelText: "İsim soyisim",
              ),
              validator: (val) => val.isEmpty ? "Enter an email" : null,
              onChanged: (val) {
                setState(() {});
              },
            ),
            SizedBox(
              height: sizeW,
            ),
            TextFormField(
              controller: controller2,
              style: textStyle1,
              decoration: textInputDecoration.copyWith(
                labelText: "Görevi",
              ),
              validator: (val) => val.isEmpty ? "Enter an email" : null,
              onChanged: (val) {
                setState(() {});
              },
            ),
            SizedBox(
              height: sizeW,
            ),
            TextFormField(
              controller: controller3,
              style: textStyle1,
              decoration: textInputDecoration.copyWith(
                labelText: "E-Mail",
              ),
              validator: (val) => val.isEmpty ? "Enter an email" : null,
              onChanged: (val) {
                setState(() {});
              },
            ),
          ],
        ),
        buttons: [
          val == 1
              ? DialogButton(
                  child: Text(
                    "Sil",
                    style: TextStyle(color: Colors.white, fontSize: sizeW),
                  ),
                  onPressed: () {
                    setState(() {
                      service.deleteWorker(uid);
                    });
                    Navigator.pop(context);
                  },
                  color: Colors.red,
                )
              : DialogButton(
                  child: Text(
                    "İptal",
                    style: TextStyle(color: Colors.white, fontSize: sizeW),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.red,
                ),
          DialogButton(
            child: Text(
              val == 0 ? "Ekle" : "Düzenle",
              style: TextStyle(color: Colors.white, fontSize: sizeW),
            ),
            onPressed: () {
              if (controller.value.text != "" && controller2.value.text != "") {
                int passwd = 0;
                for (var i = 0; i < 6; i++) {
                  passwd = passwd + ((Random().nextInt(8) + 1) * pow(10, i));
                }
                setState(() {
                  if (val == 0) {
                    final newWorker = Worker(
                        name: controller.value.text,
                        mail: controller3.value.text,
                        job: controller2.value.text,
                        password: passwd.toString());
                    service.addWorker(newWorker);
                    service.registerWorkers();
                  } else {
                    final newWorker = Worker(
                        name: controller.value.text,
                        mail: controller3.value.text,
                        job: controller2.value.text,
                        password: passwd.toString());
                    service.updateWorker(uid, newWorker);
                  }
                });
              }
              Navigator.pop(context);
            },
            color: Colors.blue,
          )
        ]).show();
  }
}
