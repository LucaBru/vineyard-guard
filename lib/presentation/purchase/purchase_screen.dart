import 'package:flutter/material.dart';
import 'package:vineyard_guard/domain/entity/purchase.dart';
import 'package:vineyard_guard/domain/entity/quantity.dart';
import 'package:vineyard_guard/domain/use_case/purchase_uc.dart';
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
        appBar: AppBar(title: const Text("Pesticide purchases")),
        floatingActionButton: FloatingActionButton(
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
            ConnectionState.waiting => const Text(''),
            ConnectionState.done => _successfulRequest(snapshot, context),
            _ => const CustomErrorWidget()
          });

  Widget _successfulRequest(
      AsyncSnapshot<List<Purchase>> snapshot, BuildContext context) {
    _purchases = snapshot.data ?? [];
    return ListView.builder(
      itemCount: _purchases.length,
      itemBuilder: (context, index) => Dismissible(
          background: Container(
            color: Colors.red,
          ),
          key: ValueKey(_purchases[index].id),
          onDismissed: (_) {
            setState(() {
              _purchases.removeAt(index);
            });
            _useCase.remove(_purchases[index].id);
          },
          child: _purchaseCard(_purchases[index])),
    );
  }

  Widget _purchaseCard(Purchase purchase) => Card(
          child: ListTile(
        title: Text(purchase.pesticide),
        subtitle: Text(
            'Quantity: ${purchase.quantity.value} ${purchase.quantity.unit.name}, Price: ${purchase.price}'),
      ));
}

typedef PurchaseRequest = ({
  String pesticide,
  double amount,
  UnitOfMeasure unit,
  double price,
});
