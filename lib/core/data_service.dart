import 'package:flutter/material.dart';
import 'models/product_model.dart';
import 'models/customer_model.dart';
import 'models/sale_model.dart';

class DataService extends ChangeNotifier {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal() {
    // Initial dummy data in Kshs
    _products.addAll([
      Product(id: '1', name: 'Silk Saree', category: 'Traditional', price: 15000.0, stock: 10),
      Product(id: '2', name: 'Cotton Kurta', category: 'Casual', price: 4500.0, stock: 25),
      Product(id: '3', name: 'Evening Gown', category: 'Formal', price: 29900.0, stock: 5),
      Product(id: '4', name: 'Designer Lehenga', category: 'Bridal', price: 89900.0, stock: 2),
      Product(id: '5', name: 'Floral Summer Dress', category: 'Dresses', price: 3500.0, stock: 15),
      Product(id: '6', name: 'High Heels - Rose Gold', category: 'Shoes', price: 7500.0, stock: 8),
    ]);

    _customers.addAll([
      Customer(id: '1', name: 'Jane Doe', email: 'jane@example.com', phone: '0712345678'),
      Customer(id: '2', name: 'Alice Smith', email: 'alice@example.com', phone: '0787654321'),
    ]);
  }

  final List<Product> _products = [];
  final List<Customer> _customers = [];
  final List<Sale> _sales = [];

  List<Product> get products => List.unmodifiable(_products);
  List<Customer> get customers => List.unmodifiable(_customers);
  List<Sale> get sales => List.unmodifiable(_sales);

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void updateProduct(Product product) {
    int index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void addCustomer(Customer customer) {
    _customers.add(customer);
    notifyListeners();
  }

  void addSale(Sale sale) {
    _sales.add(sale);
    // Update stock
    for (var item in sale.items) {
      int index = _products.indexWhere((p) => p.id == item.product.id);
      if (index != -1) {
        _products[index].stock -= item.quantity;
      }
    }
    notifyListeners();
  }

  double get todaySalesAmount {
    DateTime now = DateTime.now();
    return _sales
        .where((s) => s.date.day == now.day && s.date.month == now.month && s.date.year == now.year)
        .fold(0.0, (sum, s) => sum + s.totalAmount);
  }

  double get monthlyRevenue {
    DateTime now = DateTime.now();
    return _sales
        .where((s) => s.date.month == now.month && s.date.year == now.year)
        .fold(0.0, (sum, s) => sum + s.totalAmount);
  }

  int get lowStockCount => _products.where((p) => p.stock < 5).length;
}
