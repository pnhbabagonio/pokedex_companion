import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/hive/hive_service.dart';

/// Provider for app-wide theme mode
/// Persists theme preference to Hive
final themeProvider = StateProvider<ThemeMode>((ref) {
  final saved = HiveService.getThemeMode();
  return saved == 'dark' ? ThemeMode.dark : ThemeMode.light;
});

/// Helper to toggle theme and persist the change
void toggleTheme(WidgetRef ref) {
  final current = ref.read(themeProvider);
  final newMode = current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  ref.read(themeProvider.notifier).state = newMode;
  HiveService.saveThemeMode(newMode == ThemeMode.dark ? 'dark' : 'light');
}