import '../../core/constants/api_constants.dart';

/// Lightweight model for displaying Pokémon in lists and grids
class PokemonListItem {
  final int id;
  final String name;
  final List<String> types;

  const PokemonListItem({
    required this.id,
    required this.name,
    required this.types,
  });

  /// URL for the pixel sprite image
  String get spriteUrl => ApiConstants.buildSpriteUrl(id);

  /// URL for the official high-resolution artwork
  String get officialArtUrl => ApiConstants.buildArtworkUrl(id);

  /// Creates a PokemonListItem from JSON data
  factory PokemonListItem.fromJson(Map<String, dynamic> json) {
    final types = (json['types'] as List<dynamic>)
        .map((t) => (t['type']['name'] as String).toLowerCase())
        .toList();
    
    return PokemonListItem(
      id: json['id'] as int,
      name: (json['name'] as String).toLowerCase(),
      types: types,
    );
  }
}