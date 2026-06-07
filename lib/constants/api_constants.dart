/// API constants for PokéAPI integration
class ApiConstants {
  // Base URL for the REST API
  static const String baseUrl = 'https://pokeapi.co/api/v2';
  
  // Endpoints
  static const String pokemonEndpoint = '/pokemon';
  
  // Sprite URLs - constructed directly, no API call needed
  static const String spriteBaseUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon';
  static const String officialArtworkPath = 'other/official-artwork';
  
  // Default limits
  static const int defaultPokemonLimit = 151;
  static const int allPokemonLimit = 898;
  
  // Timeout duration
  static const Duration requestTimeout = Duration(seconds: 10);
  
  /// Extracts Pokémon ID from a PokéAPI URL
  /// Example: "https://pokeapi.co/api/v2/pokemon/25/" → 25
  static int extractIdFromUrl(String url) {
    final segments = url.trimRight('/').split('/');
    return int.parse(segments.last);
  }
  
  /// Builds the sprite URL for a given Pokémon ID
  static String buildSpriteUrl(int id) => '$spriteBaseUrl/$id.png';
  
  /// Builds the official artwork URL for a given Pokémon ID
  static String buildArtworkUrl(int id) => '$spriteBaseUrl/$officialArtworkPath/$id.png';
}