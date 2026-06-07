import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/favorites_provider.dart';
import '../../data/models/pokemon_detail.dart';
import '../../data/repositories/pokemon_repository.dart';
import '../../core/constants/type_colors.dart';
import '../../core/utils/string_extensions.dart';
import 'widgets/type_badge_widget.dart';
import 'widgets/stat_bar_widget.dart';

/// Future provider for fetching a single Pokémon's detail
final pokemonDetailProvider = FutureProvider.family<PokemonDetail, int>((ref, id) {
  final repository = PokemonRepository();
  return repository.fetchPokemonDetail(id);
});

/// Detail screen showing comprehensive Pokémon information
class DetailScreen extends ConsumerWidget {
  final int pokemonId;

  const DetailScreen({
    super.key,
    required this.pokemonId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(pokemonDetailProvider(pokemonId));
    final favoritesNotifier = ref.watch(favoritesProvider.notifier);
    final isFavorite = ref.watch(favoritesProvider).contains(pokemonId);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isFavorite) {
            favoritesNotifier.removeFavorite(pokemonId);
          } else {
            favoritesNotifier.addFavorite(pokemonId);
          }
        },
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red : null,
        ),
      ),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Failed to load Pokémon details'),
              TextButton(
                onPressed: () => ref.invalidate(pokemonDetailProvider(pokemonId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (pokemon) => _buildDetailContent(context, pokemon, isFavorite),
      ),
    );
  }

  Widget _buildDetailContent(BuildContext context, PokemonDetail pokemon, bool isFavorite) {
    final primaryType = pokemon.types.first;
    final typeColor = getTypeColor(primaryType);

    return CustomScrollView(
      slivers: [
        // Collapsing header with Pokémon image
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          backgroundColor: typeColor,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [typeColor, typeColor.withOpacity(0.7)],
                ),
              ),
              child: Hero(
                tag: 'pokemon-sprite-${pokemon.id}',
                child: CachedNetworkImage(
                  imageUrl: pokemon.spriteUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.catching_pokemon,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        // Content sections
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and number
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      pokemon.name.formatPokemonName(),
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '#${pokemon.id.toString().padLeft(3, '0')}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Type badges
                Row(
                  children: pokemon.types
                      .map((type) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: TypeBadgeWidget(type: type, size: 14),
                      ))
                      .toList(),
                ),
                const SizedBox(height: 24),
                // About section
                Text(
                  'About',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInfoColumn(context, 'Height', pokemon.formattedHeight),
                        _buildInfoColumn(context, 'Weight', pokemon.formattedWeight),
                        _buildInfoColumn(
                          context,
                          'Abilities',
                          pokemon.abilities.map((a) => a.formatPokemonName()).join('\n'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Base Stats section
                Text(
                  'Base Stats',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        StatBarWidget(
                          statName: 'hp',
                          statValue: pokemon.stats['hp'] ?? 0,
                          animationDelay: 0,
                        ),
                        StatBarWidget(
                          statName: 'attack',
                          statValue: pokemon.stats['attack'] ?? 0,
                          animationDelay: 1,
                        ),
                        StatBarWidget(
                          statName: 'defense',
                          statValue: pokemon.stats['defense'] ?? 0,
                          animationDelay: 2,
                        ),
                        StatBarWidget(
                          statName: 'special-attack',
                          statValue: pokemon.stats['special-attack'] ?? 0,
                          animationDelay: 3,
                        ),
                        StatBarWidget(
                          statName: 'special-defense',
                          statValue: pokemon.stats['special-defense'] ?? 0,
                          animationDelay: 4,
                        ),
                        StatBarWidget(
                          statName: 'speed',
                          statValue: pokemon.stats['speed'] ?? 0,
                          animationDelay: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Moves section
                Text(
                  'Moves',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: pokemon.moves
                      .map((move) => Chip(
                        label: Text(move.formatPokemonName()),
                        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                      ))
                      .toList(),
                ),
                const SizedBox(height: 80), // Space for FAB
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Helper to build info columns in the About section
  Widget _buildInfoColumn(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}