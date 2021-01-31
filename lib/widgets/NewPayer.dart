import 'package:flutter/material.dart';

class NewPayer extends StatefulWidget {
  final Function addTx;

  NewPayer(this.addTx);

  @override
  _NewPayerState createState() => _NewPayerState();
}

class _NewPayerState extends State<NewPayer> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _nameController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount < 0) {
      return;
    }

    widget.addTx(
      enteredTitle,
      enteredAmount,
    );

    Navigator.of(context).pop();
  }

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
              decoration: InputDecoration(labelText: 'Adı'),
              controller: _nameController,
              onSubmitted: (_) => _submitData(),
              // onChanged: (val) {
              //   titleInput = val;
              // },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Borcu'),
              controller: _amountController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _submitData(),
            ),
            FlatButton(
              child: Text(
                'Veresiye Ekle',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
