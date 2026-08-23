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
                _buildStatusBar(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          _buildLogo(),
                          const SizedBox(height: 28),
                          _buildGlobe(),
                          const SizedBox(height: 28),
                          _buildRobotSection(),
                          const SizedBox(height: 32),
                          navigationButton('LANCER L\'EXPÉRIENCE', LoaderScreen(), animation: _btnGlow),
                          const SizedBox(height: 24),
                          _buildStatsCards(),
                          const SizedBox(height: 30),
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

  // Barre du haut avec le bouton thème
  Widget _buildStatusBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
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

  // Logo de l'application
  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _glowAnim,
      builder: (context, _) {
        return Column(
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [_accent, _accentPurple],
              ).createShader(bounds),
              child: Text(
                'WEATHERVERSE',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      color: _accent.withOpacity(
                        _glowAnim.value * (_isDark ? 1.0 : 0.4),
                      ),
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'MÉTÉO EN DOUCEUR',
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: _textSub,
                letterSpacing: 5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }

  // Globe stylisé (illustration plate) avec halo lumineux animé
  Widget _buildGlobe() {
    return SizedBox(
      height: 240,
      child: Center(
        child: AnimatedBuilder(
          animation: _glowAnim,
          builder: (context, _) {
            return Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _accent.withOpacity(0.45 * _glowAnim.value),
                    blurRadius: 50,
                    spreadRadius: 6,
                  ),
                  BoxShadow(
                    color: _accentPurple.withOpacity(0.2 * _glowAnim.value),
                    blurRadius: 30,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  ImagesConstants.globeFlat,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Robot + bulle de dialogue
  Widget _buildRobotSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 90,
          height: 108,
          child: Image.asset(
            ImagesConstants.robot,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.medium,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(color: _cardBorder),
              boxShadow: [
                BoxShadow(
                  color: _accent.withOpacity(0.08),
                  blurRadius: 15,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _accentGreen,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'BLOBI',
                      style: GoogleFonts.poppins(
                        fontSize: 8,
                        color: _accentGreen,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Bonjour ! Je suis ton ami BLOBI',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _textMain,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Prêt pour la météo? ',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _textMain,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Je surveille 5 villes pour toi en temps réel !',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: _textSub,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    final stats = [
      {'icon': '🌍', 'value': '5', 'label': 'VILLES'},
      {'icon': '⏱️', 'value': '5s', 'label': 'INTERVALLE'},
      {'icon': '📡', 'value': 'LIVE', 'label': 'DONNÉES'},
    ];

    return Row(
      children: List.generate(stats.length, (i) {
        final s = stats[i];
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
              left: i == 0 ? 0 : 6,
              right: i == stats.length - 1 ? 0 : 6,
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _cardBorder),
              boxShadow: [
                BoxShadow(
                  color: _accentPurple.withOpacity(0.07),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(s['icon']!, style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 6),
                Text(
                  s['value']!,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _accent,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  s['label']!,
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                    color: _textSub,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
