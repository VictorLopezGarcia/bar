import 'package:flutter/material.dart';
import '../models/order.dart';
import '../data/products_data.dart';

/// ViewModel para gestionar la lista de pedidos activos.
/// Mantiene el estado de los pedidos y ofrece métodos para añadir nuevos y consultar información.
class OrdersViewModel extends ChangeNotifier {
  final List<Order> _activeOrders =
      ProductsData.initialOrders; // Lista interna de pedidos

  /// Devuelve una lista inmutable de los pedidos actuales.
  List<Order> get orders => List.unmodifiable(_activeOrders);

  /// Registra un nuevo pedido en el sistema, lo añade al principio de la lista y notifica a los oyentes.
  void registerNewOrder(Order order) {
    _activeOrders.insert(0, order);
    notifyListeners();
  }

  int get totalOrders =>
      _activeOrders.length; // Cantidad total de pedidos activos

  /// Comprueba si ya existe un pedido activo para una mesa determinada.
  /// Esto evita duplicar pedidos para la misma mesa simultáneamente.
  bool tableAlreadyExists(String tableNumber) {
    return _activeOrders.any(
      (o) => o.tableNumber.toLowerCase() == tableNumber.toLowerCase(),
    );
  }

  /// Calcula los ingresos totales sumando el precio total de todos los pedidos activos.
  double get totalRevenue => _activeOrders.isEmpty
      ? 0.0
      : _activeOrders.map((o) => o.totalPrice).reduce((a, b) => a + b);
}
