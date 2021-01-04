import "package:flutter/material.dart";

Widget myBottomNavigationBar(int index, void Function(int) function) {
  return BottomNavigationBar(
    currentIndex: index,
    onTap: function,
    type: BottomNavigationBarType.fixed,
    iconSize: 35,
    fixedColor: Colors.blue,
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.store_mall_directory_sharp),
        label: "İşletme Adı",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_balance),
        label: "İşletmelerim",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.add_box),
        label: "Yeni İşletme Ekle",
      ),
    ],
  );
}
