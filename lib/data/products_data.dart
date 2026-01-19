import 'package:bar/models/order.dart';
import 'package:bar/models/product.dart';

class ProductsData {
  static final List<Product> availableProducts = [
    Product(id: '1', name: 'Risotto de Trufa Negra', price: 28.50),
    Product(id: '2', name: 'Carpaccio de Wagyu', price: 32.00),
    Product(id: '3', name: 'Langosta a la Parrilla', price: 58.00),
    Product(id: '4', name: 'Solomillo Wellington', price: 48.00),
    Product(id: '5', name: 'Ostras Frescas (6 uds)', price: 36.00),
    Product(id: '6', name: 'Caviar Beluga 30g', price: 120.00),
    Product(id: '7', name: 'Tarta de Chocolate Belga', price: 12.50),
    Product(id: '8', name: 'Vino Gran Reserva Rioja', price: 45.00),
    Product(id: '9', name: 'Champagne Dom Pérignon', price: 180.00),
    Product(id: '10', name: 'Gin Tonic Premium', price: 15.00),
    Product(id: '11', name: 'Cóctel Negroni', price: 14.00),
    Product(id: '12', name: 'Whisky Single Malt 18 años', price: 25.00),
  ];

  static final List<Order> initialOrders = [
    Order(
      tableNumber: '1',
      products: {availableProducts[0]: 2, availableProducts[7]: 1},
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    Order(
      tableNumber: '2',
      products: {
        availableProducts[1]: 1,
        availableProducts[2]: 2,
        availableProducts[10]: 3,
      },
      createdAt: DateTime.now().subtract(const Duration(minutes: 8)),
    ),
    Order(
      tableNumber: '3',
      products: {availableProducts[5]: 1, availableProducts[8]: 2},
      createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
    ),
  ];
}
