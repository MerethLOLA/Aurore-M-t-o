
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
import 'package:meteo/utils/images_constants.dart';
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
  Color get _accentPurple => const Color(0xFFFF9F6B);
  Color get _textMain => _isDark ? Colors.white : AppColors.textOnLight;
  Color get _textSub => _isDark ? Colors.white.withOpacity(0.6) : AppColors.subTextOnLight;
  Color get _cardBg => _isDark ? AppColors.glassDark : AppColors.glassLight;
  Color get _cardBorder => _isDark ? AppColors.borderDark : AppColors.borderLight;

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              isDark ? ImagesConstants.bgHomeDark : ImagesConstants.bgHomeLight,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          Colors.black.withOpacity(0.45),
                          Colors.black.withOpacity(0.35),
                          Colors.black.withOpacity(0.65),
                        ]
                      : [
                          Colors.black.withOpacity(0.12),
                          Colors.black.withOpacity(0.05),
                          Colors.black.withOpacity(0.28),
                        ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
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
                        const SizedBox(height: 20),
                        navigationButton(
                          "RECOMMENCER",
                          const LoaderScreen(),
                          icon: Icons.restart_alt,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 24, 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(CupertinoIcons.arrow_left, color: _textMain),
            onPressed: () => UtilsFunction.navigation(context, const HomeScreen()),
          ),
          Expanded(
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [_accent, _accentPurple],
              ).createShader(bounds),
              child: Text(
                'Vos villes',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget cityCard(BuildContext context, CityWeather c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: () => UtilsFunction.navigation(context, MapScreen(cityWeather: c)),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _cardBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _accent.withOpacity(0.12),
                ),
                child: Icon(c.weatherIcon, color: _accent, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.city,
                      style: GoogleFonts.playfairDisplay(
                        color: _textMain,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      c.condition,
                      style: GoogleFonts.poppins(
                        color: _textSub,
                        fontSize: 13,
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
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    "↑${c.tempMax}° ↓${c.tempMin}°",
                    style: GoogleFonts.poppins(
                      color: _textSub,
                      fontSize: 11,
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
