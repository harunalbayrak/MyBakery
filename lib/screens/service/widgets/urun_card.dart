import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_my_bakery/screens/service/service_models/urun_model.dart';
import 'package:flutter_my_bakery/shared/constants.dart';

class UrunCard extends StatefulWidget {
  final Color color;
  final String name;
  final double price;
  Function editFunction;
  UrunCard(
      {Key key, this.name, this.price = 0, this.color, this.editFunction}) {}

  @override
  _UrunCardState createState() => _UrunCardState();
}

class _UrunCardState extends State<UrunCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.color,
      margin: EdgeInsets.all(8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                width: MediaQuery.of(context).size.width / 3,
                child: Text(widget.name)),
            Container(
                width: MediaQuery.of(context).size.width / 3,
                child: Text(widget.price.toString() + " TL")),
            Container(
              alignment: Alignment.centerRight,
              width: MediaQuery.of(context).size.width / 5,
              child: InkWell(
                child: Icon(Icons.edit),
                onTap: () => {widget.editFunction(widget.name, widget.price)},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
