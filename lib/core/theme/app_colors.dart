import 'package:flutter/material.dart';

/// Application Color Palette
///
/// Centralized color definitions supporting light and dark themes
class AppColors {
  AppColors._();

  // ======== PRIMARY COLORS ========
  static const Color primary = Color(0xFF1380EC);
  static const Color primaryLight = Color(0xFF1380EC);
  static const Color primaryDark = Color(0xFF0D5BA3);

  // ======== BACKGROUND COLORS ========
  static const Color background = Color(0xFFFEFEFE);
  static const Color surface = Color.fromARGB(255, 210, 232, 255);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // ======== TEXT COLORS ========
  static const Color textPrimary = Color(0xFF0D141B);
  static const Color textSecondary = Color(0xFF4C739A);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textTertiary = Color(0xFFB0BCC6);

  // ======== STATUS COLORS ========
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // ======== BORDER COLORS ========
  static const Color border = Color(0xFF3B82F6);
  static const Color borderLight = Color(0xFF3B82F6);
  static const Color borderDark = Color(0xFF3B82F6);

  // ======== INPUT COLORS ========
  static const Color inputBackground = Color(0xFFE7EDF3);
  static const Color inputBorder = Color(0xFFCFD8E7);
  static const Color inputFocusBorder = Color(0xFF1380EC);

  // ======== DARK THEME SPECIFIC ========
  static const Color darkBackground = Color(0xFF1A1A1A);
  static const Color darkSurface = Color(0xFF2D2D2D);
  static const Color darkCardBackground = Color(0xFF242424);
  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFFB0BCC6);
  static const Color darkInputBackground = Color(0xFF3A3A3A);
  static const Color darkInputBorder = Color(0xFF4A4A4A);

  // ======== OVERLAY & SHADOW ========
  static const Color overlay = Color(0x1A000000);
  static const Color overlayDark = Color(0x33000000);
  static const Color shadowLight = Color(0x1A000000);
}
