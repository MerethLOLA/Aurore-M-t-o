import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meteo/components/navigation_button.dart';
import 'package:meteo/screens/loader_screen.dart';
import 'package:meteo/utils/images_constants.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _btnCtrl;
  late AnimationController _glowCtrl;

  late Animation<double> _btnGlow;
  late Animation<double> _glowAnim;

  bool get _isDark => context.read<ThemeProvider>().isDark;

  Color get _accent => AppColors.primaryBlue;
  Color get _accentPurple => const Color(0xFFFF9F6B); // corail crépuscule
  Color get _accentGreen  => const Color(0xFFFFC94D); // or soleil

  Color get _cardBg       => _isDark ? AppColors.glassDark  : AppColors.glassLight;
  Color get _cardBorder   => _isDark ? AppColors.borderDark : AppColors.borderLight;
  Color get _textMain     => _isDark ? Colors.white         : AppColors.slate900;
  Color get _textSub      => _isDark ? Colors.white.withOpacity(0.6) : AppColors.subTextOnLight;

  @override
  void initState() {
    super.initState();

    _btnCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _btnGlow = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _btnCtrl, curve: Curves.easeInOut),
    );

    _glowAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _btnCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

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
                          Colors.black.withOpacity(0.35),
                          Colors.black.withOpacity(0.25),
                          Colors.black.withOpacity(0.6),
                        ]
                      : [
                          Colors.black.withOpacity(0.18),
                          Colors.black.withOpacity(0.02),
                          Colors.black.withOpacity(0.22),
                        ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          _buildStatsRow(),
                          const SizedBox(height: 32),
                          _buildGreeting(),
                          const SizedBox(height: 8),
                          _buildHero(),
                          const SizedBox(height: 40),
                        ],
                      ),
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

  // En-tête compact : nom de l'app + bouton thème sur une seule ligne
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [_accent, _accentPurple],
            ).createShader(bounds),
            child: Text(
              'AURORE MÉTÉO',
              style: GoogleFonts.playfairDisplay(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _glowAnim,
            builder: (context, _) {
              return GestureDetector(
                onTap: () => context.read<ThemeProvider>().toggle(),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _cardBg,
                    border: Border.all(color: _cardBorder),
                    boxShadow: [
                      BoxShadow(
                        color: _accent.withOpacity(0.2 * _glowAnim.value),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Icon(
                    _isDark ? Icons.sunny : Icons.nights_stay_rounded,
                    size: 18,
                    color: _isDark ? _accent : _accentPurple,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Pastilles horizontales de statistiques
  Widget _buildStatsRow() {
    final stats = [
      {'icon': Icons.location_city_rounded, 'value': '5', 'label': 'villes'},
      {'icon': Icons.timer_outlined, 'value': '5s', 'label': 'intervalle'},
      {'icon': Icons.podcasts_rounded, 'value': 'LIVE', 'label': 'données'},
    ];

    return Row(
      children: List.generate(stats.length, (i) {
        final s = stats[i];
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(left: i == 0 ? 0 : 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(s['icon'] as IconData, size: 16, color: _accent),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        s['value'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _textMain,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        s['label'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          color: _textSub,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // Message de bienvenue
  Widget _buildGreeting() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bonjour ☀️',
            style: GoogleFonts.playfairDisplay(
              fontSize: 26,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w700,
              color: _textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'La météo de 5 villes vous attend, en un instant.',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: _textSub,
            ),
          ),
        ],
      ),
    );
  }

  // Carte façon appli météo (grande icône centrale, bandeau de mini-icônes),
  // et bouton flottant en chevauchement
  Widget _buildHero() {
    const miniIcons = [
      Icons.wb_sunny_outlined,
      Icons.cloud_outlined,
      Icons.grain_outlined,
      Icons.filter_drama_outlined,
      Icons.nights_stay_outlined,
    ];

    return Column(
      children: [
        AnimatedBuilder(
          animation: _glowAnim,
          builder: (context, _) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: _cardBorder),
                boxShadow: [
                  BoxShadow(
                    color: _accent.withOpacity(0.35 * _glowAnim.value),
                    blurRadius: 40,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on_rounded, size: 14, color: _textSub),
                      const SizedBox(width: 4),
                      Text(
                        '5 VILLES SUIVIES',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                          color: _textSub,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [_accent, _accentPurple],
                    ).createShader(bounds),
                    child: const Icon(
                      Icons.wb_sunny_rounded,
                      size: 84,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Météo en direct',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w700,
                      color: _textMain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: miniIcons
                        .map((i) => Icon(i, size: 18, color: _textSub.withOpacity(0.7)))
                        .toList(),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        navigationButton(
          'LANCER L\'EXPÉRIENCE',
          LoaderScreen(),
          animation: _btnGlow,
        ),
      ],
    );
  }
}
