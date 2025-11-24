import 'package:flutter/material.dart';
import 'package:pokedex_app/controllers/favorites_controller.dart';
import 'package:pokedex_app/models/pokemon.dart';
import 'package:pokedex_app/views/widgets/pokemon_card.dart';

class FavoritesScreen extends StatefulWidget {
  final FavoritesController favoritesController;

  const FavoritesScreen({super.key, required this.favoritesController});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Pokemon> _filteredFavorites = [];

  @override
  void initState() {
    super.initState();
    _filteredFavorites = widget.favoritesController.favorites;
    widget.favoritesController.addListener(_updateFavorites);
    _searchController.addListener(_filterFavorites);
  }

  @override
  void dispose() {
    widget.favoritesController.removeListener(_updateFavorites);
    _searchController.dispose();
    super.dispose();
  }

  void _updateFavorites() {
    setState(() {
      _filterFavorites();
    });
  }

  void _filterFavorites() {
    setState(() {
      _filteredFavorites = widget.favoritesController.searchFavorites(
        _searchController.text,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.favorite, color: Colors.red, size: 40),
                      SizedBox(width: 16),
                      Text(
                        'Favorites',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // Search Bar
                  SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search favorites...',
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: _filteredFavorites.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            _searchController.text.isEmpty
                                ? 'No favorites yet'
                                : 'No favorites match your search',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            _searchController.text.isEmpty
                                ? 'Add Pokémon to favorites from the home screen'
                                : 'Try a different search term',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.85,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: _filteredFavorites.length,
                      itemBuilder: (context, index) {
                        final pokemon = _filteredFavorites[index];
                        return PokemonCard(
                          pokemon: pokemon,
                          isFavorite: true,
                          onFavoriteToggle: () {
                            widget.favoritesController.toggleFavorite(pokemon);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
