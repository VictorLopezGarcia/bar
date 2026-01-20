import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/order.dart';

/// ViewModel para la creación de un nuevo pedido.
/// Gestiona el estado del formulario de creación, incluyendo el número de mesa y los productos seleccionados.
class CreateOrderViewModel extends ChangeNotifier {
  String _tableIdentifier = ''; // Almacena el identificador de la mesa
  final Map<Product, int> _cartItems =
      {}; // Almacena los productos seleccionados y sus cantidades

  String get tableNumber => _tableIdentifier;
  Map<Product, int> get selectedProducts => Map.from(_cartItems);

  /// Calcula el precio total de los productos en el "carrito".
  double get totalPrice {
    if (_cartItems.isEmpty) return 0.0;
    return _cartItems.entries
        .map((e) => e.key.price * e.value)
        .reduce((sum, price) => sum + price);
  }

  int get productCount =>
      _cartItems.length; // Número de tipos de productos distintos

  /// Calcula la cantidad total de unidades de productos seleccionados.
  int get totalItems =>
      _cartItems.isEmpty ? 0 : _cartItems.values.reduce((a, b) => a + b);

  void updateTableNumber(String value) {
    _tableIdentifier = value;
    notifyListeners();
  }

  /// Actualiza la lista de productos seleccionados y notifica a los oyentes.
  /// Reemplaza la selección actual con los nuevos productos.
  void updateProducts(Map<Product, int> products) {
    _cartItems.clear();
    _cartItems.addAll(products);
    notifyListeners();
  }

  /// Valida si el pedido es correcto para ser creado.
  /// Requiere que se haya asignado una mesa y que haya al menos un producto.
  bool validate() {
    return _tableIdentifier.trim().isNotEmpty && _cartItems.isNotEmpty;
  }

  /// Crea y devuelve una instacia de [Order] con los datos actuales.
  Order createOrder() {
    return Order(
      tableNumber: _tableIdentifier.trim(),
      products: Map.from(_cartItems),
      createdAt: DateTime.now(),
    );
  }
}
