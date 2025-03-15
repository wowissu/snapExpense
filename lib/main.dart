import 'package:counting/AccountingPage.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // CurrencyHelper.init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: mainThemeData,
      darkTheme: draculaSoftTheme, // Dark theme
      themeMode: ThemeMode.dark,
      home: const AccountingPage(),
    );
  }
}

final ThemeData mainThemeData = ThemeData(
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF00C9A7), // Turquoise Green
    onPrimary: Color(0xFFFFFFFF), // White text/icons on primary
    secondary: Color(0xFFFF6F61), // Coral Red
    onSecondary: Color(0xFFFFFFFF), // White text/icons on secondary
    tertiary: Color(0xFFFFD700), // Bright Yellow
    onTertiary: Color(0xFF333333), // Dark text/icons on tertiary
    error: Color(0xFFD32F2F), // Deep Red
    onError: Color(0xFFFFFFFF), // White text/icons on error
    surface: Color(0xFFFFFFFF), // White background for cards, sheets
    onSurface: Color(0xFF333333), // Dark text/icons on surface
    surfaceVariant: Color(0xFFE0E0E0), // Light gray for subtle areas
    onSurfaceVariant: Color(0xFF555555), // Darker text/icons on surfaceVariant
    outline: Color(0xFF757575), // Mid-gray for borders
    inverseSurface: Color(0xFF121212), // Dark mode background
    onInverseSurface: Color(0xFFE0E0E0), // Light text/icons for dark surfaces
    inversePrimary: Color(0xFF00796B), // A darker shade of primary
    shadow: Color(0xFF000000), // Black for shadows
    scrim: Color(0x66000000), // Semi-transparent black
  ),
  scaffoldBackgroundColor: Color(0xFFF9F9F9), // Soft white for backgrounds
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF333333), fontSize: 18),
    bodyMedium: TextStyle(color: Color(0xFF555555), fontSize: 16),
  ),
  useMaterial3: true, // Enable Material 3 styling
);

final ThemeData mainDarkThemeData = ThemeData(
  colorScheme: ColorScheme(
    brightness: Brightness.dark, // Dark mode
    primary: Color(0xFF00C9A7), // Turquoise Green
    onPrimary: Color(0xFF00332E), // Darker shade for contrast
    secondary: Color(0xFFFF6F61), // Coral Red
    onSecondary: Color(0xFF5E1410), // Dark red for contrast
    tertiary: Color(0xFFFFD700), // Bright Yellow
    onTertiary: Color(0xFF332900), // Darker yellow for contrast
    error: Color(0xFFCF6679), // Softer Red for Dark Mode
    onError: Color(0xFF370B0E), // Deep red for contrast
    surface: Color(0xFF121212), // Dark background for cards, sheets
    onSurface: Color(0xFFE0E0E0), // Light text/icons on dark surfaces
    surfaceVariant: Color(0xFF2C2C2C), // Dark gray for secondary surfaces
    onSurfaceVariant: Color(0xFFBDBDBD), // Lighter text/icons on surfaceVariant
    outline: Color(0xFF757575), // Mid-gray for borders
    inverseSurface: Color(0xFFE0E0E0), // Light surface for contrast
    onInverseSurface: Color(0xFF121212), // Dark text/icons on light surfaces
    inversePrimary: Color(0xFF00796B), // A muted version of the primary color
    shadow: Color(0xFF000000), // Black shadows
    scrim: Color(0x66000000), // Semi-transparent black
  ),
  scaffoldBackgroundColor: Color(0xFF121212), // Deep dark background
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Color(0xFFE0E0E0), fontSize: 18),
    bodyMedium: TextStyle(color: Color(0xFFBDBDBD), fontSize: 16),
  ),
  useMaterial3: true, // Enable Material 3 styling
);

final ThemeData draculaSoftTheme = ThemeData(
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFBD93F9), // Soft Purple
    onPrimary: Color(0xFF1E1F29), // Darker Background for contrast
    secondary: Color(0xFF50FA7B), // Soft Green
    onSecondary: Color(0xFF1E1F29), // Darker Background
    tertiary: Color(0xFFFFB86C), // Soft Orange
    onTertiary: Color(0xFF1E1F29), // Darker Background
    error: Color(0xFFFF5555), // Soft Red
    onError: Color(0xFF1E1F29), // Dark Background for error contrast
    surface: Color(0xFF282A36), // Dark background for cards, sheets
    onSurface: Color(0xFFF8F8F2), // Light text/icons on dark surfaces
    outline: Color(0xFF6272A4), // Soft blue-gray for borders
    inverseSurface: Color(0xFFF8F8F2), // Light background for contrast
    onInverseSurface: Color(0xFF1E1F29), // Dark text/icons on light backgrounds
    inversePrimary: Color(0xFF8B6FCF), // Muted version of primary
    shadow: Color(0xFF000000), // Black shadows
    scrim: Color(0x66000000), // Semi-transparent black
  ),
  scaffoldBackgroundColor: Color(0xFF282A36), // Darker Background
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Color(0xFFF8F8F2), fontSize: 18),
    bodyMedium: TextStyle(color: Color(0xFFD7D7D7), fontSize: 16),
    bodySmall: TextStyle(color: Color(0xFFBFBFBF), fontSize: 14),
    titleLarge: TextStyle(color: Color(0xFFF8F8F2), fontSize: 22, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(color: Color(0xFFD7D7D7), fontSize: 20, fontWeight: FontWeight.bold),
    titleSmall: TextStyle(color: Color(0xFFBFBFBF), fontSize: 18, fontWeight: FontWeight.bold),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF44475A), // Current Line
    iconTheme: IconThemeData(color: Color(0xFFF8F8F2)), // Foreground
  ),
  iconTheme: IconThemeData(color: Color(0xFFF8F8F2)), // Foreground
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFBD93F9), // Soft Purple
    foregroundColor: Color(0xFF1E1F29), // Dark Background
  ),
  useMaterial3: true, // Enable Material 3 styling
);
