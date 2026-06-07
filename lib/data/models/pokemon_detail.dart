/// Comprehensive model containing all Pokémon details for the detail screen
class PokemonDetail {
  final int id;
  final String name;
  final List<String> types;
  final int height;      // decimeters
  final int weight;      // hectograms
  final List<String> abilities;
  final Map<String, int> stats; // hp, attack, defense, special-attack, special-defense, speed
  final List<String> moves;     // first 8 moves
  final String spriteUrl;

  const PokemonDetail({
    required this.id,
    required this.name,
    required this.types,
    required this.height,
    required this.weight,
    required this.abilities,
    required this.stats,
    required this.moves,
    required this.spriteUrl,
  });

  /// Formatted height in meters (converted from decimeters)
  String get formattedHeight => '${(height / 10).toStringAsFixed(1)} m';
  
  /// Formatted weight in kilograms (converted from hectograms)
  String get formattedWeight => '${(weight / 10).toStringAsFixed(1)} kg';

  /// Creates a PokemonDetail from JSON data
  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    // Parse types
    final types = (json['types'] as List<dynamic>)
        .map((t) => (t['type']['name'] as String).toLowerCase())
        .toList();

    // Parse abilities
    final abilities = (json['abilities'] as List<dynamic>)
        .map((a) => (a['ability']['name'] as String).toLowerCase())
        .toList();

    // Parse stats into a map
    final statsList = json['stats'] as List<dynamic>;
    final stats = <String, int>{};
    for (final stat in statsList) {
      final name = stat['stat']['name'] as String;
      final value = stat['base_stat'] as int;
      stats[name] = value;
    }

    // Parse first 8 moves
    final moves = (json['moves'] as List<dynamic>)
        .take(8)
        .map((m) => (m['move']['name'] as String).toLowerCase())
        .toList();

    return PokemonDetail(
      id: json['id'] as int,
      name: (json['name'] as String).toLowerCase(),
      types: types,
      height: json['height'] as int,
      weight: json['weight'] as int,
      abilities: abilities,
      stats: stats,
      moves: moves,
      spriteUrl: json['sprites']['other']['official-artwork']['front_default'] as String? 
          ?? json['sprites']['front_default'] as String,
    );
  }
}