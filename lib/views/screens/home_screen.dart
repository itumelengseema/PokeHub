import 'package:flutter/material.dart';
import 'package:pokedex_app/controllers/pokemon_controller.dart';
import 'package:pokedex_app/controllers/favorites_controller.dart';
import 'package:pokedex_app/models/pokemon.dart';
import 'package:pokedex_app/views/widgets/pokemon_card.dart';
import 'package:pokedex_app/views/widgets/search_bar.dart';
import 'package:pokedex_app/services/api_services.dart';
import 'package:pokedex_app/widgets/responsive/responsive_builder.dart';
import 'package:pokedex_app/utils/constants/app_spacing.dart';
import 'package:pokedex_app/utils/constants/app_sizes.dart';
import 'package:pokedex_app/utils/constants/app_text_styles.dart';

class HomeScreen extends StatefulWidget {
  final FavoritesController favoritesController;

  const HomeScreen({super.key, required this.favoritesController});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PokemonController controller = PokemonController();
  final ApiServices _apiServices = ApiServices();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Pokemon> pokemonList = [];
  List<Pokemon> filteredPokemonList = [];
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
    _searchController.dispose();
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

  void _filterPokemon(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredPokemonList = pokemonList;
      } else {
        filteredPokemonList = pokemonList
            .where(
              (pokemon) =>
                  pokemon.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  Future<void> _loadMorePokemon() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newPokemon = await controller.fetchPokemon(
        pokemonList.length,
        _limit,
      );
      setState(() {
        pokemonList.addAll(newPokemon);
        filteredPokemonList = pokemonList;
        _offset += _limit;
        _isLoading = false;
        if (newPokemon.length < _limit) {
          _hasMore = false;
        }
      });

      // Prefetch details for newly loaded Pokemon
      _apiServices.prefetchPokemonDetails(newPokemon);
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
            ? const Center(child: CircularProgressIndicator())
            : ResponsiveBuilder(
                builder: (context, deviceType, size) {
                  return Column(
                    children: [
                      Padding(
                        padding: size.responsivePadding(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              'https://cdn.brandfetch.io/idyp519aAf/w/1024/h/1022/theme/dark/symbol.png?c=1bxid64Mup7aczewSAYMX&t=1721651819488',
                              height: size.responsiveValue(
                                mobile: AppSizes.logoMedium,
                                tablet: AppSizes.logoMedium + 10,
                                desktop: AppSizes.logoMedium,
                              ),
                              width: size.responsiveValue(
                                mobile: AppSizes.logoMedium,
                                tablet: AppSizes.logoMedium + 10,
                                desktop: AppSizes.logoMedium,
                              ),
                            ),
                            SizedBox(
                              width: size.responsiveValue(
                                mobile: AppSpacing.lg,
                                tablet: AppSpacing.xl,
                                desktop: AppSpacing.xxl,
                              ),
                            ),
                            Text(
                              'Pokémon',
                              style: AppTextStyles.displayLarge.copyWith(
                                fontSize: size.responsiveValue(
                                  mobile: AppTextStyles.fontSizeGiant,
                                  tablet: 30.0,
                                  desktop: 28.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: size.responsiveHorizontalPadding(),
                        child: PokemonSearchBar(
                          controller: _searchController,
                          hintText: 'Search Pokémon...',
                          onSearch: _filterPokemon,
                        ),
                      ),
                      SizedBox(
                        height: size.responsiveValue(
                          mobile: AppSpacing.lg,
                          tablet: AppSpacing.xxl,
                          desktop: AppSpacing.xxl,
                        ),
                      ),
                      Expanded(
                        child: filteredPokemonList.isEmpty
                            ? const Center(child: Text('No Pokémon found'))
                            : Center(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: size.contentWidth,
                                  ),
                                  child: GridView.builder(
                                    controller: _scrollController,
                                    padding: EdgeInsets.only(
                                      left: size.responsiveValue(
                                        mobile: AppSpacing.lg,
                                        tablet: AppSpacing.xxl,
                                        desktop: AppSpacing.xxxl,
                                      ),
                                      right: size.responsiveValue(
                                        mobile: AppSpacing.lg,
                                        tablet: AppSpacing.xxl,
                                        desktop: AppSpacing.xxxl,
                                      ),
                                      bottom: AppSpacing.lg,
                                    ),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: size.gridColumns,
                                      childAspectRatio: size.responsiveValue(
                                        mobile: 0.85,
                                        tablet: 0.80,
                                        desktop: 0.75,
                                      ),
                                      crossAxisSpacing: size.responsiveValue(
                                        mobile: AppSpacing.md,
                                        tablet: AppSpacing.lg,
                                        desktop: AppSpacing.xxl,
                                      ),
                                      mainAxisSpacing: size.responsiveValue(
                                        mobile: AppSpacing.md,
                                        tablet: AppSpacing.lg,
                                        desktop: AppSpacing.xxl,
                                      ),
                                    ),
                                    itemCount: filteredPokemonList.length +
                                        (_hasMore &&
                                                _searchController.text.isEmpty
                                            ? 1
                                            : 0),
                                    itemBuilder: (context, index) {
                                      if (index == filteredPokemonList.length) {
                                        return const Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(AppSpacing.lg),
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      }
                                      final pokemon = filteredPokemonList[index];
                                      return PokemonCard(
                                        pokemon: pokemon,
                                        isFavorite: widget.favoritesController
                                            .isFavorite(pokemon),
                                        favoritesController:
                                            widget.favoritesController,
                                        onFavoriteToggle: () async {
                                          await widget.favoritesController
                                              .toggleFavorite(
                                            pokemon,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
