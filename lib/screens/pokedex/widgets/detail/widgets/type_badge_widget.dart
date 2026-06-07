import 'package:flutter/material.dart';
import '../../../core/constants/type_colors.dart';
import '../../../core/utils/string_extensions.dart';

/// Small colored badge displaying a Pokémon type
class TypeBadgeWidget extends StatelessWidget {
  final String type;
  final double size;

  const TypeBadgeWidget({
    super.key,
    required this.type,
    this.size = 12,
  });

  @override
  Widget build(BuildContext context) {
    final typeColor = getTypeColor(type);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size * 0.75,
        vertical: size * 0.25,
      ),
      decoration: BoxDecoration(
        color: typeColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        type.formatPokemonName(),
        style: TextStyle(
          color: Colors.white,
          fontSize: size,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}