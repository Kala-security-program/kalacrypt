// lib/screens/charts_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/scan_provider.dart';
import '../models/scan_data.dart';
import '../widgets/signal_chart.dart';
import '../models/device.dart';

class ChartsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ScanProvider>(context);
    final history = provider.history;
    final devices = provider.devices;

    if (devices.isEmpty) {
      return Center(
        child: Text(
          'No devices found yet.',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount: devices.length,
      itemBuilder: (ctx, i) {
        final device = devices[i];
        final mac = device.mac;
        final samples = history.samplesFor(mac);

        // pick a color based on index
        final color = Colors.primaries[i % Colors.primaries.length];

        // Choose icon
        final icon =
            device.type == DeviceType.wifi ? Icons.wifi : Icons.bluetooth;

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          color: Colors.black87,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row: icon + name + MAC
                Row(
                  children: [
                    Icon(icon, color: color),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${device.name}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      mac,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),

                SizedBox(height: 12),

                // Chart
                SizedBox(
                  height: 200,
                  child: SignalChart(samples: samples, lineColor: color),
                ),

                // If no BLE samples at all, show a note
                if (device.type == DeviceType.bluetooth && samples.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'No Bluetooth RSSI samples yet',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
