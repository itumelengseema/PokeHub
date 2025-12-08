import 'package:flutter/material.dart';
import 'package:pokedex_app/data/models/pokemon_model.dart';
import 'package:pokedex_app/presentation/viewmodels/details_viewmodel.dart';
import 'package:pokedex_app/presentation/viewmodels/favorites_viewmodel.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatefulWidget {
  final Pokemon pokemon;

  const DetailsScreen({
    super.key,
    required this.pokemon,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late DetailsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = DetailsViewModel(pokemon: widget.pokemon);
    _viewModel.loadPokemonDetail();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Color _getTypeColor(String type) {
    final colors = {
      'normal': const Color(0xFFA8A878),
      'fire': const Color(0xFFF08030),
      'water': const Color(0xFF6890F0),
      'electric': const Color(0xFFF8D030),
      'grass': const Color(0xFF78C850),
      'ice': const Color(0xFF98D8D8),
      'fighting': const Color(0xFFC03028),
      'poison': const Color(0xFFA040A0),
      'ground': const Color(0xFFE0C068),
      'flying': const Color(0xFFA890F0),
      'psychic': const Color(0xFFF85888),
      'bug': const Color(0xFFA8B820),
      'rock': const Color(0xFFB8A038),
      'ghost': const Color(0xFF705898),
      'dragon': const Color(0xFF7038F8),
      'dark': const Color(0xFF705848),
      'steel': const Color(0xFFB8B8D0),
      'fairy': const Color(0xFFEE99AC),
    };
    return colors[type.toLowerCase()] ?? const Color(0xFF777777);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Colors.grey[900] : Colors.white;
    final cardColor = isDark ? Colors.grey[850] : Colors.grey[100];
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: ChangeNotifierProvider.value(
        value: _viewModel,
        child: Consumer<DetailsViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Loading Pokemon details...',
                        style: TextStyle(color: textColor),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (viewModel.state == DetailsViewState.error) {
              return SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${viewModel.errorMessage}',
                        style: TextStyle(color: textColor),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => viewModel.retry(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final detail = viewModel.pokemonDetail;
            if (detail == null) {
              return const Center(child: Text('No data'));
            }

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  backgroundColor: detail.types.isNotEmpty
                      ? _getTypeColor(detail.types.first.name)
                      : Colors.blue,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      detail.name.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                _getTypeColor(detail.types.first.name),
                                _getTypeColor(detail.types.first.name)
                                    .withValues(alpha: 0.7),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Hero(
                            tag: 'pokemon_${widget.pokemon.id}',
                            child: Image.network(
                              detail.imageUrl,
                              fit: BoxFit.contain,
                              height: 200,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.catching_pokemon,
                                  size: 120,
                                  color: Colors.white,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    Consumer<FavoritesViewModel>(
                      builder: (context, favViewModel, child) {
                        return FutureBuilder<bool>(
                          future: favViewModel.isFavorite(widget.pokemon.id),
                          builder: (context, snapshot) {
                            final isFavorite = snapshot.data ?? false;
                            return IconButton(
                              icon: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                favViewModel.toggleFavorite(widget.pokemon);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            '#${detail.id.toString().padLeft(3, '0')}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: subtextColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Wrap(
                            spacing: 8,
                            children: detail.types
                                .map(
                                  (type) => Chip(
                                    label: Text(
                                      type.name.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    backgroundColor: _getTypeColor(type.name),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildInfoCard(
                              'Height',
                              '${(detail.height / 10).toStringAsFixed(1)} m',
                              Icons.height,
                              cardColor,
                              textColor,
                              subtextColor,
                            ),
                            _buildInfoCard(
                              'Weight',
                              '${(detail.weight / 10).toStringAsFixed(1)} kg',
                              Icons.monitor_weight,
                              cardColor,
                              textColor,
                              subtextColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Abilities',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: detail.abilities
                              .map(
                                (ability) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    ability.name.replaceAll('-', ' ').toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Base Stats',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...detail.stats.map(
                          (stat) => _buildStatBar(
                            stat.name.replaceAll('-', ' ').toUpperCase(),
                            stat.baseStat,
                            isDark,
                            textColor,
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (viewModel.evolutionChain != null &&
                            viewModel.evolutionChain!.evolutions.length > 1)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Evolution Chain',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 140,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: viewModel.evolutionChain!.evolutions.length,
                                  itemBuilder: (context, index) {
                                    final evolution =
                                        viewModel.evolutionChain!.evolutions[index];
                                    final isLast = index ==
                                        viewModel.evolutionChain!.evolutions.length - 1;

                                    return Row(
                                      children: [
                                        Container(
                                          width: 100,
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: cardColor,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.network(
                                                evolution.imageUrl,
                                                width: 70,
                                                height: 70,
                                                fit: BoxFit.contain,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return const Icon(
                                                    Icons.catching_pokemon,
                                                    size: 70,
                                                    color: Colors.grey,
                                                  );
                                                },
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                evolution.name.toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: textColor,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (!isLast)
                                          const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 8),
                                            child: Icon(
                                              Icons.arrow_forward,
                                              color: Colors.grey,
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        else if (viewModel.isLoadingEvolution)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      ],
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

  Widget _buildInfoCard(
    String label,
    String value,
    IconData icon,
    Color? cardColor,
    Color textColor,
    Color? subtextColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: Colors.blue),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 14, color: subtextColor)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBar(
    String statName,
    int value,
    bool isDark,
    Color textColor,
  ) {
    final percentage = (value / 255).clamp(0.0, 1.0);
    Color barColor = Colors.green;

    if (value < 50) {
      barColor = Colors.red;
    } else if (value < 100) {
      barColor = Colors.orange;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                statName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
