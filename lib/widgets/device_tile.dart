// lib/widgets/device_tile.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/device.dart';

class DeviceTile extends StatelessWidget {
  final Device device;
  final bool isJamming;
  final bool isDeauthFlood;

  const DeviceTile({
    Key? key,
    required this.device,
    this.isJamming = false,
    this.isDeauthFlood = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.secondary;
    final progress = (device.rssi + 100) / 100.0;
    final barColor = Color.lerp(Colors.red, accent, progress)!;

    // If anomaly applies, highlight border in red
    final borderColor = isJamming || isDeauthFlood ? Colors.red : accent;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.black54],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: borderColor.withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: icon, name, MAC, anomaly badge
            Row(
              children: [
                Icon(
                  device.type == DeviceType.wifi ? Icons.wifi : Icons.bluetooth,
                  color: accent,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    device.name,
                    style: GoogleFonts.shareTechMono(
                      textStyle: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isJamming)
                  Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: Icon(Icons.signal_wifi_off, color: Colors.red),
                  ),
                if (isDeauthFlood)
                  Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: Icon(Icons.security, color: Colors.red),
                  ),
                Text(
                  device.mac.substring(0, 8),
                  style: GoogleFonts.shareTechMono(
                    textStyle: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            // RSSI bar
            Row(
              children: [
                Text(
                  '${device.rssi} dBm',
                  style: GoogleFonts.shareTechMono(
                    textStyle: TextStyle(color: Colors.grey[300], fontSize: 12),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      minHeight: 8,
                      backgroundColor: Colors.grey[800],
                      valueColor: AlwaysStoppedAnimation(barColor),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
