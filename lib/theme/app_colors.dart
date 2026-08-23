
import 'package:flutter/material.dart';

class AppColors {
  // ── Accents dark mode — bleu ciel, or soleil, corail crépuscule ──
  static const neonBlue   = Color(0xFF4FA8FF); // bleu ciel lumineux (accent principal)
  static const neonGreen  = Color(0xFFFFC94D); // or soleil
  static const neonPurple = Color(0xFFFF9F6B); // corail crépuscule (accent chaud secondaire)

  // ── Accents light mode (versions plus profondes des mêmes teintes) ──
  static const lightBlue   = Color(0xFF1B4F8C); // bleu ciel profond lisible sur fond clair
  static const lightGreen  = Color(0xFFB8860B); // or ambré profond
  static const lightPurple = Color(0xFFC1552C); // corail profond

  // ── Dark palette — ciel nocturne étoilé (noir profond) ──
  static const darkNavy   = Color(0xFF06070C);
  static const darkPurple = Color(0xFF16161F);

  // ── Light palette — ciel clair, nuage ──
  static const lightSky      = Color(0xFFEAF4FF); // bleu ciel très pâle
  static const lightLavender = Color(0xFFE4EEF9); // blanc nuage bleuté

  // ── Glass dark — givre argenté façon étoiles ──
  static Color glassDark  = const Color(0xFFE8ECF5).withOpacity(0.06);
  static Color borderDark = const Color(0xFFB8C4DB).withOpacity(0.16);

  // ── Glass light — fond opaque pour lisibilité ──
  static Color glassLight  = Colors.white.withOpacity(0.78);
  static Color borderLight = const Color(0xFF1B4F8C).withOpacity(0.20);

  // ── Texte light mode ──
  static const textOnLight     = Color(0xFF16233A); // bleu nuit quasi noir
  static const accentOnLight   = Color(0xFF1B4F8C); // bleu ciel profond
  static const subTextOnLight  = Color(0xFF5B6B80); // gris ardoise bleuté

  static const Color primaryBlue = Color(0xFF2F86D6); // bleu ciel principal
  static const Color slate900 = Color(0xFF16233A);    // bleu nuit sombre
  static const Color slate100 = Color(0xFFF3F8FD);    // ciel très clair

}
