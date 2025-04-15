// lib/models/scan_data.dart

class SignalSample {
  final DateTime timestamp;
  final int rssi;

  SignalSample({required this.timestamp, required this.rssi});
}

class ScanData {
  final Map<String, List<SignalSample>> data = {};

  void addSample(String mac, int rssi) {
    final sample = SignalSample(timestamp: DateTime.now(), rssi: rssi);
    data.putIfAbsent(mac, () => []).add(sample);
  }

  /// Expose device MACs
  List<String> get deviceMacs => data.keys.toList();

  /// Get samples for a specific device
  List<SignalSample> samplesFor(String mac) => data[mac] ?? [];

  void clear() {
    data.clear();
  }
}
