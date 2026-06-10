import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/data_service.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataService = DataService();
    return Scaffold(
      appBar: AppBar(title: const Text('SYSTEM MAINTENANCE')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildMaintenanceHeader(),
          const SizedBox(height: 30),
          _sectionHeader('Data Management'),
          _maintenanceTile(
            context,
            'Clear Sales History',
            'Delete all transaction records permanently.',
            Icons.delete_sweep_outlined,
            Colors.red,
            () => _confirmAction(context, 'Clear all sales records?', () {
              dataService.sales.clear();
              dataService.notifyListeners();
            }),
          ),
          _maintenanceTile(
            context,
            'Reset Inventory',
            'Set all product stock levels to zero.',
            Icons.inventory_outlined,
            Colors.orange,
            () => _confirmAction(context, 'Reset all stock levels?', () {
              for (var p in dataService.products) {
                p.stock = 0;
              }
              dataService.notifyListeners();
            }),
          ),
          const SizedBox(height: 20),
          _sectionHeader('System Tools'),
          _maintenanceTile(
            context,
            'Optimize Database',
            'Improve system performance and response time.',
            Icons.speed_outlined,
            Colors.blue,
            () => _showSuccess(context, 'System optimization complete!'),
          ),
          _maintenanceTile(
            context,
            'Check for Updates',
            'Current Version: 2.0.4-Pink',
            Icons.system_update_alt_outlined,
            AppColors.primaryPink,
            () => _showSuccess(context, 'System is up to date.'),
          ),
          const SizedBox(height: 20),
          _sectionHeader('Logs'),
          _maintenanceTile(
            context,
            'View System Logs',
            'Track all admin and staff activities.',
            Icons.list_alt_rounded,
            AppColors.charcoal,
            () => _showSuccess(context, 'No critical issues found in logs.'),
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.softPink.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.softPink.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: const [
          Icon(Icons.warning_amber_rounded, color: AppColors.deepPink, size: 40),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              'Maintenance mode allows you to manage backend data and optimize system performance.',
              style: TextStyle(fontSize: 13, color: AppColors.charcoal),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.deepPink, letterSpacing: 1.2),
      ),
    );
  }

  Widget _maintenanceTile(BuildContext context, String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.grey.withValues(alpha: 0.1))),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11)),
        trailing: const Icon(Icons.chevron_right_rounded, size: 20),
        onTap: onTap,
      ),
    );
  }

  void _confirmAction(BuildContext context, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Maintenance Task'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          TextButton(
            onPressed: () {
              onConfirm();
              Navigator.pop(context);
              _showSuccess(context, 'Task completed successfully');
            },
            child: const Text('CONFIRM', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSuccess(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating));
  }
}
