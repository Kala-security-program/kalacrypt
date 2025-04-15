import 'package:flutter/material.dart';
import 'scan_screen.dart';
import 'charts_screen.dart';
import 'settings_screen.dart';
import 'about_screen.dart';

class MainScaffold extends StatefulWidget {
  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final navTheme = Theme.of(context).bottomNavigationBarTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Rebuild SettingsScreen each time it’s tapped for refresh logic
    Widget screen;
    switch (_currentIndex) {
      case 0:
        screen = ScanScreen();
        break;
      case 1:
        screen = ChartsScreen();
        break;
      case 2:
        screen = SettingsScreen(); // NEW instance each time
        break;
      case 3:
        screen = AboutScreen();
        break;
      default:
        screen = ScanScreen();
    }

    return Scaffold(
      body: screen,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: navTheme.backgroundColor,
        selectedItemColor: colorScheme.secondary,
        unselectedItemColor: navTheme.unselectedItemColor,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.wifi), label: 'Scan'),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Charts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
        ],
      ),
    );
  }
}
