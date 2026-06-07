/// Extension methods for String manipulation
extension StringExtensions on String {
  /// Capitalizes the first letter of the string
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  /// Formats a Pokémon name by capitalizing each part separated by hyphens
  /// Example: "tapu-koko" → "Tapu Koko"
  String formatPokemonName() =>
      split('-').map((word) => word.capitalize()).join(' ');
}