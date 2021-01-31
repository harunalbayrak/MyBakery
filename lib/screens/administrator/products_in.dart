import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_my_bakery/models/Product.dart';
import 'package:flutter_my_bakery/services/databaseService.dart';
import 'package:flutter_my_bakery/shared/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

String uid;

class ProductsIn extends StatefulWidget {
  String category;

  ProductsIn({Key key, this.category}) : super(key: key);

  @override
  _ProductsInState createState() => _ProductsInState();
}

class _ProductsInState extends State<ProductsIn> {
  DatabaseService service = DatabaseService('bakery');

  @override
  Widget build(BuildContext context) {
    int flag = 0;
    final contextW = MediaQuery.of(context).size.width;
    final contextH = MediaQuery.of(context).size.height;

    final sizeW = contextW / 20;
    final sizeH = contextH / 20;

    final image = Image(image: AssetImage('assets/images/icons/bread2.png'));

    TextEditingController controller = TextEditingController();
    TextEditingController controller2 = TextEditingController();

    return flag == 1
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                widget.category.toString(),
                style: TextStyle(fontFamily: "Poppins"),
              ),
              centerTitle: true,
              backgroundColor: Colors.blueGrey,
            ),
            body: Container(),
          )
        : StreamBuilder<Event>(
            stream: service.categoryReference.child(widget.category).onValue,
            builder: (context, snapshot) {
              Map data = {};
              List item = [];
              if (snapshot.hasData) {
                data = snapshot.data.snapshot.value;

                print(data.length);
                print(data.values.first);
                print(widget.category.toString());

                if (data == null ||
                    (data.length == 1 &&
                        data.values.first.toString() ==
                            widget.category.toString())) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text(
                        widget.category.toString(),
                        style: TextStyle(fontFamily: "Poppins"),
                      ),
                      centerTitle: true,
                      backgroundColor: Colors.blueGrey,
                    ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () {
                        confirmationPopup(
                            context, image, 0, 0, "", controller, controller2);
                      },
                      child: Icon(Icons.add),
                    ),
                  );
                }
                data.forEach(
                    (index, data) => item.add({"key": index, ...data}));
              }

              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
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
                        widget.category.toString(),
                        style: TextStyle(fontFamily: "Poppins"),
                      ),
                      centerTitle: true,
                      backgroundColor: Colors.blueGrey,
                    ),
                    body: ListView.builder(
                      itemCount: item.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            controller.text = item[index]["name"];
                            controller2.text = item[index]["price"].toString();
                            uid = item[index]["key"];
                            confirmationPopup(context, image, 1, index, uid,
                                controller, controller2);
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
                            item[index]["price"].toString() + " ₺",
                            style:
                                TextStyle(fontFamily: "Poppins", fontSize: 20),
                          ),
                        );
                      },
                    ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () {
                        confirmationPopup(
                            context, image, 0, 0, "", controller, controller2);
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
      String productName,
      TextEditingController controller,
      TextEditingController controller2) {
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
        title: val == 0 ? "Ürün ekle" : "Ürünü düzenle",
        content: Column(
          children: [
            SizedBox(
              height: sizeW,
            ),
            TextFormField(
              controller: controller,
              style: textStyle1,
              decoration: textInputDecoration.copyWith(
                labelText: "Ürünün ismi",
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
              keyboardType: TextInputType.number,
              controller: controller2,
              style: textStyle1,
              decoration: textInputDecoration.copyWith(
                labelText: "Ürünün fiyatı",
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
                      service.deleteProduct2(widget.category, productName);
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
                final newProduct = Product(
                    name: controller.value.text,
                    category: widget.category,
                    amount: double.parse(controller2.value.text));
                setState(() {
                  if (val == 0) {
                    service.addProduct(newProduct);
                  } else {
                    service.updateProduct(uid, newProduct);
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
