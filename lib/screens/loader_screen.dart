import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meteo/screens/ville_screen.dart';
import 'package:meteo/utils/utils_function.dart';
import 'package:provider/provider.dart';

import '../model/city_weather.dart';
import '../service/weather_service.dart';
import '../theme/app_colors.dart';
import '../theme/theme_provider.dart';

class WeatherStorage {
  static List<CityWeather> data = [];
}

class LoaderScreen extends StatefulWidget {
  const LoaderScreen({super.key});

  @override
  State<LoaderScreen> createState() => _LoaderScreenState();
}

class _LoaderScreenState extends State<LoaderScreen> {
  final _weatherService = WeatherService();
  final List<CityWeather> _loadedCities = [];
  static const int _totalCities = 5;
  double _progress = 0.0;
  String? _errorMessage;
  bool _isDone = false;

  static const List<String> _loadingMessages = [
    'Nous téléchargeons les données…',
    "C'est presque fini…",
    "Plus que quelques secondes avant d'avoir le résultat…",
  ];
  int _messageIndex = 0;
  Timer? _messageTimer;

  bool get _isDark => context.read<ThemeProvider>().isDark;
  Color get _accent => AppColors.primaryBlue;
  Color get _textMain => _isDark ? Colors.white : AppColors.slate900;
  Color get _textSub => _isDark ? Colors.white.withOpacity(0.6) : AppColors.subTextOnLight;
  bool get _hasError => _errorMessage != null;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    super.dispose();
  }

  void _startLoading() {
    _messageTimer?.cancel();
    setState(() {
      _loadedCities.clear();
      _progress = 0.0;
      _isDone = false;
      _errorMessage = null;
      _messageIndex = 0;
    });
    WeatherStorage.data = [];

    _messageTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      setState(() {
        _messageIndex = (_messageIndex + 1) % _loadingMessages.length;
      });
    });

    _weatherService.meteoVilleSync(
      onCityLoaded: (city, index) {
        if (!mounted) return;
        setState(() {
          _loadedCities.add(city);
          _progress = _loadedCities.length / _totalCities;
        });
      },
    ).then((allCities) {
      if (!mounted) return;
      _messageTimer?.cancel();
      WeatherStorage.data = allCities;
      setState(() {
        _progress = 1.0;
        _isDone = true;
        UtilsFunction.redirectAfterDelay(context, const VilleScreen());
      });
    }).catchError((e) {
      if (!mounted) return;
      _messageTimer?.cancel();
      setState(() {
        _isDone = true;
        _errorMessage = _friendlyError(e);
      });
    });
  }

  String _friendlyError(Object e) {
    final msg = e.toString();
    return msg.startsWith('Exception: ') ? msg.substring(11) : msg;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDark ? AppColors.slate900 : AppColors.slate100,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'AURORE MÉTÉO',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: _textMain,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 60),
              _hasError ? _buildErrorState() : _buildGauge(),
              const SizedBox(height: 40),
              if (!_hasError)
                Text(
                  _isDone ? "CHARGEMENT TERMINÉ" : _loadingMessages[_messageIndex],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _textSub,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGauge() {
    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 180,
            height: 180,
            child: CircularProgressIndicator(
              value: _progress,
              strokeWidth: 10,
              strokeCap: StrokeCap.round,
              color: _accent,
              backgroundColor: _isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.1),
            ),
          ),
          Text(
            '${(_progress * 100).toInt()}%',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: _textMain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.cloud_off_rounded, size: 56, color: _accent.withOpacity(0.8)),
        const SizedBox(height: 16),
        Text(
          "Oups, le chargement a échoué",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: _textMain,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _errorMessage ?? '',
          style: GoogleFonts.poppins(fontSize: 13, color: _textSub),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),
        GestureDetector(
          onTap: _startLoading,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  _accent.withOpacity(0.15),
                  AppColors.neonPurple.withOpacity(0.15),
                ],
              ),
              border: Border.all(color: _accent.withOpacity(0.6), width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.refresh_rounded, color: _accent, size: 18),
                const SizedBox(width: 8),
                Text(
                  "RÉESSAYER",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _accent,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
