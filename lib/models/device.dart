// lib/models/device.dart

enum DeviceType { wifi, bluetooth }

class Device {
  final String mac;
  final String name;
  final int rssi;
  final DeviceType type;

  Device({
    required this.mac,
    required this.name,
    required this.rssi,
    required this.type,
  });
}
