import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_my_bakery/screens/tezgahtar/odeme_kategori.dart';
import 'package:flutter_my_bakery/screens/tezgahtar/veresiye2.dart';
import 'package:flutter_my_bakery/services/crud.dart';
import 'package:flutter_my_bakery/shared/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Sepet extends StatefulWidget {
  List product;
  List price;
  List piece;
  Sepet({Key key, this.product, this.price, this.piece}) : super(key: key);

  @override
  _SepetState createState() => _SepetState();
}

class _SepetState extends State<Sepet> {
  double sumPrice() {
    print("QQQQQQQQQQQQQQQQQQQQQQQQQQQQ: " + widget.price.length.toString());
    if (widget.price.length == 0) {
      // print("0 dönmüş olmalı\nwwwwwwwwwwwwwwwwwwwwwwwwwwww: " + (price == null).toString());
      return 0;
    }
    double sum = 0;
    for (int i = 0; i < widget.price.length; ++i) {
      sum += price[i] * piece[i];
    }
    return sum;
  }

  DatabaseService service = DatabaseService();

  void goTezgahtar(BuildContext cx) {
    setState(() {
      product.clear();
      piece.clear();
      price.clear();
    });
    Fluttertoast.showToast(
      msg: "✓ Kaydedildi",
      toastLength: Toast.LENGTH_SHORT,
      fontSize: 28,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
    );
    Navigator.of(cx).pop(); // :)
    Navigator.of(cx).pop(); // ;)
    Navigator.of(cx).pop(); // :D
    Navigator.of(cx).pop(); // xD
  }

