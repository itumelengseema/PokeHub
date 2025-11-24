import 'package:flutter/material.dart';
import 'package:pokedex_app/models/pokemon.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonCard({super.key, required this.pokemon});

  String _getPokemonId() {
    final id = pokemon.url.split('/').where((e) => e.isNotEmpty).last;
    return '#${id.padLeft(3, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[250],
        borderRadius: BorderRadius.circular(16.0),
      ),
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
    );
  }
}
