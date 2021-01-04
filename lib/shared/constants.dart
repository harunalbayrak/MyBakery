import "package:flutter/material.dart";

const textInputDecoration = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueGrey,width: 2.0)
    ),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black,width: 2.0)
    )
);

const textStyle1 = TextStyle(
    fontFamily: "Poppins",
    decoration: TextDecoration.none,
);

const textStyle2 = TextStyle(
    fontFamily: "Poppins",
    color: Colors.white,
    fontSize: 15,
);

const textStyle3 = TextStyle(
    fontFamily: "Poppins",
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 17
);

const textStyle4 = TextStyle(
    fontFamily: "Poppins",
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 21
);

TextStyle textStyle(Color color){
    return TextStyle(fontFamily: "Poppins",fontSize: 18,color: color);
}