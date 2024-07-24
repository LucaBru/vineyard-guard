import 'package:flutter/material.dart';
import 'package:vineyard_guard/domain/entity/quantity.dart';
import 'package:vineyard_guard/presentation/util.dart';

class AddPurchaseForm extends StatefulWidget {
  const AddPurchaseForm({super.key});

  @override
  AddPurchaseFormState createState() {
    return AddPurchaseFormState();
  }
}

class AddPurchaseFormState extends State<AddPurchaseForm> {
  late String _pesticide;
  late double _amount;
  UnitOfMeasure _unit = UnitOfMeasure.KG;
  late double _price;

  final _formKey = GlobalKey<FormState>();

  AddPurchaseFormState();

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
          title: const Text("Insert pesticide purchase"),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _pesticideNameTextField(),
              _priceTextField(),
              _amountTextField(),
              _unitOfMeasureRadioButton(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_cancelButton(), _addButton()],
                ),
              ),
            ],
          ),
        ),
      ));

  Widget _amountTextField() => TextFormField(
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Please enter a quantity' : null,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          icon: Icon(Icons.warehouse),
          labelText: 'Quantity',
        ),
        onSaved: (value) =>
            setState(() => _amount = double.parse(value!).roundToTwoDecimals()),
      );

  Widget _cancelButton() => ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Cancel'),
      );

  Widget _addButton() => ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState?.save();
            Navigator.pop(context, (
              pesticide: _pesticide,
              price: _price,
              unit: _unit,
              amount: _amount,
            ));
          }
        },
        child: const Text('Add'),
      );

  Widget _pesticideNameTextField() => TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.search),
        labelText: 'Pesticide name',
      ),
      validator: (value) =>
          (value == null || value.isEmpty) ? 'Please enter some name' : null,
      onSaved: (text) => _pesticide = text!);

  Widget _priceTextField() => TextFormField(
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Please enter a price' : null,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          icon: Icon(Icons.euro),
          labelText: 'Price',
        ),
        onSaved: (value) =>
            setState(() => _price = double.parse(value!).roundToTwoDecimals()),
      );

  Widget _unitOfMeasureRadioButton() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: UnitOfMeasure.values
          .map((unitOfMeasure) => Expanded(
                child: ListTile(
                  title: Text(unitOfMeasure.name),
                  leading: Radio<UnitOfMeasure>(
                    groupValue: _unit,
                    value: unitOfMeasure,
                    onChanged: (value) => setState(() {
                      _unit = value!;
                    }),
                  ),
                ),
              ))
          .toList());
}
