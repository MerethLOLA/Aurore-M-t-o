import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:meteo/screens/home_screen.dart';
import 'package:meteo/theme/theme_provider.dart';

void main() {
  testWidgets(
    "L'écran d'accueil affiche le nom de l'app et le bouton de lancement",
    (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
          child: const MaterialApp(home: HomeScreen()),
        ),
      );
      // Un seul pump : les animations tournent en boucle et ne se
      // "stabilisent" jamais, donc pumpAndSettle() resterait bloqué.
      await tester.pump();

      expect(find.text('AURORE MÉTÉO'), findsOneWidget);
      expect(find.text("LANCER L'EXPÉRIENCE"), findsOneWidget);
    },
  );
}
