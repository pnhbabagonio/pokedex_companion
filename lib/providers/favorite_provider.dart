import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/hive/hive_service.dart';

/// Notifier for managing favorite Pokémon IDs
class FavoritesNotifier extends StateNotifier<List<int>> {
  FavoritesNotifier() : super(HiveService.getFavoriteIds());

  /// Add a Pokémon ID to favorites
  void addFavorite(int id) {
    if (!state.contains(id)) {
      state = [...state, id];
      _saveToHive();
    }
  }

  /// Remove a Pokémon ID from favorites
  void removeFavorite(int id) {
    state = state.where((item) => item != id).toList();
    _saveToHive();
  }

  /// Check if a Pokémon ID is in favorites
  bool isFavorite(int id) => state.contains(id);

  /// Clear all favorites
  void clearAll() {
    state = [];
    _saveToHive();
  }

  /// Persist current state to Hive
  void _saveToHive() {
    HiveService.saveFavoriteIds(state);
  }
}

/// Provider for favorites list
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<int>>((ref) {
  return FavoritesNotifier();
});