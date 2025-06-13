import 'package:flutter/material.dart';
import 'package:pndb_admin/presentation/widgets/logout_dialog.dart';
import 'package:pndb_admin/utils/constants.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Icon(Icons.notifications_none, size: 28),
          const SizedBox(width: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'asset/images/play_store_512.png',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () {
              showCustomLogoutDialog(context); // ← Now using dialog
            },
            icon: const Icon(Icons.logout, size: 20,color: pWhite,),
            label: const Text(
              'Logout',
              style: TextStyle(color: pWhite),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: pBlue,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              textStyle: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
