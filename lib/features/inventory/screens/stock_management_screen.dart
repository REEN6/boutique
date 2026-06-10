import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/data_service.dart';

class StockManagementScreen extends StatefulWidget {
  const StockManagementScreen({super.key});

  @override
  State<StockManagementScreen> createState() => _StockManagementScreenState();
}

class _StockManagementScreenState extends State<StockManagementScreen> {
  final DataService _dataService = DataService();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _dataService,
      builder: (context, _) {
        final products = _dataService.products;
        final lowStockProducts = products.where((p) => p.stock < 5).toList();
        final totalInventoryValue = products.fold(0.0, (sum, p) => sum + (p.price * p.stock));

        return Scaffold(
          appBar: AppBar(title: const Text('STOCK CONTROL')),
          body: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.primaryPink, AppColors.deepPink]),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [BoxShadow(color: AppColors.primaryPink.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statItem('Items', '${products.length}', Colors.white),
                    _statItem('Low Stock', '${lowStockProducts.length}', Colors.white),
                    _statItem('Value', '${AppConfig.currency} ${(totalInventoryValue / 1000).toStringAsFixed(1)}k', Colors.white),
                  ],
                ),
              ),
              Expanded(
                child: products.isEmpty 
                  ? const Center(child: Text('No products found.'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        bool isLow = product.stock < 5;
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: isLow ? Colors.red.withValues(alpha: 0.3) : Colors.pink.withValues(alpha: 0.1)),
                          ),
                          child: ListTile(
                            title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('Category: ${product.category}', style: const TextStyle(fontSize: 12)),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${product.stock} units',
                                  style: TextStyle(
                                    color: isLow ? Colors.red : AppColors.deepPink,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                if (isLow) const Text('Restock now!', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            onTap: () => _showAdjustStockDialog(context, product),
                          ),
                        );
                      },
                    ),
              ),
            ],
          ),
        );
      }
    );
  }

  void _showAdjustStockDialog(BuildContext context, product) {
    final TextEditingController controller = TextEditingController(text: product.stock.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Adjust Stock: ${product.name}'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'New Stock Level'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () {
              int? newStock = int.tryParse(controller.text);
              if (newStock != null) {
                product.stock = newStock;
                _dataService.updateProduct(product);
              }
              Navigator.pop(context);
            },
            child: const Text('UPDATE'),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 11, color: color.withValues(alpha: 0.8), letterSpacing: 1)),
      ],
    );
  }
}
