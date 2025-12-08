import 'package:flutter/material.dart';
import 'package:pokedex_app/presentation/viewmodels/home_viewmodel.dart';
import 'package:pokedex_app/presentation/widgets/pokemon_card.dart';
import 'package:pokedex_app/presentation/widgets/search_bar.dart';
import 'package:pokedex_app/widgets/responsive/responsive_builder.dart';
import 'package:pokedex_app/utils/constants/app_spacing.dart';
import 'package:pokedex_app/utils/constants/app_sizes.dart';
import 'package:pokedex_app/utils/constants/app_text_styles.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeViewModel _viewModel;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel();
    _viewModel.loadPokemon();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_viewModel.isLoadingMore &&
        _viewModel.hasMoreData) {
      _viewModel.loadMorePokemon();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ChangeNotifierProvider.value(
          value: _viewModel,
          child: Consumer<HomeViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.state == HomeViewState.loading &&
                  viewModel.pokemon.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (viewModel.state == HomeViewState.error &&
                  viewModel.pokemon.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${viewModel.errorMessage}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => viewModel.refresh(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              return ResponsiveBuilder(
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
                          onSearch: (query) => viewModel.searchPokemon(query),
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
                        child: viewModel.pokemon.isEmpty
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
                                    itemCount: viewModel.pokemon.length +
                                        (viewModel.hasMoreData &&
                                                _searchController.text.isEmpty
                                            ? 1
                                            : 0),
                                    itemBuilder: (context, index) {
                                      if (index == viewModel.pokemon.length) {
                                        return const Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(AppSpacing.lg),
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      }
                                      final pokemon = viewModel.pokemon[index];
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
      ),
    );
  }
}
