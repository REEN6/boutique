import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/data_service.dart';
import '../../products/screens/product_list_screen.dart';
import '../../pos/screens/pos_screen.dart';
import '../../customers/screens/customer_list_screen.dart';
import '../../inventory/screens/stock_management_screen.dart';
import '../../reports/screens/reports_screen.dart';
import '../../employees/screens/employee_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../../settings/screens/maintenance_screen.dart';
import '../widgets/kpi_card.dart';
import '../widgets/revenue_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DataService _dataService = DataService();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _dataService,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('REEN BOUTIQUE'),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.logout_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          drawer: _buildDrawer(context),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundColor: AppColors.softPink,
                      child: Icon(Icons.person, color: AppColors.deepPink),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Welcome back,', style: TextStyle(color: Colors.grey)),
                        Text('DOREEN REEN', style: AppTextStyles.subHeading),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                
                // KPI Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: [
                    KpiCard(
                      title: 'Today\'s Sales',
                      value: '${AppConfig.currency} ${_dataService.todaySalesAmount.toStringAsFixed(0)}',
                      icon: Icons.payments_outlined,
                      iconColor: Colors.pinkAccent,
                    ),
                    KpiCard(
                      title: 'Monthly Revenue',
                      value: '${AppConfig.currency} ${_dataService.monthlyRevenue.toStringAsFixed(0)}',
                      icon: Icons.analytics_outlined,
                      iconColor: AppColors.deepPink,
                    ),
                    KpiCard(
                      title: 'Low Stock',
                      value: '${_dataService.lowStockCount}',
                      icon: Icons.inventory_2_outlined,
                      iconColor: Colors.orange,
                    ),
                    KpiCard(
                      title: 'Customers',
                      value: '${_dataService.customers.length}',
                      icon: Icons.people_outline_rounded,
                      iconColor: Colors.blueAccent,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const RevenueChart(),
                const SizedBox(height: 32),
                const Text('Quick Access', style: AppTextStyles.subHeading),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _QuickActionBtn(
                        label: 'New Sale',
                        icon: Icons.shopping_basket_outlined,
                        color: AppColors.primaryPink,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PosScreen())),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _QuickActionBtn(
                        label: 'Inventory',
                        icon: Icons.list_alt_rounded,
                        color: AppColors.deepPink,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StockManagementScreen())),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent Sales', style: AppTextStyles.subHeading),
                    Text('View All', style: TextStyle(color: AppColors.primaryPink, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 16),
                _dataService.sales.isEmpty 
                  ? Container(
                      padding: const EdgeInsets.all(40),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.receipt_long_outlined, size: 48, color: AppColors.softPink),
                          SizedBox(height: 10),
                          Text('No transactions yet.', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _dataService.sales.length > 5 ? 5 : _dataService.sales.length,
                      itemBuilder: (context, index) {
                        final sale = _dataService.sales.reversed.toList()[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.softPink.withValues(alpha: 0.2),
                              child: const Icon(Icons.shopping_bag_outlined, color: AppColors.primaryPink, size: 20),
                            ),
                            title: Text('Sale #${sale.id.substring(sale.id.length - 6)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            subtitle: Text('${sale.items.length} items • ${sale.date.hour}:${sale.date.minute}', style: const TextStyle(fontSize: 12)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${AppConfig.currency} ${sale.totalAmount.toStringAsFixed(0)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.deepPink),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Delete Sale Record'),
                                        content: const Text('Are you sure you want to remove this transaction? This will not revert stock.'),
                                        actions: [
                                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                _dataService.sales.removeWhere((s) => s.id == sale.id);
                                                _dataService.notifyListeners();
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: const Text('DELETE', style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.primaryPink, AppColors.deepPink]),
            ),
            accountName: Text('DOREEN REEN', style: TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text('doreen@reenboutique.ke'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.store_rounded, color: AppColors.primaryPink, size: 40),
            ),
          ),
          _drawerItem(context, Icons.dashboard_outlined, 'Dashboard', null),
          _drawerItem(context, Icons.inventory_2_outlined, 'Products', const ProductListScreen()),
          _drawerItem(context, Icons.point_of_sale_outlined, 'POS System', const PosScreen()),
          _drawerItem(context, Icons.analytics_outlined, 'Reports', const ReportsScreen()),
          _drawerItem(context, Icons.people_outline_rounded, 'Customers', const CustomerListScreen()),
          _drawerItem(context, Icons.badge_outlined, 'Employees', const EmployeeScreen()),
          _drawerItem(context, Icons.build_circle_outlined, 'Maintenance', const MaintenanceScreen()),
          const Spacer(),
          const Divider(),
          _drawerItem(context, Icons.settings_outlined, 'Settings', const SettingsScreen()),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String title, Widget? screen) {
    return ListTile(
      leading: Icon(icon, color: AppColors.deepPink),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: () {
        Navigator.pop(context);
        if (screen != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
        }
      },
    );
  }
}

class _QuickActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
