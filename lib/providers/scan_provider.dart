// lib/providers/scan_provider.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:wifi_iot/wifi_iot.dart';
import '../models/device.dart';
import '../models/scan_data.dart';

class ScanProvider extends ChangeNotifier {
  final FlutterReactiveBle _ble = FlutterReactiveBle();
  final Map<String, Device> _devices = {};
  final ScanData history = ScanData();

  final _rfDosController = StreamController<bool>.broadcast();
  Stream<bool> get rfDosDetected => _rfDosController.stream;

  StreamSubscription<DiscoveredDevice>? _bleSub;
  Timer? _scanTimer;

  static const int bleInterval = 5;
  static const int wifiInterval = 10;
  static const int overallInterval = 5;

  List<String> _lastScanMacs = [];

  bool _scanBleEnabled = true;
  bool _scanWifiEnabled = true;

  ScanProvider() {
    _initScans();
  }

  List<Device> get devices => _devices.values.toList();

  Future<void> _loadScanSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _scanBleEnabled = prefs.getBool('scanBle') ?? true;
    _scanWifiEnabled = prefs.getBool('scanWifi') ?? true;
  }

  void _initScans() {
    _loadScanSettings().then((_) {
      _runScans();
      _scanTimer = Timer.periodic(Duration(seconds: overallInterval), (
        _,
      ) async {
        await _loadScanSettings();
        _runScans();
      });
    });
  }

  Future<void> _runScans() async {
    _devices.clear(); // Clear previous results
    final List<Device> combined = [];

    if (_scanBleEnabled) {
      final bleDevices = await _scanBluetooth();
      combined.addAll(bleDevices);
    }

    if (_scanWifiEnabled) {
      final wifiDevices = await _scanWifi();
      combined.addAll(wifiDevices);
    }

    if (combined.isEmpty) {
      history.clear();
    }

    _evaluateRfDos(combined);
    notifyListeners();
  }

  Future<List<Device>> _scanBluetooth() async {
    final List<Device> found = [];
    try {
      await _bleSub?.cancel(); // stop previous scan

      _bleSub = _ble
          .scanForDevices(withServices: [], scanMode: ScanMode.lowLatency)
          .listen((d) {
            if (_devices.containsKey(d.id)) return; // avoid duplicates

            final dev = Device(
              mac: d.id,
              name: d.name.isEmpty ? 'Unknown BLE' : d.name,
              rssi: d.rssi,
              type: DeviceType.bluetooth,
            );
            found.add(dev);
            _devices[d.id] = dev;
            history.addSample(d.id, d.rssi);
            notifyListeners(); // show new device immediately
          });

      await Future.delayed(Duration(seconds: bleInterval));
      await _bleSub?.cancel();
    } catch (e) {
      debugPrint('BLE scan error: $e');
    }
    return found;
  }

  Future<List<Device>> _scanWifi() async {
    final List<Device> found = [];
    try {
      final list = await WiFiForIoTPlugin.loadWifiList();
      if (list != null) {
        for (var net in list) {
          final mac = net.bssid ?? 'unknown';
          final dev = Device(
            mac: mac,
            name: net.ssid ?? '<hidden>',
            rssi: net.level ?? 0,
            type: DeviceType.wifi,
          );
          found.add(dev);
          _devices[mac] = dev;
          history.addSample(mac, net.level ?? 0);
        }
      }
    } catch (e) {
      debugPrint('Wi‑Fi scan error: \$e');
    }
    return found;
  }

  void _evaluateRfDos(List<Device> current) {
    final currentMacs = current.map((d) => d.mac).toList();

    final missingCount =
        _lastScanMacs.where((mac) => !currentMacs.contains(mac)).length;
    final missingRatio =
        _lastScanMacs.isEmpty ? 0.0 : missingCount / _lastScanMacs.length;

    final weakCount = current.where((d) => d.rssi < -85).length;
    final weakRatio = current.isEmpty ? 0.0 : weakCount / current.length;

    final dos = missingRatio > 0.5 || weakRatio > 0.6;
    _rfDosController.add(dos);

    _lastScanMacs = currentMacs;
  }

  @override
  void dispose() {
    _scanTimer?.cancel();
    _bleSub?.cancel();
    _rfDosController.close();
    super.dispose();
  }
}
