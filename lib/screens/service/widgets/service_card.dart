import 'package:flutter/material.dart';
import 'package:flutter_my_bakery/screens/service/service_detail_screen.dart';

class ServiceCard extends StatefulWidget {
  final int index;
  ServiceCard({Key key, String text, this.index}) : super(key: key);

  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ServiceDetails(
                  servicename: "SERVICE-" + widget.index.toString()))),
      child: Card(
        elevation: 4,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * .15,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "SERVICE-" + widget.index.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Icon(Icons.drive_eta)
            ],
          ),
        ),
      ),
    );
  }
}
