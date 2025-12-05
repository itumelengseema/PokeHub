import 'package:flutter/material.dart';
import 'package:pokedex_app/models/pokemon.dart';
import 'package:pokedex_app/controllers/favorites_controller.dart';
import 'package:pokedex_app/views/screens/details_screen.dart';
import 'package:pokedex_app/views/widgets/favorite_button.dart';

/// A card widget that displays Pokemon information
class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  final bool isFavorite;
  final Future<void> Function()? onFavoriteToggle;
  final FavoritesController? favoritesController;

  const PokemonCard({
    super.key,
    required this.pokemon,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.favoritesController,
  });

  String _getPokemonId() {
    final id = pokemon.url.split('/').where((e) => e.isNotEmpty).last;
    return '#${id.padLeft(3, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (favoritesController != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsScreen(
                pokemon: pokemon,
                favoritesController: favoritesController!,
              ),
            ),
          );
        }
      },
      child: Container(
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
                    Hero(
                      tag: 'pokemon_${pokemon.id}',
                      child: Image.network(
                        pokemon.imageUrl!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.catching_pokemon,
                            size: 100,
                            color: Colors.grey,
                          );
                        },
                      ),
                    )
                  else
                    const Icon(Icons.catching_pokemon, size: 100, color: Colors.grey),
                  const SizedBox(height: 8),
                  Text(
                    pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
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
                child: FavoriteButton(
                  isFavorite: isFavorite,
                  onToggle: onFavoriteToggle!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
