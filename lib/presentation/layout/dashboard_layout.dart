import 'package:flutter/material.dart';
import 'package:pndb_admin/presentation/screens/banner_management_screen.dart';
import 'package:pndb_admin/presentation/screens/channel_partner/channel_partner.dart';
import 'package:pndb_admin/presentation/screens/commission/commission_management_screen.dart';
import 'package:pndb_admin/presentation/screens/dashboard_screen.dart';
import 'package:pndb_admin/presentation/screens/merchant/merchant_management_screen.dart';
import 'package:pndb_admin/presentation/screens/offer_cashback_management_screen.dart';
import 'package:pndb_admin/presentation/screens/qr%20management/bulk_qr_screen.dart';
import 'package:pndb_admin/presentation/screens/settlement/settlement_management_screen.dart';
import 'package:pndb_admin/presentation/screens/user/user_management_screen.dart';
import '../widgets/custom_appbar.dart';
import 'sidebar_menu.dart';

class DashboardLayout extends StatefulWidget {
  const DashboardLayout({super.key});

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    const DashboardScreen(),
    UserManagementScreen(),
    MerchantManagementScreen(),
    OfferCashbackManagementScreen(),
    CommissionManagementScreen(),
    SettlementManagementScreen(),
    BannerManagementScreen(),
    BulkQrManagementScreen(),
    ChannelPartner()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SidebarMenu(
            selectedIndex: selectedIndex,
            onSelect: (index) {
              setState(() => selectedIndex = index);
            },
          ),
          Expanded(
            child: Column(
              children: [
                const CustomAppBar(),
                Expanded(child: pages[selectedIndex]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
