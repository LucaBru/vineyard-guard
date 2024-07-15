import 'package:vineyard_guard/domain/entity/purchase.dart';
import 'package:vineyard_guard/domain/entity/stocked_pesticide.dart';
import 'package:vineyard_guard/domain/entity/treatment.dart';
import 'package:vineyard_guard/domain/use_case/purchase_uc.dart';
import 'package:vineyard_guard/domain/use_case/treatment_uc.dart';

class WarehouseUseCase {
  Future<List<StockedPesticide>> stockedPesticides() async {
    List<Treatment> treatments = await TreatmentUseCase().treatments();
    List<Purchase> purchases = await PurchaseUseCase().purchases();

    Map<String, StockedPesticide> stocks = Map.fromEntries(purchases.map(
        (purchase) => MapEntry(
            purchase.pesticide,
            StockedPesticide(
                purchase.pesticide, 0, 0, purchase.quantity.unit))));

    for (var purchase in purchases) {
      stocks[purchase.pesticide]?.purchased += purchase.quantity.value;
    }

    for (var treatment in treatments) {
      treatment.pesticides.forEach(
          (pesticide, quantity) => stocks[pesticide]?.used += quantity.value);
    }

    return stocks.values.toList();
  }
}
