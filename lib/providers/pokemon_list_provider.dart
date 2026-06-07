import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/pokemon_list_item.dart';
import '../data/repositories/pokemon_repository.dart';

/// Notifier for managing the Pokémon list with pagination
class PokemonListNotifier extends AsyncNotifier<List<PokemonListItem>> {
  int _currentOffset = 0;
  final PokemonRepository _repository = PokemonRepository();

  @override
  Future<List<PokemonListItem>> build() async {
    _currentOffset = 0;
    return _fetchPokemonList();
  }

  /// Fetch the initial list of Pokémon
  Future<List<PokemonListItem>> _fetchPokemonList() async {
    return await _repository.fetchPokemonList(limit: 151, offset: _currentOffset);
  }

  /// Load more Pokémon (next page)
  Future<void> loadMore() async {
    _currentOffset += 100;
    final newPokemon = await _repository.fetchPokemonList(
      limit: 100,
      offset: _currentOffset,
    );
    state = AsyncData([...state.value ?? [], ...newPokemon]);
  }
}

/// Provider for the Pokémon list
final pokemonListProvider = AsyncNotifierProvider<PokemonListNotifier, List<PokemonListItem>>(
  () => PokemonListNotifier(),
);