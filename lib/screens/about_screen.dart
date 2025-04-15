// lib/screens/about_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';

class AboutScreen extends StatelessWidget {
  final String _githubUrl =
      'https://github.com/Kala-security-program/kalacrypt';
  final String _version = 'v1.0.0';

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      backgroundColor: cyberpunkTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('About', style: GoogleFonts.orbitron()),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            // Logo & Title
            Icon(Icons.security, size: 96, color: accent),
            SizedBox(height: 12),
            Text(
              'KalaCrypt',
              style: GoogleFonts.orbitron(
                textStyle: TextStyle(fontSize: 24, color: accent),
              ),
            ),
            SizedBox(height: 4),
            Text(
              'RF Reader • $_version',
              style: GoogleFonts.shareTechMono(
                textStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
            ),

            SizedBox(height: 32),
            Divider(color: Colors.grey[700]),

            // Description
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  'KalaCrypt’s RF Reader is a professional, cyberpunk‑themed tool that scans and logs nearby Wi‑Fi and Bluetooth devices, visualizes signal strength in real‑time, and charts historical data. Developed by Dr. Sai Kamesh Yadavalli, Ph.D., this app combines cutting‑edge scanning techniques with sleek animations and a neon aesthetic to empower security professionals and enthusiasts alike.',
                  style: GoogleFonts.shareTechMono(
                    textStyle: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
              ),
            ),

            // GitHub Link
            SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                foregroundColor: accent,
                backgroundColor: Colors.transparent,
                side: BorderSide(color: accent),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              icon: Icon(Icons.code),
              label: Text(
                'View on GitHub',
                style: GoogleFonts.shareTechMono(
                  textStyle: TextStyle(fontSize: 14),
                ),
              ),
              onPressed: () => _launchURL(_githubUrl),
            ),
          ],
        ),
      ),
    );
  }
}
