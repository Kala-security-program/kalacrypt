// lib/screens/scan_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/scan_provider.dart';
import '../widgets/device_tile.dart';

class ScanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scanProv = Provider.of<ScanProvider>(context, listen: false);

    return Column(
      children: [
        // Global banner if desired
        StreamBuilder<bool>(
          stream: scanProv.rfDosDetected,
          initialData: false,
          builder: (ctx, snap) {
            final isDos = snap.data ?? false;
            return Container(
              width: double.infinity,
              color: isDos ? Colors.red[800] : Colors.green[800],
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                isDos ? '⚠️ RF DoS Detected!' : '✅ RF Conditions Normal',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            );
          },
        ),

        Divider(color: Colors.grey),

        // Device list
        Expanded(
          child: Consumer<ScanProvider>(
            builder: (ctx, prov, _) {
              final devices = prov.devices;
              if (devices.isEmpty) {
                return Center(
                  child: Text(
                    'No devices detected',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: devices.length,
                itemBuilder: (ctx, i) {
                  final dev = devices[i];
                  final isWeak = dev.rssi < -85;
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Main device info
                          DeviceTile(device: dev),
                          SizedBox(height: 8),
                          // Per-device RSSI warning
                          if (isWeak)
                            Row(
                              children: [
                                Icon(Icons.warning, color: Colors.red),
                                SizedBox(width: 8),
                                Text(
                                  'Weak signal (RSSI ${dev.rssi} dBm)',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )
                          else
                            Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.green),
                                SizedBox(width: 8),
                                Text(
                                  'Signal healthy',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
