import 'product_model.dart';

class SaleItem {
  final Product product;
  final int quantity;
  final double priceAtSale;

  SaleItem({
    required this.product,
    required this.quantity,
    required this.priceAtSale,
  });

  double get total => quantity * priceAtSale;
}

class Sale {
  final String id;
  final DateTime date;
  final List<SaleItem> items;
  final String? customerId;
  final double totalAmount;

  Sale({
    required this.id,
    required this.date,
    required this.items,
    this.customerId,
    required this.totalAmount,
  });
}
