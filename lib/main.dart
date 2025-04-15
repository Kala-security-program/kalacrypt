import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'providers/theme_provider.dart';
import 'providers/scan_provider.dart';
import 'screens/main_scaffold.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request runtime permissions on Android
  await [
    Permission.bluetooth,
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
    Permission.location,
    Permission.storage,
  ].request();

  // Load saved theme preference
  final themeProvider = await ThemeProvider.create();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
        ChangeNotifierProvider<ScanProvider>(create: (_) => ScanProvider()),
      ],
      child: KalaApp(),
    ),
  );
}

class KalaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Listen for theme changes
    final themeProv = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Kala RF Reader',
      debugShowCheckedModeBanner: false,
      theme: themeProv.themeData,
      home: MainScaffold(),
    );
  }
}
