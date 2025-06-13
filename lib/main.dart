// lib/main.dart
import 'package:flutter/material.dart';
import 'package:pndb_admin/core/theme.dart';
import 'package:pndb_admin/presentation/screens/admin_login/splash_screen.dart';
import 'package:pndb_admin/presentation/viewmodels/multi_bloc_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    AppMultiBlocProvider.build(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const SplashScreen(),
    );
  }
}
