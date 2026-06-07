import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constants/type_colors.dart';
import '../../../core/utils/string_extensions.dart';
import '../../../data/models/pokemon_list_item.dart';
import '../../detail/detail_screen.dart';
import '../../detail/widgets/type_badge_widget.dart';

/// Reusable card widget for displaying a Pokémon in a grid
class PokemonCard extends StatelessWidget {
  final PokemonListItem pokemon;
  final VoidCallback? onTap;

  const PokemonCard({
    super.key,
    required this.pokemon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryType = pokemon.types.first;
    final typeColor = getTypeColor(primaryType);
    
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap ?? () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(pokemonId: pokemon.id),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                typeColor.withOpacity(0.3),
                typeColor.withOpacity(0.1),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pokémon number
              Text(
                '#${pokemon.id.toString().padLeft(3, '0')}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: typeColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Pokémon sprite with Hero animation
              Hero(
                tag: 'pokemon-sprite-${pokemon.id}',
                child: CachedNetworkImage(
                  imageUrl: pokemon.spriteUrl,
                  height: 80,
                  width: 80,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.catching_pokemon,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Pokémon name
              Text(
                pokemon.name.formatPokemonName(),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Type badges
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: pokemon.types
                    .map((type) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: TypeBadgeWidget(type: type, size: 14),
                    ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}