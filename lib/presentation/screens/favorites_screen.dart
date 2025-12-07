import 'package:flutter/material.dart';
import 'package:pokedex_app/presentation/viewmodels/favorites_viewmodel.dart';
import 'package:pokedex_app/presentation/widgets/pokemon_card.dart';
import 'package:pokedex_app/presentation/widgets/search_bar.dart';
import 'package:pokedex_app/widgets/responsive/responsive_builder.dart';
import 'package:pokedex_app/utils/constants/app_spacing.dart';
import 'package:pokedex_app/utils/constants/app_sizes.dart';
import 'package:pokedex_app/utils/constants/app_text_styles.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<FavoritesViewModel>(
          builder: (context, viewModel, child) {
            return ResponsiveBuilder(
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
                          SizedBox(height: size.responsiveValue(
                            mobile: AppSpacing.md,
                            tablet: AppSpacing.lg,
                            desktop: AppSpacing.xl,
                          )),
                          Text(
                            'My Favorites',
                            style: AppTextStyles.displayMedium,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: size.responsiveHorizontalPadding(),
                      child: PokemonSearchBar(
                        controller: _searchController,
                        hintText: 'Search favorites...',
                        onSearch: (query) => viewModel.searchFavorites(query),
                      ),
                    ),
                    SizedBox(height: size.responsiveValue(
                      mobile: AppSpacing.lg,
                      tablet: AppSpacing.xxl,
                      desktop: AppSpacing.xxl,
                    )),
                    Expanded(
                      child: viewModel.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : viewModel.favorites.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.favorite_border,
                                        size: 64,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        viewModel.searchQuery.isEmpty
                                            ? 'No favorites yet'
                                            : 'No favorites found',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[600],
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
                                      itemCount: viewModel.favorites.length,
                                      itemBuilder: (context, index) {
                                        final pokemon = viewModel.favorites[index];
                                        return PokemonCard(
                                          pokemon: pokemon,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
