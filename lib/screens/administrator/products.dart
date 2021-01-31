import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_my_bakery/models/Category.dart';
import 'package:flutter_my_bakery/screens/administrator/products_in.dart';
import 'package:flutter_my_bakery/services/databaseService.dart';
import 'package:flutter_my_bakery/shared/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

String uid;

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
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

    var image = Image(image: AssetImage('assets/images/icons/'));

    TextEditingController controller = TextEditingController();

    return StreamBuilder<Event>(
      stream: service.categoryReference.onValue,
      builder: (context, snapshot) {
        Map data = {};
        List item = [];
        if (snapshot.hasData) {
          data = snapshot.data.snapshot.value;
          if (data == null) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Products",
                  style: TextStyle(fontFamily: "Poppins"),
                ),
                centerTitle: true,
                backgroundColor: Colors.blueGrey,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  confirmationPopup(context, image, 0, 0, "", controller);
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
                  "Products",
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
                      uid = item[index]["name"];
                      confirmationPopup(
                          context, image, 1, index, "", controller);
                    },
                    onTap: () {
                      try {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProductsIn(category: item[index]["key"])),
                        );
                      } on Exception catch (_) {
                        print("asd");
                      }
                    },
                    leading: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: sizeW,
                        minHeight: sizeH,
                        maxWidth: sizeW + 20,
                        maxHeight: sizeH + 20,
                      ),
                      child: Icon(Icons.category),
                    ),
                    title: Text(
                      item[index]["key"],
                      style: TextStyle(fontFamily: "Poppins"),
                    ),
                  );
                },
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  confirmationPopup(context, image, 0, 0, "", controller);
                },
                child: Icon(Icons.add),
              ),
            );
        }
      },
    );
  }

  confirmationPopup(BuildContext dialogContext, Widget image, int val,
      int index, String categoryName, TextEditingController controller) {
    final contextW = MediaQuery.of(context).size.width;
    final sizeW = contextW / 20;

    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(
          fontFamily: "Poppins", fontWeight: FontWeight.bold, fontSize: sizeW),
      animationDuration: Duration(milliseconds: 400),
    );

    Alert(
        context: dialogContext,
        style: alertStyle,
        title: val == 0 ? "Kategori ekle" : "Kategoriyi düzenle",
        content: Column(
          children: [
            SizedBox(
              height: sizeW,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 50,
                minHeight: 100,
                maxWidth: 100,
                maxHeight: 150,
              ),
              child: Icon(
                Icons.category,
                size: 70,
              ),
            ),
            SizedBox(
              height: sizeW,
            ),
            TextFormField(
              controller: controller,
              style: textStyle1,
              decoration: textInputDecoration.copyWith(
                labelText: "Kategorinin ismi",
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
                      service.deleteCategory(uid);
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
              if (controller.value.text != "") {
                final newCategory = Category(name: controller.value.text);
                setState(() {
                  if (val == 0) {
                    service.addCategory(newCategory);
                  } else {
                    service.updateCategory(uid, newCategory);
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
