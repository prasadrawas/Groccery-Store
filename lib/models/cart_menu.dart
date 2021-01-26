import 'package:flutter/foundation.dart';

class CartMenu extends ChangeNotifier {
  static List<String> names = [];
  static List<int> price = [];
  static List<int> quant = [];
  static List<String> images = [];

  static updateCart(int p, String n, String img) {
    if (!names.contains(n)) {
      names.add(n);
      price.add(p);
      quant.add(1);
      images.add(img);
    } else {
      quant[names.indexOf(n)] = quant[names.indexOf(n)] + 1;
    }
  }

  static cartClear() {
    names = [];
    price = [];
    quant = [];
    images = [];
  }
}
