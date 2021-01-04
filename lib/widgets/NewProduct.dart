import 'package:flutter/material.dart';

class NewProduct extends StatefulWidget {
  final Function addTx;

  NewProduct(this.addTx);

  @override
  _NewProductState createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _nameController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0) {
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
              decoration: InputDecoration(labelText: 'Fiyatı'),
              controller: _amountController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _submitData(),
              // onChanged: (val) => amountInput = val,
            ),
            FlatButton(
              child: Text(
                'Ürün Ekle',
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
