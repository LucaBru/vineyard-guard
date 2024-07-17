// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vineyard_guard/domain/entity/quantity.dart';
import 'package:vineyard_guard/domain/entity/stocked_pesticide.dart';
import 'package:vineyard_guard/domain/use_case/warehouse_uc.dart';
import 'package:vineyard_guard/presentation/error_widget.dart';
import 'package:vineyard_guard/presentation/util.dart';

class AddTreatmentForm extends StatefulWidget {
  const AddTreatmentForm({
    super.key,
  });

  @override
  AddTreatmentFormState createState() {
    return AddTreatmentFormState();
  }
}

class AddTreatmentFormState extends State<AddTreatmentForm> {
  final _formKey = GlobalKey<FormState>();
  late _AddPesticideForm _addPesticideForm;
  final TextEditingController _dateController = TextEditingController();
  final _dateFormatter = DateFormat("EEEE, d MMM, yyyy");

  AddTreatmentFormState() {
    _dateController.text = _dateFormatter.format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text("Insert treatment")),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                _dateFormField(context),
                _addPesticideForm = _AddPesticideForm(),
                _buttons(context),
              ],
            ),
          ),
        ),
      ));

  Widget _buttons(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Map<String, Quantity> pesticides =
                    _addPesticideForm._pesticidesUsed;
                if (pesticides.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Treatment must use at least one pesticide!'),
                    backgroundColor: Colors.red,
                  ));
                } else {
                  Navigator.pop(context, (
                    date: DateTime.parse(_dateController.text),
                    pesticides: pesticides
                  ));
                }
              }
            },
            child: const Text('Add'),
          )
        ],
      );

  TextFormField _dateFormField(BuildContext context) => TextFormField(
      controller: _dateController,
      readOnly: true,
      validator: (value) =>
          (value == null || value.isEmpty) ? 'Please enter a date' : null,
      decoration: const InputDecoration(
        icon: Icon(Icons.calendar_today),
        labelText: 'Selected Date',
      ),
      onTap: () => _datePicker(context));

  void _datePicker(BuildContext context) async {
    DateTime date = await showDatePicker(
            context: context,
            firstDate: DateTime(DateTime.now().year),
            lastDate: DateTime.now()) ??
        DateTime.now();
    setState(() {
      _dateController.text = _dateFormatter.format(date);
    });
  }
}

class _AddPesticideForm extends StatefulWidget {
  final Map<String, Quantity> _pesticidesUsed = {};

  _AddPesticideForm();

  Map<String, Quantity> get pesticidesUsed => _pesticidesUsed;

  @override
  State<StatefulWidget> createState() => _AddPesticideFormState();
}

class _AddPesticideFormState extends State<_AddPesticideForm> {
  final _formKey = GlobalKey<FormState>();

  late Future<List<StockedPesticide>> _request;
  late List<StockedPesticide> _stocks;

  StockedPesticide? _pesticideSelected;
  Quantity? _quantity;

  @override
  void initState() {
    super.initState();
    _request = WarehouseUseCase().stockedPesticides();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: _request,
      builder: (context, snapshot) => switch (snapshot.connectionState) {
            ConnectionState.waiting => const Text(''),
            ConnectionState.done => _successfulRequest(snapshot, context),
            _ => const CustomErrorWidget()
          });

  _successfulRequest(AsyncSnapshot snapshot, BuildContext context) {
    _stocks = snapshot.data ?? [];
    return Form(
        key: _formKey,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: Divider(),
            ),
            _stocksDropdownMenu(),
            _amountFormField(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: _insertButton(),
            ),
            _pesticidesUsedList(),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Divider(),
            ),
          ],
        ));
  }

  _stocksDropdownMenu() => DropdownSearch<StockedPesticide>(
      validator: (value) =>
          (value == null) ? 'Please select a pesticide' : null,
      items: _stocks,
      itemAsString: (item) => item.pesticide,
      filterFn: (stock, filter) =>
          stock.pesticide.toLowerCase().contains(filter.toLowerCase()),
      dropdownDecoratorProps: const DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
              icon: Icon(Icons.warehouse), labelText: 'Select pesticide')),
      popupProps: const PopupProps.menu(
        showSearchBox: true,
      ),
      onChanged: (selected) {
        if (selected != null) _pesticideSelected = selected;
      });

  _amountFormField() => TextFormField(
      validator: (value) {
        if (value == null || _pesticideSelected == null || value.isEmpty)
          return 'Please provide an amount';
        double amount = double.parse(value);
        final double maxAvailable = _pesticideSelected!.available;
        if (amount <= 0) return 'Please provide an amount greater than 0';
        return (amount <= maxAvailable)
            ? null
            : 'Please provide an amount up to $maxAvailable';
      },
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        icon: Icon(Icons.production_quantity_limits),
        labelText: 'Quantity',
      ),
      onSaved: (value) => {
            if (_pesticideSelected != null)
              {
                _quantity = Quantity(double.parse(value!).roundToTwoDecimals(),
                    _pesticideSelected!.unit)
              }
          });

  _insertButton() => ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            if (widget._pesticidesUsed
                .containsKey(_pesticideSelected?.pesticide)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                      Text('Cannot insert multiple times the same pesticide!'),
                  backgroundColor: Colors.red,
                ),
              );
            } else {
              if (_pesticideSelected != null && _quantity != null) {
                setState(() {
                  widget._pesticidesUsed[_pesticideSelected!.pesticide] =
                      _quantity as Quantity;
                });
              }
            }
          }
        },
        child: const Text('Add pesticide to treatment'),
      );

  _pesticidesUsedList() => Column(
      children: widget._pesticidesUsed.entries
          .map((entry) => Dismissible(
                key: UniqueKey(),
                background: Container(
                  color: Colors.red,
                ),
                onDismissed: (direction) {
                  setState(() {
                    widget._pesticidesUsed.remove(entry.key);
                  });
                },
                child: Card(
                  child: ListTile(
                    title: Text(
                        '${entry.key} ${entry.value.value} ${entry.value.unit.name}'),
                  ),
                ),
              ))
          .toList());
}
