import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

import '../providers/scan_provider.dart';
import '../providers/theme_provider.dart';
import '../theme.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoScan = true;
  double _bleInterval = ScanProvider.bleInterval.toDouble();
  double _wifiInterval = ScanProvider.wifiInterval.toDouble();
  bool _showBle = true;
  bool _showWifi = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      _autoScan = p.getBool('autoScan') ?? true;
      _bleInterval =
          p.getDouble('bleInterval') ?? ScanProvider.bleInterval.toDouble();
      _wifiInterval =
          p.getDouble('wifiInterval') ?? ScanProvider.wifiInterval.toDouble();
      _showBle = p.getBool('showBle') ?? true;
      _showWifi = p.getBool('showWifi') ?? true;
    });
    // Load theme via provider
    final themeProv = Provider.of<ThemeProvider>(context, listen: false);
    // themeProv.isCyberpunk is already set on startup
  }

  Future<void> _savePrefs() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool('autoScan', _autoScan);
    await p.setDouble('bleInterval', _bleInterval);
    await p.setDouble('wifiInterval', _wifiInterval);
    await p.setBool('showBle', _showBle);
    await p.setBool('showWifi', _showWifi);
  }

  Future<void> _exportLogs() async {
    final provider = Provider.of<ScanProvider>(context, listen: false);
    final data = provider.history.data.map((mac, samples) {
      return MapEntry(
        mac,
        samples
            .map(
              (s) => {
                'timestamp': s.timestamp.toIso8601String(),
                'rssi': s.rssi,
              },
            )
            .toList(),
      );
    });
    final jsonStr = jsonEncode(data);
    final dir = await getApplicationDocumentsDirectory();
    final file = File(
      '${dir.path}/kala_rf_logs_${DateTime.now().millisecondsSinceEpoch}.json',
    );
    await file.writeAsString(jsonStr);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Logs exported to ${file.path}')));
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.secondary;
    final themeProv = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: GoogleFonts.orbitron()),
        backgroundColor: cyberpunkTheme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Theme toggle
          Text('Theme', style: GoogleFonts.shareTechMono(fontSize: 16)),
          Row(
            children: [
              ChoiceChip(
                label: Text('Cyberpunk', style: GoogleFonts.shareTechMono()),
                selected: themeProv.isCyberpunk,
                selectedColor: accent,
                onSelected: (_) => themeProv.toggleTheme(true),
              ),
              SizedBox(width: 12),
              ChoiceChip(
                label: Text('Dark', style: GoogleFonts.shareTechMono()),
                selected: !themeProv.isCyberpunk,
                selectedColor: accent,
                onSelected: (_) => themeProv.toggleTheme(false),
              ),
            ],
          ),

          Divider(color: Colors.grey),

          SwitchListTile(
            title: Text('Auto‑scan', style: GoogleFonts.shareTechMono()),
            subtitle: Text(
              'Enable continuous scanning',
              style: GoogleFonts.shareTechMono(),
            ),
            value: _autoScan,
            onChanged:
                (v) => setState(() {
                  _autoScan = v;
                  _savePrefs();
                }),
          ),

          SizedBox(height: 12),
          Text(
            'BLE Scan Interval: ${_bleInterval.toInt()}s',
            style: GoogleFonts.shareTechMono(),
          ),
          Slider(
            min: 5,
            max: 30,
            divisions: 5,
            value: _bleInterval,
            label: '${_bleInterval.toInt()}s',
            onChanged: (v) => setState(() => _bleInterval = v),
            onChangeEnd: (_) => _savePrefs(),
          ),

          SizedBox(height: 12),
          Text(
            'Wi‑Fi Scan Interval: ${_wifiInterval.toInt()}s',
            style: GoogleFonts.shareTechMono(),
          ),
          Slider(
            min: 5,
            max: 60,
            divisions: 11,
            value: _wifiInterval,
            label: '${_wifiInterval.toInt()}s',
            onChanged: (v) => setState(() => _wifiInterval = v),
            onChangeEnd: (_) => _savePrefs(),
          ),

          SizedBox(height: 12),
          SwitchListTile(
            title: Text(
              'Show Bluetooth Devices',
              style: GoogleFonts.shareTechMono(),
            ),
            value: _showBle,
            onChanged:
                (v) => setState(() {
                  _showBle = v;
                  _savePrefs();
                }),
          ),
          SwitchListTile(
            title: Text(
              'Show Wi‑Fi Networks',
              style: GoogleFonts.shareTechMono(),
            ),
            value: _showWifi,
            onChanged:
                (v) => setState(() {
                  _showWifi = v;
                  _savePrefs();
                }),
          ),

          SizedBox(height: 24),
          ElevatedButton.icon(
            icon: Icon(Icons.download),
            label: Text('Export Logs', style: GoogleFonts.shareTechMono()),
            onPressed: _exportLogs,
          ),
        ],
      ),
    );
  }
}
