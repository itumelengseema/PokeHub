import 'package:flutter/material.dart';
import 'package:pokedex_app/models/pokemon.dart';
import 'package:pokedex_app/controllers/favorites_controller.dart';
import 'package:pokedex_app/views/screens/details_screen.dart';
import 'package:pokedex_app/views/widgets/favorite_button.dart';
import 'package:pokedex_app/widgets/responsive/responsive_builder.dart';
import 'package:pokedex_app/utils/constants/app_spacing.dart';
import 'package:pokedex_app/utils/constants/app_sizes.dart';
import 'package:pokedex_app/utils/constants/app_text_styles.dart';

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
    final size = context.responsive;

    final imageSize = size.responsiveValue(
      mobile: AppSizes.pokemonImageMedium,
      tablet: AppSizes.pokemonImageLarge,
      desktop: AppSizes.pokemonImageLarge + 20,
    );

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
          borderRadius: BorderRadius.circular(
            size.responsiveValue(
              mobile: AppSizes.radiusLarge,
              tablet: AppSizes.radiusExtraLarge,
              desktop: AppSizes.radiusExtraLarge,
            ),
          ),
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
                        width: imageSize,
                        height: imageSize,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.catching_pokemon,
                            size: imageSize,
                            color: Colors.grey,
                          );
                        },
                      ),
                    )
                  else
                    Icon(
                      Icons.catching_pokemon,
                      size: imageSize,
                      color: Colors.grey,
                    ),
                  SizedBox(
                    height: size.responsiveValue(
                      mobile: AppSpacing.sm,
                      tablet: AppSpacing.md,
                      desktop: AppSpacing.md,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.responsiveValue(
                        mobile: AppSpacing.sm,
                        tablet: AppSpacing.md,
                        desktop: AppSpacing.lg,
                      ),
                    ),
                    child: Text(
                      pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: size.responsiveValue(
                          mobile: AppTextStyles.fontSizeXl,
                          tablet: AppTextStyles.fontSizeXxl,
                          desktop: AppTextStyles.fontSizeHuge,
                        ),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    height: size.responsiveValue(
                      mobile: AppSpacing.xs,
                      tablet: AppSpacing.sm,
                      desktop: AppSpacing.sm,
                    ),
                  ),
                  Text(
                    _getPokemonId(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.grey[600],
                      fontSize: size.responsiveValue(
                        mobile: AppTextStyles.fontSizeMd,
                        tablet: AppTextStyles.fontSizeLg,
                        desktop: AppTextStyles.fontSizeLg,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (onFavoriteToggle != null)
              Positioned(
                top: size.responsiveValue(
                  mobile: AppSpacing.sm,
                  tablet: AppSpacing.md,
                  desktop: AppSpacing.md,
                ),
                right: size.responsiveValue(
                  mobile: AppSpacing.sm,
                  tablet: AppSpacing.md,
                  desktop: AppSpacing.md,
                ),
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
