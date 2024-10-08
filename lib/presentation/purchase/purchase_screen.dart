import 'package:flutter/material.dart';
import 'package:vineyard_guard/domain/entity/purchase.dart';
import 'package:vineyard_guard/domain/entity/quantity.dart';
import 'package:vineyard_guard/domain/use_case/purchase_uc.dart';
import 'package:vineyard_guard/presentation/empty_list_widget.dart';
import 'package:vineyard_guard/presentation/error_widget.dart';
import 'package:vineyard_guard/presentation/purchase/add_purchase_form.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  final PurchaseUseCase _useCase = PurchaseUseCase();
  late Future<List<Purchase>> _request;
  late List<Purchase> _purchases;

  @override
  void initState() {
    super.initState();
    _request = _fetchPurchases();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Pesticide purchases"),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add pesticide purchase',
          onPressed: _purchasePesticide,
          child: const Icon(Icons.add),
        ),
        body: _futureWidget(context),
      );

  Future<List<Purchase>> _fetchPurchases() => _useCase.purchases();

  void _purchasePesticide() async {
    PurchaseRequest request = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddPurchaseForm(),
        ));

    Purchase p = Purchase.autogenerateId(request.pesticide,
        Quantity(request.amount, request.unit), request.price);
    _useCase.add(p);
    setState(() {
      _purchases.insert(0, p);
    });
  }

  Widget _futureWidget(BuildContext context) => FutureBuilder(
      future: _request,
      builder: (context, snapshot) => switch (snapshot.connectionState) {
            ConnectionState.waiting => const Center(
                child: CircularProgressIndicator(),
              ),
            ConnectionState.done => _successfulRequest(snapshot, context),
            _ => const CustomErrorWidget(
                'Error while retrieving pesticide purchases')
          });

  Widget _successfulRequest(
      AsyncSnapshot<List<Purchase>> snapshot, BuildContext context) {
    _purchases = snapshot.data ?? [];
    return switch ((_purchases, snapshot.hasError)) {
      ([], false) => const EmptyListWidget('pesticide purchase'),
      (_, false) => Padding(
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
          child: Semantics(
            label: 'List of pesticide purchases',
            child: ListView.builder(
              itemCount: _purchases.length,
              itemBuilder: (context, index) => Dismissible(
                  background: Container(
                    color: Colors.red,
                  ),
                  key: ValueKey(_purchases[index].id),
                  onDismissed: (_) {
                    _useCase.remove(_purchases[index].id);
                    setState(() {
                      _purchases.removeAt(index);
                    });
                  },
                  child: _purchaseCard(_purchases[index])),
            ),
          ),
        ),
      (_, true) =>
        const CustomErrorWidget('Error while retrieving pesticide purchases')
    };
  }

  Widget _purchaseCard(Purchase purchase) => Card.filled(
          child: ListTile(
        leading: const Icon(Icons.medication),
        title: Text(
          purchase.pesticide,
          semanticsLabel: 'Purchase of pesticide ${purchase.pesticide}',
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quantity: ${purchase.quantity.value} ${purchase.quantity.unit.name}',
              semanticsLabel:
                  'Purchased ${purchase.quantity.value} ${purchase.quantity.unit == UnitOfMeasure.KG ? 'kilograms' : 'liters'}',
            ),
            Text(
              'Price: ${purchase.price} €',
              semanticsLabel: 'at price ${purchase.price} €',
            ),
          ],
        ),
      ));
}

typedef PurchaseRequest = ({
  String pesticide,
  double amount,
  UnitOfMeasure unit,
  double price,
});
