// lib/theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Cyberpunk Theme
final ThemeData cyberpunkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xFF0A0A0A),
  primaryColor: Color(0xFF0FF0FC),
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF0FF0FC),
    secondary: Color(0xFFFF00FF),
    background: Color(0xFF0A0A0A),
    surface: Color(0xFF1A1A1A),
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onBackground: Colors.white,
    onSurface: Colors.white,
  ),

  // AppBar
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: Color(0xFFFF00FF)),
    titleTextStyle: GoogleFonts.orbitron(
      textStyle: TextStyle(
        color: Color(0xFF0FF0FC),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    centerTitle: true,
  ),

  // BottomNavigationBar
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF111111),
    selectedItemColor: Color(0xFFFF00FF),
    unselectedItemColor: Colors.grey,
  ),

  // Text
  textTheme: TextTheme(
    titleLarge: GoogleFonts.orbitron(color: Color(0xFF0FF0FC), fontSize: 18),
    bodyMedium: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 14),
    titleMedium: GoogleFonts.shareTechMono(
      color: Colors.grey[300],
      fontSize: 16,
    ),
    bodySmall: GoogleFonts.shareTechMono(color: Colors.grey, fontSize: 12),
  ),

  // Elevated Buttons
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Color(0xFFFF00FF),
      backgroundColor: Colors.transparent,
      side: BorderSide(color: Color(0xFFFF00FF)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: GoogleFonts.shareTechMono(fontSize: 14),
    ),
  ),

  // Icons
  iconTheme: IconThemeData(color: Color(0xFF0FF0FC)),

  // Sliders
  sliderTheme: SliderThemeData(
    activeTrackColor: Color(0xFFFF00FF),
    inactiveTrackColor: Colors.grey[800],
    thumbColor: Color(0xFF0FF0FC),
    overlayColor: Color(0xFF0FF0FC).withOpacity(0.2),
  ),

  // Switches
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.all(Color(0xFF0FF0FC)),
    trackColor: MaterialStateProperty.resolveWith(
      (states) =>
          states.contains(MaterialState.selected)
              ? Color(0xFFFF00FF)
              : Colors.grey,
    ),
  ),

  // Chips
  chipTheme: ChipThemeData(
    backgroundColor: Color(0xFF111111),
    selectedColor: Color(0xFFFF00FF),
    labelStyle: GoogleFonts.shareTechMono(color: Colors.white),
    secondaryLabelStyle: GoogleFonts.shareTechMono(color: Colors.black),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),

  // Cards
  cardTheme: CardTheme(
    color: Color(0xFF1A1A1A),
    elevation: 4,
    margin: EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
);

/// Standard Dark Theme
final ThemeData standardDarkTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.blueGrey,
  scaffoldBackgroundColor: Colors.grey[900],
  colorScheme: ColorScheme.dark(
    primary: Colors.blueGrey,
    secondary: Colors.tealAccent,
    background: Colors.grey[900]!,
    surface: Colors.grey[800]!,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onBackground: Colors.white,
    onSurface: Colors.white,
  ),

  // AppBar
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey[850],
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.tealAccent),
    titleTextStyle: GoogleFonts.shareTechMono(
      textStyle: TextStyle(
        color: Colors.tealAccent,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    centerTitle: true,
  ),

  // BottomNavigationBar
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.grey[850],
    selectedItemColor: Colors.tealAccent,
    unselectedItemColor: Colors.grey,
  ),

  // Text
  textTheme: TextTheme(
    titleLarge: GoogleFonts.shareTechMono(
      color: Colors.tealAccent,
      fontSize: 18,
    ),
    bodyMedium: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 14),
    titleMedium: GoogleFonts.shareTechMono(
      color: Colors.grey[300],
      fontSize: 16,
    ),
    bodySmall: GoogleFonts.shareTechMono(color: Colors.grey, fontSize: 12),
  ),

  // Elevated Buttons
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor: Colors.tealAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: GoogleFonts.shareTechMono(fontSize: 14),
    ),
  ),

  // Icons
  iconTheme: IconThemeData(color: Colors.tealAccent),

  // Sliders
  sliderTheme: SliderThemeData(
    activeTrackColor: Colors.tealAccent,
    inactiveTrackColor: Colors.grey[700],
    thumbColor: Colors.tealAccent,
    overlayColor: Colors.tealAccent.withOpacity(0.2),
  ),

  // Switches
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.all(Colors.tealAccent),
    trackColor: MaterialStateProperty.resolveWith(
      (states) =>
          states.contains(MaterialState.selected)
              ? Colors.tealAccent
              : Colors.grey,
    ),
  ),

  // Chips
  chipTheme: ChipThemeData(
    backgroundColor: Colors.grey[800]!,
    selectedColor: Colors.tealAccent,
    labelStyle: GoogleFonts.shareTechMono(color: Colors.white),
    secondaryLabelStyle: GoogleFonts.shareTechMono(color: Colors.black),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),

  // Cards
  cardTheme: CardTheme(
    color: Colors.grey[800],
    elevation: 4,
    margin: EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
);
