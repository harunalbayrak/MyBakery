import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_my_bakery/screens/tezgahtar/odeme_kategori.dart';
import 'package:flutter_my_bakery/services/databaseService.dart';

List images = [
  'ekmekler.jpeg',
  'kahvaltiliklar.jpeg',
  'pastalar.jpeg',
  'icecekler.jpeg',
  'tatlilar.jpeg',
  'kurabiyeler.jpeg',
  'hazirGidalar.jpeg',
  'diger.jpeg',
  'diger.jpeg',
  'diger.jpeg',
  'diger.jpeg',
  'diger.jpeg',
  'diger.jpeg'
];

class Odeme extends StatefulWidget {
  @override
  _OdemeState createState() => _OdemeState();
}

class _OdemeState extends State<Odeme> {
  DatabaseService service = DatabaseService('bakery');

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
                  "Ödeme",
                  style: TextStyle(fontFamily: "Poppins"),
                ),
                centerTitle: true,
                backgroundColor: Colors.blueGrey,
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
                  "Ödeme",
                  style: TextStyle(fontFamily: "Poppins"),
                ),
                centerTitle: true,
                backgroundColor: Colors.blueGrey,
              ),
              body: ListView.builder(
                itemCount: item.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    // onLongPress: (){
                    //   controller.text = categories[index];
                    //   confirmationPopup(context,image,1,index,controller);
                    // },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                OdemeKategori(category: item[index]["key"])),
                      );
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
              // floatingActionButton: FloatingActionButton(
              //   onPressed: (){
              //     confirmationPopup(context,image,0,0,controller);
              //   },
              //   // child: Icon(Icons.add),
              // ),
            );
        }
      },
    );
  }
}
