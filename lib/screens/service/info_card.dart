import 'package:flutter/material.dart';

class InfoCard extends StatefulWidget {
  final String label;
  final String info;
  final double radius;
  final double fontSize;
  final Color color;
  final double margin;
  final bool shadow;
  final Icon icon;
  final Function onTap;
  const InfoCard({
    @required this.label,
    this.info,
    this.radius = 16,
    this.fontSize = 24,
    this.color = Colors.white,
    this.margin = 8,
    this.shadow = false,
    this.icon,
    this.onTap,
  });

  @override
  _InfoCardState createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  @override
  Widget build(BuildContext context) {
    return widget.onTap == null
        ? _Card(
            color: widget.color,
            radius: widget.radius,
            label: widget.label,
            margin: widget.margin,
            fontSize: widget.fontSize,
            info: widget.info,
            icon: widget.icon,
          )
        : InkWell(
            child: _Card(
              color: widget.color,
              radius: widget.radius,
              label: widget.label,
              margin: widget.margin,
              fontSize: widget.fontSize,
              info: widget.info,
              icon: widget.icon,
            ),
            onTap: widget.onTap,
          );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    Key key,
    @required this.color,
    @required this.radius,
    @required this.label,
    @required this.margin,
    @required this.fontSize,
    @required this.info,
    @required this.icon,
  }) : super(key: key);

  final Color color;

  final double radius;
  final String label;
  final double margin;
  final double fontSize;
  final String info;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            info != null
                ? Text(
                    info,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : SizedBox.shrink(),
            icon != null
                ? Container(
                    child: icon,
                    margin: EdgeInsets.only(bottom: 10),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
