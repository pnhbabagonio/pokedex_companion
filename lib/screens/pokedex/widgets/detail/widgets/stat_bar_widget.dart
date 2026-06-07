import 'package:flutter/material.dart';
import '../../../core/constants/type_colors.dart';
import '../../../core/utils/string_extensions.dart';

/// Animated stat bar widget for displaying Pokémon stats
class StatBarWidget extends StatelessWidget {
  final String statName;
  final int statValue;
  final Color? color;
  final int animationDelay;

  const StatBarWidget({
    super.key,
    required this.statName,
    required this.statValue,
    this.color,
    this.animationDelay = 0,
  });

  /// Format stat name for display (e.g., "special-attack" → "Sp. Atk")
  String _formatStatName(String name) {
    switch (name) {
      case 'hp': return 'HP';
      case 'attack': return 'Attack';
      case 'defense': return 'Defense';
      case 'special-attack': return 'Sp. Atk';
      case 'special-defense': return 'Sp. Def';
      case 'speed': return 'Speed';
      default: return name.formatPokemonName();
    }
  }

  /// Get color based on stat value
  Color _getStatColor() {
    if (color != null) return color!;
    if (statValue < 50) return Colors.green;
    if (statValue < 80) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Stat name
          SizedBox(
            width: 70,
            child: Text(
              _formatStatName(statName),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          // Stat value
          SizedBox(
            width: 35,
            child: Text(
              statValue.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 8),
          // Animated stat bar
          Expanded(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: statValue / 255),
              duration: Duration(milliseconds: 800 + animationDelay * 150),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: value,
                    backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                    color: _getStatColor(),
                    minHeight: 8,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}