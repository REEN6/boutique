import 'package:flutter/material.dart';
import '../../../core/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PREFERENCES')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _sectionHeader('Shop Identity'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.store_rounded, color: AppColors.primaryPink),
              title: const Text('Reen Boutique & Spa'),
              subtitle: const Text('Nairobi, Kenya'),
              trailing: IconButton(icon: const Icon(Icons.edit_rounded, size: 20), onPressed: () {}),
            ),
          ),
          const SizedBox(height: 30),
          _sectionHeader('Regional Settings'),
          _settingsTile('Currency', 'Kshs (Kenyan Shilling)', Icons.payments_rounded),
          _settingsTile('Tax Calculation', '16% VAT', Icons.receipt_long_rounded),
          _settingsTile('Language', 'English (UK)', Icons.translate_rounded),
          const SizedBox(height: 30),
          _sectionHeader('Security & Data'),
          _settingsTile('Staff Access', 'Manage Permissions', Icons.admin_panel_settings_rounded),
          _settingsTile('Backup', 'Last backup: Today, 08:00', Icons.cloud_upload_rounded),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            child: const Text('LOGOUT ALL SESSIONS'),
          ),
          const SizedBox(height: 20),
          Center(child: Text('Version 2.0.4-Pink', style: TextStyle(color: Colors.grey[400], fontSize: 10))),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(title.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.deepPink, letterSpacing: 1.2)),
    );
  }

  Widget _settingsTile(String title, String trailing, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.softPink),
        title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(trailing, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.grey),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}
