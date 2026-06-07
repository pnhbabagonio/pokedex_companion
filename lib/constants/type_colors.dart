import 'package:flutter/material.dart';

/// Color mapping for all 18 Pokémon types
const Map<String, Color> typeColors = {
  'normal':   Color(0xFF9099A1),
  'fire':     Color(0xFFFF9C54),
  'water':    Color(0xFF4D90D5),
  'grass':    Color(0xFF63BB5B),
  'electric': Color(0xFFF3D23B),
  'ice':      Color(0xFF74CEC0),
  'fighting': Color(0xFFCE4069),
  'poison':   Color(0xFFAB6AC8),
  'ground':   Color(0xFFD97845),
  'flying':   Color(0xFF8FA8DD),
  'psychic':  Color(0xFFFA7179),
  'bug':      Color(0xFF91C12F),
  'rock':     Color(0xFFC5B78C),
  'ghost':    Color(0xFF5269AC),
  'dragon':   Color(0xFF0A6DC4),
  'dark':     Color(0xFF5A5465),
  'steel':    Color(0xFF5A8EA2),
  'fairy':    Color(0xFFEC8FE6),
};

/// Returns the color for a Pokémon type, defaulting to normal type color
Color getTypeColor(String type) =>
    typeColors[type.toLowerCase()] ?? typeColors['normal']!;