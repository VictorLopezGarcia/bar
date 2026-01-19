import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/products_data.dart';

class ProductSelectionViewModel extends ChangeNotifier {
  final List<Product> menu = ProductsData.availableProducts;
  final Map<String, int> _quantities = {};

  List<Product> get availableProducts => menu;
  Map<String, int> get selectedProducts => Map.from(_quantities);

  bool isProductSelected(String productId) =>
      _quantities.containsKey(productId);

  int getQuantity(String productId) => _quantities[productId] ?? 0;

  void incrementQuantity(String productId) {
    final current = _quantities[productId] ?? 0;
    _quantities[productId] = current + 1;
    notifyListeners();
  }

  void decrementQuantity(String productId) {
    if (!_quantities.containsKey(productId)) return;

    final current = _quantities[productId]!;
    if (current > 1) {
      _quantities[productId] = current - 1;
    } else {
      _quantities.remove(productId);
    }
    notifyListeners();
  }

  Map<Product, int> getSelectedProducts() {
    final result = <Product, int>{};
    for (var entry in _quantities.entries) {
      final product = menu.firstWhere((p) => p.id == entry.key);
      result[product] = entry.value;
    }
    return result;
  }

  void clearSelection() {
    _quantities.clear();
    notifyListeners();
  }

  void loadFromExisting(Map<Product, int> products) {
    _quantities.clear();
    for (var entry in products.entries) {
      _quantities[entry.key.id] = entry.value;
    }
    notifyListeners();
  }

  bool get hasSelection => _quantities.isNotEmpty;

  int get totalSelectedItems =>
      _quantities.isEmpty ? 0 : _quantities.values.reduce((a, b) => a + b);
}
