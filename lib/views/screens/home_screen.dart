import 'package:flutter/material.dart';
import 'package:pokedex_app/controllers/pokemon_controller.dart';
import 'package:pokedex_app/controllers/favorites_controller.dart';
import 'package:pokedex_app/models/pokemon.dart';
import 'package:pokedex_app/views/widgets/pokemon_card.dart';
import 'package:pokedex_app/views/widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  final FavoritesController favoritesController;

  const HomeScreen({super.key, required this.favoritesController});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PokemonController controller = PokemonController();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Pokemon> pokemonList = [];
  int _offset = 0;
  final int _limit = 20;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadMorePokemon();
    _scrollController.addListener(_onScroll);
    widget.favoritesController.addListener(_onFavoritesChanged);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    widget.favoritesController.removeListener(_onFavoritesChanged);
    super.dispose();
  }

  void _onFavoritesChanged() {
    setState(() {});
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      _loadMorePokemon();
    }
  }

  Future<void> _loadMorePokemon() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newPokemon = await controller.fetchPokemon(_offset, _limit);
      setState(() {
        pokemonList.addAll(newPokemon);
        _offset += _limit;
        _isLoading = false;
        if (newPokemon.length < _limit) {
          _hasMore = false;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load Pokémon: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: pokemonList.isEmpty && _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Image.network(
                          'https://cdn.brandfetch.io/idyp519aAf/w/1024/h/1022/theme/dark/symbol.png?c=1bxid64Mup7aczewSAYMX&t=1721651819488',
                          height: 80,
                          width: 80,
                        ),
                        SizedBox(width: 16),
                        Text(
                          'Pokémon',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: PokemonSearchBar(),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: pokemonList.isEmpty
                        ? Center(child: Text('No Pokémon found'))
                        : GridView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                              bottom: 16.0,
                            ),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.85,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                            itemCount: pokemonList.length + (_hasMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == pokemonList.length) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              final pokemon = pokemonList[index];
                              return PokemonCard(
                                pokemon: pokemon,
                                isFavorite: widget.favoritesController
                                    .isFavorite(pokemon),
                                onFavoriteToggle: () {
                                  widget.favoritesController.toggleFavorite(
                                    pokemon,
                                  );
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
