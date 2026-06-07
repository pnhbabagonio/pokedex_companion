import 'package:hive/hive.dart';
import '../models/game_stats.dart';

/// Service class for Hive database operations
class HiveService {
  // Box names as constants
  static const String favoritesBox = 'favorites';
  static const String settingsBox = 'settings';
  static const String gameStatsBox = 'gameStats';
  
  // Keys within boxes
  static const String favoriteIdsKey = 'ids';
  static const String themeModeKey = 'themeMode';
  static const String gameStatsKey = 'stats';

  /// Initialize all Hive boxes
  static Future<void> initialize() async {
    await Hive.openBox<dynamic>(favoritesBox);
    await Hive.openBox<dynamic>(settingsBox);
    await Hive.openBox<GameStats>(gameStatsBox);
  }

  /// Get favorites box
  static Box<dynamic> getFavoritesBox() => Hive.box<dynamic>(favoritesBox);

  /// Get settings box
  static Box<dynamic> getSettingsBox() => Hive.box<dynamic>(settingsBox);

  /// Get game stats box
  static Box<GameStats> getGameStatsBox() => Hive.box<GameStats>(gameStatsBox);

  /// Get list of favorite Pokémon IDs
  static List<int> getFavoriteIds() {
    final box = getFavoritesBox();
    final ids = box.get(favoriteIdsKey, defaultValue: <int>[]) as List<dynamic>;
    return ids.cast<int>();
  }

  /// Save list of favorite Pokémon IDs
  static Future<void> saveFavoriteIds(List<int> ids) async {
    final box = getFavoritesBox();
    await box.put(favoriteIdsKey, ids);
  }

  /// Get theme mode from settings
  static String getThemeMode() {
    final box = getSettingsBox();
    return box.get(themeModeKey, defaultValue: 'light') as String;
  }

  /// Save theme mode to settings
  static Future<void> saveThemeMode(String mode) async {
    final box = getSettingsBox();
    await box.put(themeModeKey, mode);
  }

  /// Get game stats
  static GameStats getGameStats() {
    final box = getGameStatsBox();
    return box.get(gameStatsKey) ?? GameStats();
  }

  /// Save game stats
  static Future<void> saveGameStats(GameStats stats) async {
    final box = getGameStatsBox();
    await box.put(gameStatsKey, stats);
  }
}