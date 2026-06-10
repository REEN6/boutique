import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/data_service.dart';
import '../../../core/models/product_model.dart';
import '../../../core/models/sale_model.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({super.key});

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  final DataService _dataService = DataService();
  final List<SaleItem> _cart = [];
  String _searchQuery = '';

  void _addToCart(Product product) {
    if (product.stock <= 0) {
      _showToast('Product out of stock!');
      return;
    }

    setState(() {
      int index = _cart.indexWhere((item) => item.product.id == product.id);
      if (index != -1) {
        if (_cart[index].quantity < product.stock) {
          _cart[index] = SaleItem(
            product: product,
            quantity: _cart[index].quantity + 1,
            priceAtSale: product.price,
          );
        } else {
          _showToast('Limit reached!');
        }
      } else {
        _cart.add(SaleItem(product: product, quantity: 1, priceAtSale: product.price));
      }
    });
  }

  void _showToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating));
  }

  double get _total => _cart.fold(0, (sum, item) => sum + item.total);

  void _completeSale() {
    if (_cart.isEmpty) return;

    final sale = Sale(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      items: List.from(_cart),
      totalAmount: _total,
    );

    _dataService.addSale(sale);
    setState(() => _cart.clear());
    _showToast('Sale recorded in Kshs!');
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _dataService,
      builder: (context, _) {
        final filteredProducts = _dataService.products.where((p) => 
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.category.toLowerCase().contains(_searchQuery.toLowerCase())
        ).toList();

        return Scaffold(
          appBar: AppBar(title: const Text('SHOP POS')),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primaryPink),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: filteredProducts.isEmpty 
                  ? const Center(child: Text('No matching items found.'))
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return _buildProductCard(product);
                      },
                    ),
              ),
              _buildCartPanel(),
            ],
          ),
        );
      }
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () => _addToCart(product),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.pink.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.softPink.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: const Icon(Icons.shopping_bag_outlined, size: 50, color: AppColors.primaryPink),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('${AppConfig.currency} ${product.price.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.deepPink, fontWeight: FontWeight.bold)),
                  Text('${product.stock} in stock', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartPanel() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_cart.isNotEmpty) ...[
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _cart.length,
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Chip(
                    backgroundColor: AppColors.softPink.withValues(alpha: 0.1),
                    deleteIconColor: AppColors.deepPink,
                    label: Text('${_cart[i].product.name} x${_cart[i].quantity}'),
                    onDeleted: () => setState(() => _cart.removeAt(i)),
                  ),
                ),
              ),
            ),
            const Divider(),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Amount', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text('${AppConfig.currency} ${_total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.deepPink)),
                ],
              ),
              ElevatedButton(
                onPressed: _cart.isEmpty ? null : _completeSale,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                child: const Text('CHECKOUT', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
