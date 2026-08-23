import 'package0/flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meteo/model/city_weather.dart';
import 'package:meteo/theme/app_colors.dart';
import 'package:meteo/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  final CityWeather cityWeather;
  const MapScreen({super.key, required this.cityWeather});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController mapController = MapController();
  bool get _isDark => context.read<ThemeProvider>().isDark;

  Color get _accent => AppColors.primaryBlue;
  Color get _textMain => _isDark ? Colors.white : AppColors.slate900;
  Color get _cardBg => _isDark ? const Color(0xFF1E293B) : Colors.white;
  Color get _cardBorder => _isDark ? AppColors.borderDark : AppColors.borderLight;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => _buildBottomSheet(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: LatLng(widget.cityWeather.lat, widget.cityWeather.lon),
              initialZoom: 12,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(widget.cityWeather.lat, widget.cityWeather.lon),
                    width: 60,
                    height: 60,
                    child: Icon(Icons.location_on, color: _accent, size: 50),
                  ),
                ],
              ),
            ],
          ),
          Positioned(top: 50, left: 20, child: _circularButton(Icons.arrow_back, () => Navigator.pop(context))),
          Positioned(top: 50, right: 20, child: _circularButton(_isDark ? Icons.sunny : Icons.nights_stay, () => context.read<ThemeProvider>().toggle())),
        ],
      ),
    );
  }

  Widget _circularButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _cardBg,
          shape: BoxShape.circle,
          border: Border.all(color: _cardBorder),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
        ),
        child: Icon(icon, color: _textMain, size: 20),
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          Text(widget.cityWeather.city, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w800, color: _textMain)),
          const SizedBox(height: 20),
          Flexible(
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.6,
              children: [
                _detailCard("Ressenti", "${widget.cityWeather.feelLike.toInt()}°"),
                _detailCard("Humidité", "${widget.cityWeather.humidity.toInt()}%"),
                _detailCard("Vent", "${widget.cityWeather.windSpeed} m/s"),
                _detailCard("Pression", "${widget.cityWeather.pressure.toInt()} hPa"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 12, color: _isDark ? Colors.white60 : Colors.black54, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: _textMain)),
        ],
      ),
    );
  }
}
