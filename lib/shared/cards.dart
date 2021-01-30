import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_my_bakery/models/models.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

List<Color> colorList = [
  Colors.blue,
  Colors.green,
  Colors.indigo,
  Colors.red,
  Colors.cyan,
  Colors.teal,
  Colors.amber.shade900,
  Colors.deepOrange
];

class NoteCardComponent extends StatelessWidget {
  const NoteCardComponent({
    this.noteData,
    this.onTapAction,
    Key key,
  }) : super(key: key);

  final NotesModel noteData;
  final Function(NotesModel noteData) onTapAction;

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('tr'); //bu satırı ekliyoruz
    String neatDate = DateFormat.yMMMd('tr').add_Hm().format(noteData.date);
    Color color = colorList.elementAt(noteData.title.length % colorList.length);
    return Container(
        margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
        height: 123,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [buildBoxShadow(color, context)],
        ),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          color: Theme.of(context).dialogBackgroundColor,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              onTapAction(noteData);
            },
            splashColor: color.withAlpha(20),
            highlightColor: color.withAlpha(10),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${noteData.title.trim().length <= 20 ? noteData.title.trim() : noteData.title.trim().substring(0, 20) + '...'}',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: noteData.isImportant
                            ? FontWeight.w800
                            : FontWeight.normal),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Text(
                      '${noteData.content.trim().split('\n').first.length <= 30 ? noteData.content.trim().split('\n').first : noteData.content.trim().split('\n').first.substring(0, 30) + '...'}',
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade400),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 14),
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.flag,
                            size: 16,
                            color: noteData.isImportant
                                ? color
                                : Colors.transparent),
                        Spacer(),
                        Text(
                          '$neatDate',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade300,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  BoxShadow buildBoxShadow(Color color, BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return BoxShadow(
          color: noteData.isImportant == true
              ? Colors.black.withAlpha(100)
              : Colors.black.withAlpha(10),
          blurRadius: 8,
          offset: Offset(0, 8));
    }
    return BoxShadow(
        color: noteData.isImportant == true
            ? color.withAlpha(60)
            : color.withAlpha(25),
        blurRadius: 8,
        offset: Offset(0, 8));
  }
}

class ExpenseCardComponent extends StatelessWidget {
  const ExpenseCardComponent({
    this.expenseData,
    this.onTapAction,
    Key key,
  }) : super(key: key);

