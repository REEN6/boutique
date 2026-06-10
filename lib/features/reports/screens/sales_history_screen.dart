import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/data_service.dart';

class SalesHistoryScreen extends StatelessWidget {
  const SalesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataService = DataService();
    return ListenableBuilder(
      listenable: dataService,
      builder: (context, _) {
        final sales = dataService.sales.reversed.toList();
        return Scaffold(
          appBar: AppBar(title: const Text('SALES HISTORY')),
          body: sales.isEmpty
              ? const Center(child: Text('No sales recorded yet.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sales.length,
                  itemBuilder: (context, index) {
                    final sale = sales[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ExpansionTile(
                        leading: const CircleAvatar(
                          backgroundColor: AppColors.softPink,
                          child: Icon(Icons.receipt_long_rounded, color: Colors.white, size: 20),
                        ),
                        title: Text('Invoice #${sale.id.substring(sale.id.length - 6)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${sale.date.toString().substring(0, 16)}'),
                        trailing: Text(
                          '${AppConfig.currency} ${sale.totalAmount.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.deepPink),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
                                ...sale.items.map((item) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('${item.product.name} x${item.quantity}'),
                                          Text('${AppConfig.currency} ${(item.priceAtSale * item.quantity).toStringAsFixed(0)}'),
                                        ],
                                      ),
                                    )),
                                const Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text('${AppConfig.currency} ${sale.totalAmount.toStringAsFixed(0)}',
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.deepPink)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
