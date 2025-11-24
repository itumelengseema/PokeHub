import 'package:flutter/material.dart';
import 'package:pokedex_app/models/pokemon.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const PokemonCard({
    super.key,
    required this.pokemon,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  String _getPokemonId() {
    final id = pokemon.url.split('/').where((e) => e.isNotEmpty).last;
    return '#${id.padLeft(3, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (pokemon.imageUrl != null && pokemon.imageUrl!.isNotEmpty)
                  Image.network(
                    pokemon.imageUrl!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.catching_pokemon,
                        size: 100,
                        color: Colors.grey,
                      );
                    },
                  )
                else
                  Icon(Icons.catching_pokemon, size: 100, color: Colors.grey),
                SizedBox(height: 8),
                Text(
                  pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  _getPokemonId(),
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          if (onFavoriteToggle != null)
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: onFavoriteToggle,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                    size: 24,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
