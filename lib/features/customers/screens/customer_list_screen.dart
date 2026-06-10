import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/data_service.dart';
import '../../../core/models/customer_model.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final DataService _dataService = DataService();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _dataService,
      builder: (context, _) {
        final customers = _dataService.customers.where((c) => 
          c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.phone.contains(_searchQuery)
        ).toList();
        return Scaffold(
          appBar: AppBar(
            title: const Text('CLIENTELE'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Search by name or phone...',
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primaryPink),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  ),
                ),
              ),
            ),
          ),
          body: customers.isEmpty 
            ? const Center(child: Text('No customers registered yet.'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: customers.length,
                itemBuilder: (context, index) {
                  final customer = customers[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.softPink.withValues(alpha: 0.2),
                        child: const Icon(Icons.person_outline_rounded, color: AppColors.primaryPink),
                      ),
                      title: Text(customer.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${customer.phone} • ${customer.email}', style: const TextStyle(fontSize: 12)),
                      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.softPink),
                      onTap: () => _showCustomerDetails(context, customer),
                    ),
                  );
                },
              ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.primaryPink,
            onPressed: () => _showAddCustomerDialog(context),
            child: const Icon(Icons.person_add_alt_1_rounded, color: Colors.white),
          ),
        );
      }
    );
  }

  void _showAddCustomerDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Customer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Full Name')),
            const SizedBox(height: 12),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email Address')),
            const SizedBox(height: 12),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone Number')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () {
              final newCustomer = Customer(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: nameController.text,
                email: emailController.text,
                phone: phoneController.text,
              );
              _dataService.addCustomer(newCustomer);
              Navigator.pop(context);
            },
            child: const Text('REGISTER'),
          ),
        ],
      ),
    );
  }

  void _showCustomerDetails(BuildContext context, Customer customer) {
    final sales = _dataService.sales.where((s) => s.customerId == customer.id).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(radius: 30, backgroundColor: AppColors.softPink, child: Text(customer.name[0], style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold))),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(customer.name, style: AppTextStyles.heading),
                    const Text('Loyal Customer', style: TextStyle(color: AppColors.primaryPink, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            _infoRow(Icons.phone_iphone_rounded, 'Phone', customer.phone),
            _infoRow(Icons.alternate_email_rounded, 'Email', customer.email),
            const Divider(height: 40),
            const Text('PURCHASE HISTORY', style: AppTextStyles.subHeading),
            const SizedBox(height: 12),
            Expanded(
              child: sales.isEmpty 
                ? const Center(child: Text('No transactions recorded yet.'))
                : ListView.builder(
                    itemCount: sales.length,
                    itemBuilder: (context, i) => Card(
                      elevation: 0,
                      color: AppColors.offWhite,
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text('Invoice #${sales[i].id.substring(sales[i].id.length - 6)}'),
                        subtitle: Text(sales[i].date.toString().substring(0, 10)),
                        trailing: Text('${AppConfig.currency} ${sales[i].totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.softPink),
          const SizedBox(width: 12),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
