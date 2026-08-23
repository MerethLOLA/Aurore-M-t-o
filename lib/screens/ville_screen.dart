
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meteo/components/navigation_button.dart';
import 'package:meteo/model/city_weather.dart';
import 'package:meteo/screens/home_screen.dart';
import 'package:meteo/screens/loader_screen.dart';
import 'package:meteo/screens/map_screen.dart';
import 'package:meteo/theme/app_colors.dart';
import 'package:meteo/theme/theme_provider.dart';
import 'package:meteo/utils/utils_function.dart';
import 'package:provider/provider.dart';

class VilleScreen extends StatefulWidget {
  const VilleScreen({super.key});

  @override
  State<VilleScreen> createState() => _VilleScreenState();
}

class _VilleScreenState extends State<VilleScreen> {
  bool get _isDark => context.read<ThemeProvider>().isDark;

  Color get _accent => AppColors.primaryBlue;
  Color get _textMain => _isDark ? Colors.white : AppColors.textOnLight;
  Color get _textSub => _isDark ? Colors.white.withOpacity(0.6) : AppColors.subTextOnLight;
  // Fallback direct sur la couleur hexadécimale de Slate 800
  Color get _cardBg => _isDark ? const Color(0xFF1E293B) : Colors.white;
  Color get _cardBorder => _isDark ? AppColors.borderDark : AppColors.borderLight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDark ? AppColors.slate900 : AppColors.slate100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(CupertinoIcons.arrow_left, color: _textMain),
          // Correction : onPressed au lieu de onTap
          onPressed: () => UtilsFunction.navigation(context, const HomeScreen()),
        ),
        title: Text(
          'VILLES',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: _textMain,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: WeatherStorage.data.length,
              itemBuilder: (context, index) {
                return cityCard(context, WeatherStorage.data[index]);
              },
            ),
            const SizedBox(height: 30),
            navigationButton(
              "RECOMMENCER",
              const LoaderScreen(),
              icon: Icons.restart_alt,
            ),
          ],
        ),
      ),
    );
  }

  Widget cityCard(BuildContext context, CityWeather c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => UtilsFunction.navigation(context, MapScreen(cityWeather: c)),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _cardBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Image.network(c.iconUrl, width: 48, height: 48),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.city,
                      style: GoogleFonts.poppins(
                        color: _textMain,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      c.condition,
                      style: GoogleFonts.poppins(
                        color: _textSub,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${c.temperature.toInt()}°",
                    style: GoogleFonts.poppins(
                      color: _accent,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    "↑${c.tempMax}° ↓${c.tempMin}°",
                    style: GoogleFonts.poppins(
                      color: _textSub,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
