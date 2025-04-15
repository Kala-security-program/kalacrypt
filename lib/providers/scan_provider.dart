// lib/providers/scan_provider.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:wifi_iot/wifi_iot.dart';
import '../models/device.dart';
import '../models/scan_data.dart';

class ScanProvider extends ChangeNotifier {
  final FlutterReactiveBle _ble = FlutterReactiveBle();
  final Map<String, Device> _devices = {};
  final ScanData history = ScanData();

  // RF‑DoS detection stream
  final _rfDosController = StreamController<bool>.broadcast();
  Stream<bool> get rfDosDetected => _rfDosController.stream;

  // BLE subscription
  StreamSubscription<DiscoveredDevice>? _bleSub;

  Timer? _scanTimer;

  /// Public scan intervals (seconds)
  static const int bleInterval = 5;
  static const int wifiInterval = 10;
  static const int overallInterval = 5;

  // For disappearance detection
  List<String> _lastScanMacs = [];

  ScanProvider() {
    _initScans();
  }

  List<Device> get devices => _devices.values.toList();

  /// Initialize periodic scans
  void _initScans() {
    _runScans(); // immediate
    _scanTimer = Timer.periodic(
      Duration(seconds: overallInterval),
      (_) => _runScans(),
    );
  }

  /// Combined BLE + Wi‑Fi scan
  Future<void> _runScans() async {
    await _scanBluetooth();
    await _scanWifi();
    notifyListeners();
  }

  /// BLE scan returning list of devices
  Future<void> _scanBluetooth() async {
    final List<Device> found = [];
    try {
      // Cancel previous BLE scan subscription
      await _bleSub?.cancel();
      await _ble.deinitialize();

      _bleSub = _ble
          .scanForDevices(withServices: [], scanMode: ScanMode.balanced)
          .listen((d) {
            final dev = Device(
              mac: d.id,
              name: d.name.isEmpty ? 'Unknown BLE' : d.name,
              rssi: d.rssi,
              type: DeviceType.bluetooth,
            );
            found.add(dev);
            _devices[d.id] = dev;
            history.addSample(d.id, d.rssi);
          });

      await Future.delayed(Duration(seconds: bleInterval));
      await _bleSub?.cancel();
    } catch (e) {
      debugPrint('BLE scan error: $e');
    }
    _evaluateRfDos(found);
  }

  /// Wi‑Fi scan returning list of networks
  Future<void> _scanWifi() async {
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
      debugPrint('Wi‑Fi scan error: $e');
    }
    _evaluateRfDos(found);
  }

  /// RF‑DoS detection: disappearance or weak-signal flood
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
