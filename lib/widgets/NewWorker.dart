import 'package:flutter/material.dart';

class NewWorker extends StatefulWidget {
  final Function addWr;

  NewWorker(this.addWr);

  @override
  _NewWorkerState createState() => _NewWorkerState();
}

class _NewWorkerState extends State<NewWorker> {
  final _nameController = TextEditingController();
  final _mailController = TextEditingController();

  void _submitData() {
    final enteredTitle = _nameController.text;
    final enteredMail = _mailController.text;
    final enteredJob = _value;

    if (enteredTitle.isEmpty ||
        enteredMail.isEmpty ||
        !enteredMail.contains('@') ||
        !enteredMail.contains('.com')) {
      return;
    }

    widget.addWr(
      enteredTitle,
      enteredMail,
      enteredJob,
    );

    Navigator.of(context).pop();
  }

  String _value = "Yönetici";

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Ad'),
              controller: _nameController,
              onSubmitted: (_) => _submitData(),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Mail'),
              controller: _mailController,
              onSubmitted: (_) => _submitData(),
            ),
            DropdownButton<String>(
                iconSize: 34,
                value: _value,
                onChanged: (String newValue) {
                  setState(() {
                    _value = newValue;
                  });
                },
                items: <String>['Yönetici', 'Tezgahtar', 'Şoför']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList()),
            FlatButton(
              child: Text(
                'Çalışan Ekle',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              textColor: Colors.blueGrey,
              onPressed: () => _submitData(),
            ),
          ],
        ),
      ),
    );
  }
}
