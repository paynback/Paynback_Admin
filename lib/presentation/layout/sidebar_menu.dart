import 'package:flutter/material.dart';
import 'package:pndb_admin/utils/constants.dart';

class SidebarMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onSelect;

  const SidebarMenu({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      ('Dashboard', Icons.dashboard),
      ('Users', Icons.people),
      ('Merchants', Icons.store),
      ('Offers', Icons.card_giftcard),
      ('Commission', Icons.percent),
      ('Settlements', Icons.payments),
      ('Banners', Icons.ads_click),
      ('Bulk Qr', Icons.qr_code),
      ('Channel Partner', Icons.person)
    ];

    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Center(
            child: Image.asset(
              'asset/logo/PayNback Logo.png',
              width: 180,
              height: 80,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 30),
          ...menuItems.asMap().entries.map((entry) {
            final index = entry.key;
            final title = entry.value.$1;
            final icon = entry.value.$2;
            final isSelected = selectedIndex == index;

            return Stack(
              children: [
                if (isSelected)
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 4,
                      color: pBlue,
                    ),
                  ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  leading: Icon(
                    icon,
                    color: isSelected ? pBlue : Colors.grey,
                  ),
                  title: Text(
                    title,
                    style: TextStyle(
                      color: isSelected ? pBlue : Colors.grey[800],
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  onTap: () => onSelect(index),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
