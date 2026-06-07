import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/game_stats.dart';
import '../data/hive/hive_service.dart';

/// Notifier for managing game statistics
class GameStatsNotifier extends StateNotifier<GameStats> {
  GameStatsNotifier() : super(HiveService.getGameStats());

  /// Update game statistics after a game session
  void updateStats(int sessionScore, int correctAnswers) {
    final newStats = GameStats(
      highScore: sessionScore > state.highScore ? sessionScore : state.highScore,
      totalGamesPlayed: state.totalGamesPlayed + 1,
      totalCorrectAnswers: state.totalCorrectAnswers + correctAnswers,
    );
    state = newStats;
    _saveToHive(newStats);
  }

  /// Reset all game statistics
  void reset() {
    final newStats = GameStats();
    state = newStats;
    _saveToHive(newStats);
  }

  /// Persist game stats to Hive
  void _saveToHive(GameStats stats) {
    HiveService.saveGameStats(stats);
  }
}

/// Provider for game statistics
final gameStatsProvider = StateNotifierProvider<GameStatsNotifier, GameStats>((ref) {
  return GameStatsNotifier();
});