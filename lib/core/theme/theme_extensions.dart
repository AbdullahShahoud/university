import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Extension on BuildContext for easy color access
///
/// Usage: context.colors.primary
extension BuildContextColorExtension on BuildContext {
  ColorExtension get colors {
    return Theme.of(this).extension<ColorExtension>() ?? ColorExtension.light;
  }
}

/// Extension on ThemeData for color management
///
/// Usage: theme.extension<ColorExtension>()?.primary
class ColorExtension extends ThemeExtension<ColorExtension> {
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color background;
  final Color surface;
  final Color cardBackground;
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color textTertiary;
  final Color success;
  final Color error;
  final Color warning;
  final Color info;
  final Color border;
  final Color borderLight;
  final Color borderDark;
  final Color inputBackground;
  final Color inputBorder;
  final Color inputFocusBorder;
  final Color overlay;
  final Color overlayDark;
  final Color shadowLight;

  ColorExtension({
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.background,
    required this.surface,
    required this.cardBackground,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.textTertiary,
    required this.success,
    required this.error,
    required this.warning,
    required this.info,
    required this.border,
    required this.borderLight,
    required this.borderDark,
    required this.inputBackground,
    required this.inputBorder,
    required this.inputFocusBorder,
    required this.overlay,
    required this.overlayDark,
    required this.shadowLight,
  });

  /// Light theme colors
  static ColorExtension light = ColorExtension(
    primary: AppColors.primary,
    primaryLight: AppColors.primaryLight,
    primaryDark: AppColors.primaryDark,
    background: AppColors.background,
    surface: AppColors.surface,
    cardBackground: AppColors.cardBackground,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textHint: AppColors.textHint,
    textTertiary: AppColors.textTertiary,
    success: AppColors.success,
    error: AppColors.error,
    warning: AppColors.warning,
    info: AppColors.info,
    border: AppColors.border,
    borderLight: AppColors.borderLight,
    borderDark: AppColors.borderDark,
    inputBackground: AppColors.inputBackground,
    inputBorder: AppColors.inputBorder,
    inputFocusBorder: AppColors.inputFocusBorder,
    overlay: AppColors.overlay,
    overlayDark: AppColors.overlayDark,
    shadowLight: AppColors.shadowLight,
  );

  /// Dark theme colors
  static ColorExtension dark = ColorExtension(
    primary: AppColors.primary,
    primaryLight: AppColors.primaryLight,
    primaryDark: AppColors.primaryDark,
    background: AppColors.darkBackground,
    surface: AppColors.darkSurface,
    cardBackground: AppColors.darkCardBackground,
    textPrimary: AppColors.darkTextPrimary,
    textSecondary: AppColors.darkTextSecondary,
    textHint: AppColors.textHint,
    textTertiary: AppColors.textTertiary,
    success: AppColors.success,
    error: AppColors.error,
    warning: AppColors.warning,
    info: AppColors.info,
    border: AppColors.borderDark,
    borderLight: AppColors.borderDark,
    borderDark: AppColors.borderDark,
    inputBackground: AppColors.darkInputBackground,
    inputBorder: AppColors.darkInputBorder,
    inputFocusBorder: AppColors.inputFocusBorder,
    overlay: AppColors.overlay,
    overlayDark: AppColors.overlayDark,
    shadowLight: AppColors.shadowLight,
  );

  @override
  ColorExtension copyWith({
    Color? primary,
    Color? primaryLight,
    Color? primaryDark,
    Color? background,
    Color? surface,
    Color? cardBackground,
    Color? textPrimary,
    Color? textSecondary,
    Color? textHint,
    Color? textTertiary,
    Color? success,
    Color? error,
    Color? warning,
    Color? info,
    Color? border,
    Color? borderLight,
    Color? borderDark,
    Color? inputBackground,
    Color? inputBorder,
    Color? inputFocusBorder,
    Color? overlay,
    Color? overlayDark,
    Color? shadowLight,
  }) {
    return ColorExtension(
      primary: primary ?? this.primary,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryDark: primaryDark ?? this.primaryDark,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      cardBackground: cardBackground ?? this.cardBackground,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textHint: textHint ?? this.textHint,
      textTertiary: textTertiary ?? this.textTertiary,
      success: success ?? this.success,
      error: error ?? this.error,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      border: border ?? this.border,
      borderLight: borderLight ?? this.borderLight,
      borderDark: borderDark ?? this.borderDark,
      inputBackground: inputBackground ?? this.inputBackground,
      inputBorder: inputBorder ?? this.inputBorder,
      inputFocusBorder: inputFocusBorder ?? this.inputFocusBorder,
      overlay: overlay ?? this.overlay,
      overlayDark: overlayDark ?? this.overlayDark,
      shadowLight: shadowLight ?? this.shadowLight,
    );
  }

  @override
  ColorExtension lerp(ColorExtension? other, double t) {
    if (other is! ColorExtension) {
      return this;
    }
    return ColorExtension(
      primary: Color.lerp(primary, other.primary, t) ?? primary,
      primaryLight:
          Color.lerp(primaryLight, other.primaryLight, t) ?? primaryLight,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t) ?? primaryDark,
      background: Color.lerp(background, other.background, t) ?? background,
      surface: Color.lerp(surface, other.surface, t) ?? surface,
      cardBackground:
          Color.lerp(cardBackground, other.cardBackground, t) ?? cardBackground,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t) ?? textPrimary,
      textSecondary:
          Color.lerp(textSecondary, other.textSecondary, t) ?? textSecondary,
      textHint: Color.lerp(textHint, other.textHint, t) ?? textHint,
      textTertiary:
          Color.lerp(textTertiary, other.textTertiary, t) ?? textTertiary,
      success: Color.lerp(success, other.success, t) ?? success,
      error: Color.lerp(error, other.error, t) ?? error,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      info: Color.lerp(info, other.info, t) ?? info,
      border: Color.lerp(border, other.border, t) ?? border,
      borderLight: Color.lerp(borderLight, other.borderLight, t) ?? borderLight,
      borderDark: Color.lerp(borderDark, other.borderDark, t) ?? borderDark,
      inputBackground:
          Color.lerp(inputBackground, other.inputBackground, t) ??
          inputBackground,
      inputBorder: Color.lerp(inputBorder, other.inputBorder, t) ?? inputBorder,
      inputFocusBorder:
          Color.lerp(inputFocusBorder, other.inputFocusBorder, t) ??
          inputFocusBorder,
      overlay: Color.lerp(overlay, other.overlay, t) ?? overlay,
      overlayDark: Color.lerp(overlayDark, other.overlayDark, t) ?? overlayDark,
      shadowLight: Color.lerp(shadowLight, other.shadowLight, t) ?? shadowLight,
    );
  }
}
