import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/data_service.dart';
import 'add_product_screen.dart';
import 'edit_product_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final DataService _dataService = DataService();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _dataService,
      builder: (context, _) {
        final products = _dataService.products;
        return Scaffold(
          appBar: AppBar(title: const Text('OUR COLLECTION')),
          body: products.isEmpty 
            ? const Center(child: Text('Your boutique is empty. Add some products!'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.softPink.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.style_outlined, color: AppColors.primaryPink),
                      ),
                      title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('Category: ${product.category}', style: const TextStyle(fontSize: 12)),
                          Text('Available: ${product.stock} units', style: TextStyle(fontSize: 12, color: product.stock < 5 ? Colors.red : Colors.grey)),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${AppConfig.currency} ${product.price.toStringAsFixed(0)}',
                            style: const TextStyle(color: AppColors.deepPink, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 20, color: Colors.blue),
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EditProductScreen(product: product))),
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, size: 20, color: Colors.red),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Delete Product'),
                                      content: Text('Are you sure you want to delete ${product.name}?'),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
                                        TextButton(
                                          onPressed: () {
                                            _dataService.deleteProduct(product.id);
                                            Navigator.pop(context);
                                          },
                                          child: const Text('DELETE', style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EditProductScreen(product: product))),
                    ),
                  );
                },
              ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AppColors.primaryPink,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProductScreen())),
            label: const Text('ADD PRODUCT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        );
      }
    );
  }
}