  void goVeresiye(BuildContext cx) {
    setState(() {
      product.clear();
      piece.clear();
      price.clear();
    });
    // Fluttertoast.showToast(
    //   msg: "✓ Kaydedildi",
    //   toastLength: Toast.LENGTH_SHORT,
    //   fontSize: 28,
    //   gravity: ToastGravity.BOTTOM,
    //   backgroundColor: Colors.green,
    // );
    Navigator.of(cx).pop(); // :)
    Navigator.of(cx).pop(); // ;)
    Navigator.of(cx).pop(); // :D
    Navigator.of(cx).pop(); // xD

    Navigator.push(
      cx,
      MaterialPageRoute(builder: (context) => Veresiye2()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contextW = MediaQuery.of(context).size.width;
    final contextH = MediaQuery.of(context).size.height;

    final sizeW = contextW / 20;
    final sizeH = contextH / 20;

    final image = Image(image: AssetImage('assets/images/icons/bread2.png'));

    TextEditingController controller = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Sepet",
            style: TextStyle(fontFamily: "Poppins"),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueGrey,
        ),
        body: ListView.builder(
          itemCount: widget.product.length,
          itemBuilder: (context, index) {
            return ListTile(
              onLongPress: () {
                deletePopup(context, image, index, controller);
              },
              onTap: () {
                controller.text = widget.piece[index].toString();
                confirmationPopup(context, image, index, controller);
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
                widget.product[index],
                style: TextStyle(fontFamily: "Poppins"),
              ),
              trailing: Text(
                "Adet: " +
                    widget.piece[index].toString() +
                    " - Toplam fiyat : " +
                    (widget.piece[index] * widget.price[index]).toString(),
                style: TextStyle(fontFamily: "Poppins"),
              ),
              subtitle: Text(
                "Fiyat: " + widget.price[index].toString() + " ₺",
                style: TextStyle(fontFamily: "Poppins"),
              ),
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RawMaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                elevation: 2.0,
                fillColor: Colors.red,
                child: Icon(
                  Icons.close,
                  size: 35.0,
                ),
                padding: EdgeInsets.all(15.0),
                shape: CircleBorder(),
              ),
              Text(
                sumPrice().toString() + " ₺",
                style: TextStyle(fontFamily: "Poppins", fontSize: 24),
              ),
              RawMaterialButton(
                onPressed: () {
                  if (product.isNotEmpty) confirmationPopup2(context, service);
                },
                elevation: 2.0,
                fillColor: Colors.green,
                child: Icon(
                  Icons.check,
                  size: 35.0,
                ),
                padding: EdgeInsets.all(15.0),
                shape: CircleBorder(),
              )
            ],
          ),
        ));
  }

  deletePopup(BuildContext dialogContext, Widget image, int index,
      TextEditingController controller) {
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
        title: "Ürün Sil!",
        content: Column(
          children: [
            SizedBox(
              height: sizeW,
            ),
            image,
            SizedBox(
              height: sizeW,
            ),
          ],
        ),
        buttons: [
          DialogButton(
            child: Text(
              "Sil",
              style: TextStyle(color: Colors.white, fontSize: sizeW * 0.6),
            ),
            onPressed: () {
              // if (int.parse(controller.text) >= 0) {
              setState(() {
                widget.piece[index] = 0;
                //remove from list
                widget.product.removeAt(index);
                widget.price.removeAt(index);
                widget.piece.removeAt(index);
              });
              Navigator.pop(context);
              // }
              // Navigator.pop(context);
            },
            color: Colors.red,
          ),
          DialogButton(
            child: Text(
              "Vazgeç",
              style: TextStyle(color: Colors.white, fontSize: sizeW * 0.6),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.blue,
          ),
        ]).show();
  }

  confirmationPopup(BuildContext dialogContext, Widget image, int index,
      TextEditingController controller) {
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
        title: "Adeti düzelt",
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
              keyboardType: TextInputType.number,
              controller: controller,
              style: textStyle1,
              decoration: textInputDecoration.copyWith(
                labelText: "Adeti giriniz",
              ),
              validator: (val) => val.isEmpty ? "Enter an email" : null,
              onChanged: (val) {
                setState(() {});
              },
            ),
          ],
        ),
        buttons: [
          DialogButton(
            child: Text(
              "Güncelle",
              style: TextStyle(color: Colors.white, fontSize: sizeW * 0.6),
            ),
            onPressed: () {
              if (int.parse(controller.text) >= 0) {
                setState(() {
                  widget.piece[index] = int.parse(controller.value.text);
                  if (int.parse(controller.value.text) == 0) {
                    //remove from list
                    widget.product.removeAt(index);
                    widget.price.removeAt(index);
                    widget.piece.removeAt(index);
                  }
                });
              }
              Navigator.pop(context);
            },
            color: Colors.green,
          ),
          DialogButton(
            child: Text(
              "-",
              style: TextStyle(color: Colors.white, fontSize: sizeW),
            ),
            onPressed: () {
              if (int.parse(controller.text) > 0) {
                setState(() {
                  controller.text =
                      (int.parse(controller.value.text) - 1).toString();
                  widget.piece[index] = int.parse(controller.value.text);
                  if (int.parse(controller.value.text) == 0) {
                    //remove from list
                    widget.product.removeAt(index);
                    widget.price.removeAt(index);
                    widget.piece.removeAt(index);
                  }
                });
              }
            },
            color: Colors.blue,
          ),
          DialogButton(
            child: Text(
              "+",
              style: TextStyle(color: Colors.white, fontSize: sizeW),
            ),
            onPressed: () {
              setState(() {
                controller.text =
                    (int.parse(controller.value.text) + 1).toString();
                widget.piece[index] = int.parse(controller.value.text);
              });
            },
            color: Colors.blue,
          ),
        ]).show();
  }

  confirmationPopup2(BuildContext dialogContext, DatabaseService service) {
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

    //product - price - piece
    // product
    //    price
    //    piece

    Map<dynamic, dynamic> res = {};
    List<Map<dynamic, dynamic>> tx = List();
    for (int i = 0; i < product.length; i++) {
      // print(product[i].toString());
      // print(price[i] * 1.0 is double);
      ItemHolder ele =
          ItemHolder(product[i].toString(), price[i] * 1.0, piece[i]);
      tx.insert(i, ele.toMap());
      // print(tx);
    }

    Alert(
        context: dialogContext,
        style: alertStyle,
        title: "Ödeme yöntemini seçin",
        content: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            RaisedButton(
              onPressed: () {
                // print(res);
                res.addAll({
                  'Ürünler': tx,
                  'Ödeme Yöntemi': 'Kredi Kartı',
                  'Toplam Alınan Ücret': sumPrice()
                });
                service.addTx(res);
                goTezgahtar(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.credit_card,
                    color: Colors.white,
                    size: 25,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "Kredi Kartı",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontFamily: "Poppins"),
                  ),
                ],
              ),
              color: Colors.purple,
            ),
            RaisedButton(
              onPressed: () {
                res.addAll({
                  'Ürünler': tx,
                  'Ödeme Yöntemi': "Nakit Ödeme",
                  'Toplam Alınan Ücret': sumPrice()
                });
                service.addTx(res);
                goTezgahtar(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.money,
                    color: Colors.white,
                    size: 25,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "Nakit Ödeme",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontFamily: "Poppins"),
                  ),
                ],
              ),
              color: Colors.teal,
            ),
            RaisedButton(
              onPressed: () {
                Clipboard.setData(
                    new ClipboardData(text: sumPrice().toString()));
                res.addAll({
                  'Ürünler': tx,
                  'Ödeme Yöntemi': "Veresiye",
                  'Toplam Alınan Ücret': sumPrice()
                });
                service.addTx(res);
                goVeresiye(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.all_out_sharp,
                    color: Colors.white,
                    size: 25,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "Veresiye",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontFamily: "Poppins"),
                  ),
                ],
              ),
              color: Colors.orange,
            )
          ],
        ),
        buttons: []).show();
  }
}

class ItemHolder {
  String product;
  double price;
  int piece;

  ItemHolder(this.product, this.price, this.piece);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'product': this.product,
      'price': this.price,
      'piece': this.piece
    };
  }
}
