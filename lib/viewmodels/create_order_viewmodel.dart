import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/order.dart';

class CreateOrderViewModel extends ChangeNotifier {
  String _tableIdentifier = '';
  final Map<Product, int> _cartItems = {};

  String get tableNumber => _tableIdentifier;
  Map<Product, int> get selectedProducts => Map.from(_cartItems);

  double get totalPrice {
    if (_cartItems.isEmpty) return 0.0;
    return _cartItems.entries
        .map((e) => e.key.price * e.value)
        .reduce((sum, price) => sum + price);
  }

  int get productCount => _cartItems.length;

  int get totalItems =>
      _cartItems.isEmpty ? 0 : _cartItems.values.reduce((a, b) => a + b);

  void updateTableNumber(String value) {
    _tableIdentifier = value;
    notifyListeners();
  }

  void updateProducts(Map<Product, int> products) {
    _cartItems.clear();
    _cartItems.addAll(products);
    notifyListeners();
  }

  bool validate() {
    return _tableIdentifier.trim().isNotEmpty && _cartItems.isNotEmpty;
  }

  Order createOrder() {
    return Order(
      tableNumber: _tableIdentifier.trim(),
      products: Map.from(_cartItems),
      createdAt: DateTime.now(),
    );
  }
}