  final ExpensesModel expenseData;
  final Function(ExpensesModel expenseData) onTapAction;

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('tr'); //bu satırı ekliyoruz
    String neatDate = DateFormat.yMMMd('tr').add_Hm().format(expenseData.date);
    Color color =
        colorList.elementAt(expenseData.title.length % colorList.length);
    return Container(
        margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          // boxShadow: [buildBoxShadow(color, context)],
        ),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          color: Theme.of(context).dialogBackgroundColor,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              onTapAction(expenseData);
            },
            splashColor: color.withAlpha(20),
            highlightColor: color.withAlpha(10),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${expenseData.title.trim().length <= 20 ? expenseData.title + " ₺" : expenseData.title.trim().substring(0, 20) + '...'}',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.normal),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Text(
                      '${expenseData.content.trim().split('\n').first.length <= 30 ? expenseData.content.trim().split('\n').first : expenseData.content.trim().split('\n').first.substring(0, 30) + '...'}',
                      style:
                          TextStyle(fontSize: 20, color: Colors.grey.shade600),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: <Widget>[
                        Spacer(),
                        Text(
                          '$neatDate',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade300,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class EkmekCardComponent extends StatelessWidget {
  const EkmekCardComponent({
    this.ekmekData,
    this.onTapAction,
    // this.onTapAction,
    Key key,
  }) : super(key: key);

  final EkmekModel ekmekData;
  final Function(EkmekModel ekmekData) onTapAction;

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('tr'); //bu satırı ekliyoruz
    String neatDate = ekmekData.time;

    Color color =
        colorList.elementAt(ekmekData.amount.length % colorList.length);
    return Container(
        margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          // boxShadow: [buildBoxShadow(color, context)],
        ),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          color: Theme.of(context).dialogBackgroundColor,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => onTapAction(ekmekData),
            splashColor: color.withAlpha(20),
            highlightColor: color.withAlpha(10),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${ekmekData.amount.trim().length <= 20 ? ekmekData.amount : ekmekData.amount.trim().substring(0, 20) + '...'}',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.normal),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: <Widget>[
                        Spacer(),
                        Text(
                          '$neatDate',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade300,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class VeresiyeCardComponent extends StatelessWidget {
  TextEditingController controller = TextEditingController();

  VeresiyeCardComponent({
    this.veresiyeData,
    this.onTapAction,
    this.onlongPressAction,
    Key key,
  }) : super(key: key);

  final VeresiyeModel veresiyeData;
  final Function(BuildContext context, VeresiyeModel noteData,
      TextEditingController controller) onTapAction;
  final Function(VeresiyeModel) onlongPressAction;

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('tr'); //bu satırı ekliyoruz
    String neatDate = DateFormat.yMMMd('tr').add_Hm().format(veresiyeData.date);
    Color color =
        colorList.elementAt(veresiyeData.title.length % colorList.length);
    return Container(
        margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
        height: 121,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [buildBoxShadow(color, context)],
        ),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          color: Theme.of(context).dialogBackgroundColor,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              onTapAction(context, veresiyeData, controller);
            },
            onLongPress: () {
              onlongPressAction(veresiyeData);
            },
            splashColor: color.withAlpha(20),
            highlightColor: color.withAlpha(10),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${veresiyeData.title.trim().length <= 20 ? veresiyeData.title.trim() : veresiyeData.title.trim().substring(0, 20) + '...'}',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.normal),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 6),
                    child: Text(
                      '${veresiyeData.content.trim().split('\n').first.length <= 30 ? veresiyeData.content.trim().split('\n').first + " ₺" : veresiyeData.content.trim().split('\n').first.substring(0, 30) + '...'}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 3),
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: <Widget>[
                        Spacer(),
                        Text(
                          '$neatDate',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade300,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            // onLongPress: () => CupertinoPageRoute(
            // builder: (context) =>
            //     EditVeresiyePage()),
          ),
        ));
  }

  BoxShadow buildBoxShadow(Color color, BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return BoxShadow(
          color: Colors.black.withAlpha(10),
          blurRadius: 8,
          offset: Offset(0, 8));
    }
    return BoxShadow(
        color: color.withAlpha(25), blurRadius: 8, offset: Offset(0, 8));
  }
}

class VeresiyeCardComponent2 extends StatelessWidget {
  TextEditingController controller = TextEditingController();

  VeresiyeCardComponent2({
    this.veresiyeData,
    this.onTapAction,
    Key key,
  }) : super(key: key);

  final VeresiyeModel veresiyeData;
  final Function(BuildContext context, VeresiyeModel noteData, double payment)
      onTapAction;

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('tr'); //bu satırı ekliyoruz
    String neatDate = DateFormat.yMMMd('tr').add_Hm().format(veresiyeData.date);
    Color color =
        colorList.elementAt(veresiyeData.title.length % colorList.length);
    return Container(
        margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
        height: 121,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [buildBoxShadow(color, context)],
        ),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          color: Theme.of(context).dialogBackgroundColor,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () async {
              ClipboardData data = await Clipboard.getData('text/plain');
              print("burada mı : ");
              print(double.parse(data.text));
              print("değil mi");
              onTapAction(context, veresiyeData, double.parse(data.text));
            },

            splashColor: color.withAlpha(20),
            highlightColor: color.withAlpha(10),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${veresiyeData.title.trim().length <= 20 ? veresiyeData.title.trim() : veresiyeData.title.trim().substring(0, 20) + '...'}',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.normal),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 6),
                    child: Text(
                      '${veresiyeData.content.trim().split('\n').first.length <= 30 ? veresiyeData.content.trim().split('\n').first + " ₺" : veresiyeData.content.trim().split('\n').first.substring(0, 30) + '...'}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 3),
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: <Widget>[
                        Spacer(),
                        Text(
                          '$neatDate',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade300,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            // onLongPress: () => CupertinoPageRoute(
            // builder: (context) =>
            //     EditVeresiyePage()),
          ),
        ));
  }

  BoxShadow buildBoxShadow(Color color, BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return BoxShadow(
          color: Colors.black.withAlpha(10),
          blurRadius: 8,
          offset: Offset(0, 8));
    }
    return BoxShadow(
        color: color.withAlpha(25), blurRadius: 8, offset: Offset(0, 8));
  }
}
