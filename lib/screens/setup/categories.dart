import 'package:flutter/material.dart';
import 'package:flutter_my_bakery/screens/setup/Workers.dart';
import 'package:flutter_my_bakery/widgets/categoryItem.dart';
import '../../models/Category.dart';
import '../../models/Worker.dart';

const categories = const [
  Category(name: "Ekmekler", image: "assets/images/ekmekler.jpeg"),
  Category(name: "Kahvaltılıklar", image: "assets/images/kahvaltiliklar.jpeg"),
  Category(name: "Pastalar", image: "assets/images/pastalar.jpeg"),
  Category(name: "İçecekler", image: "assets/images/icecekler.jpeg"),
  Category(name: "Tatlılar", image: "assets/images/tatlilar.jpeg"),
  Category(name: "Kurabiyeler", image: "assets/images/kurabiyeler.jpeg"),
  Category(name: "Hazır Gıdalar", image: "assets/images/hazirGidalar.jpeg"),
  Category(name: "Diğer", image: "assets/images/diger.jpeg"),
];

class Categories extends StatelessWidget {
  final List<Worker> workerList = [];

  void nextPage(BuildContext cx) {
    Navigator.of(cx).push(
      MaterialPageRoute(
        builder: (_) {
          return Workers(list: workerList);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 20, left: 10, right: 10),
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.4),
          children: categories
              .map((catData) => CategoryItem(catData.name, catData.image))
              .toList(),
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Kategoriler"),
        backgroundColor: Colors.blueGrey,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        child: Icon(Icons.done),
        onPressed: () => nextPage(context),
      ),
    );
  }
}
