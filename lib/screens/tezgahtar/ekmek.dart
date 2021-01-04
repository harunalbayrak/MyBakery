import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_my_bakery/models/models.dart';
import 'package:flutter_my_bakery/shared/cards.dart';
import 'package:flutter_my_bakery/services/crud.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_my_bakery/shared/constants.dart';
import 'package:flutter_my_bakery/screens/tezgahtar/field_test.dart';

class Ekmek extends StatefulWidget {
  Ekmek({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _EkmekState createState() => new _EkmekState();
}

class _EkmekState extends State<Ekmek> {
  bool isFlagOn = false;
  bool headerShouldHide = false;
  final TextEditingController _textFieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final DateFormat formatter2 = DateFormat('yyyy-MM-dd - kk:mm');
  List<EkmekModel> ekmekList = [];
  GlobalKey<FormState> _key = new GlobalKey();


  DatabaseService service = DatabaseService();
  bool isSearchEmpty = true;

  @override
  void initState() {
    super.initState();
    // NotesDatabaseService.db.init();
    setEkmekFromDB();
  }

  setEkmekFromDB() async {
    ekmekList.clear();
    print("Entered setEkmek");
    service.dailyDataReference
        .child(formatter.format(DateTime.now()))
        .child("producedBreads")
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> map = snapshot.value;
      if (map != null) {
        map.forEach((key, values) {
          print(values);
          print("data: " +
              values["title"] +
              "--------------------------------------");
          setState(() {
            ekmekList.add(EkmekModel.withID(
                values["title"], values["time"], values["_id"]));
          });
        });
      } else {
        setState(() {
          ekmekList.clear();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Ekmek Gir',
          style: TextStyle(fontFamily: "Poppins"),
        ),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Container(height: 32),
              ...buildEkmekComponentsList(), // burası düzeltilecek
            ],
          ),
          margin: EdgeInsets.only(top: 2),
          padding: EdgeInsets.only(left: 15, right: 15),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Theme.of(context).primaryColor,
          label: Text('Ekmek Ekle'.toUpperCase()),
          icon: Icon(Icons.add),
          onPressed: () {
            ekmekPopup(context, EkmekModel(), _textFieldController);
          }
          ),
    );
  }

  Widget buildHeaderWidget(BuildContext context) {
    return Row(
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn,
          margin: EdgeInsets.only(top: 8, bottom: 32, left: 10),
          width: headerShouldHide ? 0 : 200,
          child: Text(
            'Ekmekler2',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 36,
                color: Theme.of(context).primaryColor),
            overflow: TextOverflow.clip,
            softWrap: false,
          ),
        ),
      ],
    );
  }

  ekmekPopup(BuildContext dialogContext, EkmekModel ekmek,
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
        title: "Çıkan ekmek tutarını giriniz.",
        content: Form(
          key : _key,
          child: Column(
          children: [
            SizedBox(
              height: sizeW,
            ),
            SizedBox(
              height: sizeW,
            ),
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: textStyle1,
              decoration: textInputDecoration.copyWith(
                  // labelText: ,
                  ),
              validator: fieldTest.veresiyeContentValidator
            ),
          ],
        ),),
        buttons: [
          DialogButton(
            child: Text(
              "Kaydet",
              style: TextStyle(color: Colors.white, fontSize: sizeW),
            ),
            onPressed: () {
              if(_key.currentState.validate()){
                setState(() {
                  if (int.parse(controller.value.text) > 0) {
                    ekmek.amount = (int.parse(controller.value.text)).toString();
                    ekmek.time = formatter2.format(DateTime.now());
                    service.addEkmek(ekmek.id, ekmek.toMap());
                  }
                });
              Navigator.pop(context);
              controller.clear();
              setEkmekFromDB();
              }
            },
            color: Colors.green,
          ),
        ]).show();
  }

  _showDialog(EkmekModel ekmek) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return new AlertDialog(actions: <Widget>[
              new FlatButton(
                  child: new Text('Vazgeç'),
                  onPressed: () => Navigator.of(context).pop()),
              new FlatButton(
                  child: new Text('Sil'),
                  onPressed: () {
                    service.deleteEkmek(ekmek.id);
                    Navigator.of(context).pop();
                    setEkmekFromDB();
                  })
            ]);
          });
    });
  }

  List<Widget> buildEkmekComponentsList() {
    List<Widget> ekmekComponentsList = [];
    ekmekList.sort((a, b) {
      return b.time.compareTo(a.time);
    });
    ekmekList.forEach((note) {
      ekmekComponentsList.add(EkmekCardComponent(
        ekmekData: note,
        onTapAction: (_) => _showDialog(note),
      ));
    });
    return ekmekComponentsList;
  }
}
