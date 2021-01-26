import 'package:flutter/foundation.dart';

class Cart extends ChangeNotifier {
  int itemCount = 0;
  int price = 0;
  List<String> names = [];
  List<int> prices = [];
  List<int> quant = [];

  updateCart(int p, String n) {
    itemCount++;
    price += p;
    if (!names.contains(n)) {
      names.add(n);
      prices.add(p);
      quant.add(1);
    } else {
      quant[names.indexOf(n)] = quant[names.indexOf(n)] + 1;
    }

    notifyListeners();
  }

  degradeCart(int p) {
    itemCount--;
    price -= p;
    notifyListeners();
  }
}
