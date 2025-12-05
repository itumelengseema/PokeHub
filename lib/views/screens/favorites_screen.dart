import 'package:flutter/material.dart';
import 'package:pokedex_app/controllers/favorites_controller.dart';
import 'package:pokedex_app/models/pokemon.dart';
import 'package:pokedex_app/views/widgets/pokemon_card.dart';
import 'package:pokedex_app/views/widgets/search_bar.dart';
import 'package:pokedex_app/widgets/responsive/responsive_builder.dart';
import 'package:pokedex_app/utils/constants/app_spacing.dart';
import 'package:pokedex_app/utils/constants/app_sizes.dart';
import 'package:pokedex_app/utils/constants/app_text_styles.dart';

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
        child: ResponsiveBuilder(
          builder: (context, deviceType, size) {
            return Column(
              children: [
                Padding(
                  padding: size.responsivePadding(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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

                      // Search Bar
                      SizedBox(
                        height: size.responsiveValue(
                          mobile: AppSpacing.lg,
                          tablet: AppSpacing.xxl,
                          desktop: AppSpacing.xxl,
                        ),
                      ),
                      PokemonSearchBar(
                        controller: _searchController,
                        hintText: 'Search favorites...',
                        onSearch: (query) {
                          _filterFavorites();
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.responsiveValue(
                    mobile: AppSpacing.sm,
                    tablet: AppSpacing.lg,
                    desktop: AppSpacing.lg,
                  ),
                ),
                Expanded(
                  child: widget.favoritesController.isLoading
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(),
                              SizedBox(
                                height: size.responsiveValue(
                                  mobile: AppSpacing.lg,
                                  tablet: AppSpacing.xxl,
                                  desktop: AppSpacing.xxl,
                                ),
                              ),
                              Text(
                                'Loading favorites...',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      : _filteredFavorites.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.favorite_border,
                                    size: size.responsiveValue(
                                      mobile: AppSizes.iconXxl + 20,
                                      tablet: 100.0,
                                      desktop: 120.0,
                                    ),
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(
                                    height: size.responsiveValue(
                                      mobile: AppSpacing.lg,
                                      tablet: AppSpacing.xxl,
                                      desktop: AppSpacing.xxxl,
                                    ),
                                  ),
                                  Text(
                                    _searchController.text.isEmpty
                                        ? 'No favorites yet'
                                        : 'No favorites match your search',
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.responsiveValue(
                                      mobile: AppSpacing.sm,
                                      tablet: AppSpacing.md,
                                      desktop: AppSpacing.lg,
                                    ),
                                  ),
                                  Padding(
                                    padding: size.responsiveHorizontalPadding(
                                      mobile: 32.0,
                                      tablet: 64.0,
                                      desktop: 128.0,
                                    ),
                                    child: Text(
                                      _searchController.text.isEmpty
                                          ? 'Add Pokémon to favorites from the home screen'
                                          : 'Try a different search term',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: Colors.grey[500],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: size.contentWidth,
                                ),
                                child: GridView.builder(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: size.responsiveValue(
                                      mobile: AppSpacing.lg,
                                      tablet: AppSpacing.xxl,
                                      desktop: AppSpacing.xxxl,
                                    ),
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
                                  itemCount: _filteredFavorites.length,
                                  itemBuilder: (context, index) {
                                    final pokemon = _filteredFavorites[index];
                                    return PokemonCard(
                                      pokemon: pokemon,
                                      isFavorite: true,
                                      favoritesController:
                                          widget.favoritesController,
                                      onFavoriteToggle: () async {
                                        await widget.favoritesController
                                            .toggleFavorite(pokemon);
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
