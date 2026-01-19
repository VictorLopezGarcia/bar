import 'product.dart';

class Order {
  final String tableNumber;
  final Map<Product, int> products;
  final DateTime createdAt;

  Order({
    required this.tableNumber,
    required this.products,
    required this.createdAt,
  });

  double get totalPrice {
    return products.entries
        .map((entry) => entry.key.price * entry.value)
        .reduce((a, b) => a + b);
  }

  int get totalItems => products.values.reduce((a, b) => a + b);
}
