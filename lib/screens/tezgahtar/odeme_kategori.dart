import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_my_bakery/screens/tezgahtar/sepet.dart';
import 'package:flutter_my_bakery/services/databaseService.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_my_bakery/shared/constants.dart';

String uid;
int indirim = 0;

List product = List();
List price = List();
List piece = List();

class OdemeKategori extends StatefulWidget {
  String category;

  OdemeKategori ({ Key key, this.category }): super(key: key);

  @override
  _OdemeKategoriState createState() => _OdemeKategoriState();
}

class _OdemeKategoriState extends State<OdemeKategori> {
  DatabaseService service = DatabaseService();

  int sumPrice(){
    int sum = 0;
    for(int i=0;i<price.length;++i){
      sum += price[i] * piece[i];
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    final contextW = MediaQuery.of(context).size.width;
    final contextH = MediaQuery.of(context).size.height;

    final sizeW = contextW / 20;
    final sizeH = contextH / 20;

    final image = Image(image: AssetImage('assets/images/icons/bread2.png'));

    TextEditingController controller = TextEditingController();
    TextEditingController controller2 = TextEditingController();
    TextEditingController controller3 = TextEditingController();

    return StreamBuilder<Event>(
      stream: service.categoryReference.child(widget.category).onValue,
      builder: (context,snapshot){
        Map data = {};
        List item = [];
        if(snapshot.hasData) {
          data = snapshot.data.snapshot.value;
          if(data == null){
            return Scaffold(
              appBar: AppBar(
                title: Text("Employees",style: TextStyle(fontFamily: "Poppins"),),
                centerTitle: true,
                backgroundColor: Colors.blueGrey,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: (){
                  //confirmationPopup(context,image,0,0,controller);
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
        switch (snapshot.connectionState){
          case ConnectionState.waiting:
            return  Container(
              height: 200.0,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black45),
              ),
            );
          default: return Scaffold(
            appBar: AppBar(
              title: Text(widget.category.toString(),style: TextStyle(fontFamily: "Poppins"),),
              centerTitle: true,
              backgroundColor: Colors.blueGrey,
            ),
            body: ListView.builder(
              itemCount: item.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    confirmationPopup(context,image,index,controller,item);
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
                  title: Text(item[index]["name"],style: TextStyle(fontFamily: "Poppins"),),
                  trailing: Text(item[index]["price"].toString() + " ₺",style: TextStyle(fontFamily: "Poppins",fontSize: 20),),
                );
              },

            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: (){
                controller2.text = sumPrice().toString();
                controller3.text = indirim.toString();

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Sepet(product: product,piece: piece,price: price,)),
                ).then((_) {
                  setState((){});
                });// sepetten geri donunce guncellmesi icin

                // confirmationPopup2(context,image,controller2,controller3);
              },
              icon: Icon(Icons.shopping_cart_outlined),
              label: Text(sumPrice().toString() + " ₺",style: TextStyle(fontFamily: "Poppins",fontSize: 20),),
            ),
          );
        }
      },
    );
  }

  confirmationPopup(BuildContext dialogContext,Widget image,int index,TextEditingController controller,List item) {
    final contextW = MediaQuery.of(context).size.width;
    final sizeW = contextW / 20;

    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(fontFamily: "Poppins",fontWeight: FontWeight.bold, fontSize: sizeW),
      animationDuration: Duration(milliseconds: 400),
    );

    Alert(
        context: dialogContext,
        style: alertStyle,
        title: "Adet gir",
        content: Column(
          children: [
            SizedBox(height: sizeW,),
            image,
            SizedBox(height: sizeW,),
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: textStyle1,
              decoration: textInputDecoration.copyWith(
                labelText: "Adeti giriniz",
              ),
              validator: (val) => val.isEmpty ? "Enter an email" : null,

              // onChanged: (val) {
              //   setState(() {
              //     piece.add(int.parse(controller.value.text));
              //   });
              // },
            ),
          ],
        ),
        buttons: [
          DialogButton(
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
              "Ekle",
              style: TextStyle(color: Colors.white, fontSize: sizeW),
            ),
            onPressed: () {
              setState(() {
                if (int.parse(controller.value.text) > 0 ) {
                  product.add(item[index]["name"]);
                  price.add(item[index]["price"]);
                  piece.add(int.parse(controller.value.text));
                }
              });
              Navigator.pop(context);
            },
            color: Colors.blue,
          )
        ]).show();
  }
}


