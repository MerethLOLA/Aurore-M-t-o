# Aurore Météo

Examen de Développement Mobile — L3IAGE ISI 2026

---

## Auteurs

1 LOLA SEMERETH Rebecca
2 Arielle GANGUIA Shekina

---

## Présentation

Aurore Météo est une application météo développée avec **Flutter**. Elle récupère en temps réel les données de 5 villes via l'API [Open-Meteo](https://open-meteo.com/) (gratuite, sans clé API), affiche une jauge de progression animée pendant le chargement, puis présente les résultats dans une liste interactive avec accès à une carte de localisation pour chaque ville.

L'interface adopte une identité visuelle inspirée du ciel : bleu, nuages et soleil en mode clair, ciel étoilé en mode sombre.

---

## Fonctionnalités

**Écran d'accueil**
- Message d'accueil animé
- Bouton pour lancer l'expérience

**Chargement des données**
- Jauge de progression animée qui se remplit au fur et à mesure des appels API
- Récupération séquencée des données météo pour 5 villes
- En cas d'échec d'un appel API : écran d'erreur dédié avec message clair et bouton **Réessayer**

**Résultats et détails**
- Liste interactive des 5 villes avec température, condition et icône météo
- Clic sur une ville → écran de détail (ressenti, humidité, vent, pression) + localisation sur une carte interactive
- Bouton **Recommencer** pour relancer une nouvelle session de chargement
- Retour arrière disponible à tout moment pour revenir en arrière dans le parcours

**Thème**
- Mode clair et mode sombre, chacun avec son propre habillage visuel (fond photo, palette de couleurs, typographie)
- Bascule accessible directement depuis l'écran d'accueil

---

## Stack technique

| Technologie | Usage |
|-------------|-------|
| **Flutter / Dart** | Framework et langage principal |
| **http** | Appels à l'API Open-Meteo |
| **provider** | Gestion d'état (thème clair/sombre) |
| **flutter_map** + **latlong2** | Carte interactive de localisation des villes |
| **google_fonts** | Typographies Playfair Display & Poppins |

---

## 🎨 Design

Palette inspirée du ciel — bleu, blanc nuage et or soleil en mode clair, noir étoilé en mode sombre.

| Token | Couleur | Usage |
|-------|---------|-------|
| `neonBlue` | `#4FA8FF` | Bleu ciel — accent principal |
| `neonGreen` | `#FFC94D` | Or soleil — indicateurs positifs |
| `neonPurple` | `#FF9F6B` | Corail crépuscule — accent secondaire |
| `darkNavy` | `#06070C` | Fond principal (mode sombre) |
| `darkPurple` | `#16161F` | Fond secondaire (mode sombre) |
| `lightSky` | `#EAF4FF` | Fond principal (mode clair) |

---

## ⚙️ Installation

1. Cloner le dépôt puis installer les dépendances :
   ```bash
   flutter pub get
   ```
2. Lancer l'application (aucune clé API à configurer, Open-Meteo est libre d'accès) :
   ```bash
   flutter run
   ```

---

## 📁 Structure du projet

```
lib/
├── components/       # Widgets réutilisables (bouton de navigation, ...)
├── model/            # Modèles de données (CityWeather)
├── screens/          # Écrans de l'application (accueil, chargement, villes, carte)
├── service/          # Appels à l'API météo
├── theme/            # Couleurs, thème clair/sombre, ThemeProvider
└── utils/            # Fonctions utilitaires et constantes
```

---

## 📄 Licence

Projet réalisé dans un cadre académique — ISI L3IAGE 2026. Tous droits réservés aux auteurs.
