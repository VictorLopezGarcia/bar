import 'package:flutter/material.dart';
import '../models/order.dart';
import '../data/products_data.dart';

class OrdersViewModel extends ChangeNotifier {
  final List<Order> _activeOrders = ProductsData.initialOrders;

  List<Order> get orders => List.unmodifiable(_activeOrders);

  void registerNewOrder(Order order) {
    _activeOrders.insert(0, order);
    notifyListeners();
  }

  int get totalOrders => _activeOrders.length;

  bool tableAlreadyExists(String tableNumber) {
    return _activeOrders.any(
      (o) => o.tableNumber.toLowerCase() == tableNumber.toLowerCase(),
    );
  }

  double get totalRevenue => _activeOrders.isEmpty
      ? 0.0
      : _activeOrders.map((o) => o.totalPrice).reduce((a, b) => a + b);
}
