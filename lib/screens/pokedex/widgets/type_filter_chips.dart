import 'package:flutter/material.dart';

/// Horizontal scrollable filter chips for Pokémon types
class TypeFilterChips extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onTypeSelected;

  const TypeFilterChips({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  static const List<String> _types = [
    'all', 'normal', 'fire', 'water', 'grass', 'electric',
    'ice', 'fighting', 'poison', 'ground', 'flying', 'psychic',
    'bug', 'rock', 'ghost', 'dragon', 'dark', 'steel', 'fairy',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _types.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final type = _types[index];
          final isSelected = type == selectedType;
          return FilterChip(
            label: Text(type == 'all' ? 'All' : type.capitalize()),
            selected: isSelected,
            onSelected: (_) => onTypeSelected(type),
            showCheckmark: false,
          );
        },
      ),
    );
  }
}

// Extension for capitalizing first letter
extension on String {
  String capitalize() => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}