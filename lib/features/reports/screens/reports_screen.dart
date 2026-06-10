import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/data_service.dart';
import 'sales_history_screen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final DataService _dataService = DataService();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _dataService,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('SHOP PERFORMANCE')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRevenueCard(),
                const SizedBox(height: 30),
                const Text('Analytics Overview', style: AppTextStyles.subHeading),
                const SizedBox(height: 16),
                _reportTile(
                  'Sales History', 
                  '${_dataService.sales.length} orders processed', 
                  Icons.auto_graph_rounded, 
                  Colors.blue,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesHistoryScreen())),
                ),
                _reportTile('Inventory Health', '${_dataService.lowStockCount} items need attention', Icons.inventory_2_rounded, Colors.orange),
                _reportTile('Customer Growth', '${_dataService.customers.length} total members', Icons.groups_rounded, Colors.green),
                const SizedBox(height: 32),
                _buildExportSection(),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildRevenueCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryPink, AppColors.deepPink],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPink.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          const Text('MONTHLY REVENUE', style: TextStyle(color: Colors.white70, letterSpacing: 2, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(
            '${AppConfig.currency} ${_dataService.monthlyRevenue.toStringAsFixed(0)}',
            style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.trending_up, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text('Real-time Data', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _reportTile(String title, String subtitle, IconData icon, Color color, {VoidCallback? onTap}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.grey.withValues(alpha: 0.1))),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(15)),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
        onTap: onTap,
      ),
    );
  }

  Widget _buildExportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Generate Statement', style: AppTextStyles.subHeading),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.picture_as_pdf_rounded),
                label: const Text('PDF Report'),
                onPressed: () => _showExportingToast('PDF'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.grid_on_rounded),
                label: const Text('Excel Sheet'),
                onPressed: () => _showExportingToast('Excel'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showExportingToast(String type) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Generating $type statement...'), behavior: SnackBarBehavior.floating));
  }
}
