import 'package:flutter/material.dart';
import '../../../core/constants.dart';

class EmployeeScreen extends StatelessWidget {
  const EmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OUR TEAM')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        itemBuilder: (context, index) {
          final roles = ['Manager', 'Head Stylist', 'Inventory Lead', 'Cashier'];
          final names = ['Sarah Rose', 'Emily Wambui', 'Grace Akinyi', 'Michael Kariuki'];
          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: AppColors.softPink.withValues(alpha: 0.3),
                child: Text(names[index][0], style: const TextStyle(color: AppColors.deepPink, fontWeight: FontWeight.bold)),
              ),
              title: Text(names[index], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(roles[index]),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: const Text('Active', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              onTap: () {},
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryPink,
        onPressed: () {},
        child: const Icon(Icons.add_moderator_rounded, color: Colors.white),
      ),
    );
  }
}
