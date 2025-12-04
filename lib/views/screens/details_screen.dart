import 'package:flutter/material.dart';
import 'package:pokedex_app/controllers/favorites_controller.dart';
import 'package:pokedex_app/models/pokemon.dart';
import 'package:pokedex_app/models/pokemon_detail.dart';
import 'package:pokedex_app/services/api_services.dart';
import 'package:pokedex_app/views/widgets/error_state_widget.dart';

class DetailsScreen extends StatefulWidget {
  final Pokemon pokemon;
  final FavoritesController favoritesController;

  const DetailsScreen({
    super.key,
    required this.pokemon,
    required this.favoritesController,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final ApiServices _apiServices = ApiServices();
  PokemonDetail? _pokemonDetail;
  EvolutionChain? _evolutionChain;
  bool _isLoading = true;
  bool _isLoadingEvolution = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPokemonDetail();
  }

  Future<void> _loadPokemonDetail() async {
    try {
      if (widget.pokemon.url.isEmpty) {
        throw Exception('Invalid Pokemon URL');
      }

      debugPrint('Loading Pokemon detail from URL: ${widget.pokemon.url}');
      final detail = await _apiServices.fetchPokemonDetail(widget.pokemon.url);

      if (!mounted) return;

      setState(() {
        _pokemonDetail = detail;
        _isLoading = false;
      });

      // Load evolution chain
      if (detail.speciesUrl != null) {
        _loadEvolutionChain(detail.speciesUrl!);
      } else {
        setState(() {
          _isLoadingEvolution = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading Pokemon detail: $e');
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _isLoading = false;
        _isLoadingEvolution = false;
      });
    }
  }

  Future<void> _loadEvolutionChain(String speciesUrl) async {
    try {
      final chain = await _apiServices.fetchEvolutionChain(speciesUrl);
      setState(() {
        _evolutionChain = chain;
        _isLoadingEvolution = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingEvolution = false;
      });
    }
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'normal':
        return Colors.grey;
      case 'fire':
        return Colors.orange;
      case 'water':
        return Colors.blue;
      case 'electric':
        return Colors.yellow;
      case 'grass':
        return Colors.green;
      case 'ice':
        return Colors.cyan;
      case 'fighting':
        return Colors.red;
      case 'poison':
        return Colors.purple;
      case 'ground':
        return Colors.brown;
      case 'flying':
        return Color(0xFF89A5F0);
      case 'psychic':
        return Colors.pink;
      case 'bug':
        return Colors.lightGreen;
      case 'rock':
        return Color(0xFFB8A038);
      case 'ghost':
        return Color(0xFF705898);
      case 'dragon':
        return Color(0xFF7038F8);
      case 'dark':
        return Color(0xFF705848);
      case 'steel':
        return Color(0xFFB8B8D0);
      case 'fairy':
        return Color(0xFFEE99AC);
      default:
        return Colors.grey;
    }
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
      body: _isLoading
          ? SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Loading Pokemon details...',
                      style: TextStyle(color: textColor),
                    ),
                  ],
                ),
              ),
            )
          : _error != null
          ? ErrorStateWidget(
              title: 'Failed to load Pokemon details',
              errorMessage: _error!,
              debugInfo: 'Pokemon: ${widget.pokemon.name}\nURL: ${widget.pokemon.url}',
              onRetry: () {
                setState(() {
                  _error = null;
                  _isLoading = true;
                });
                _loadPokemonDetail();
              },
            )
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  backgroundColor: _pokemonDetail!.types.isNotEmpty
                      ? _getTypeColor(_pokemonDetail!.types.first.name)
                      : Colors.blue,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      _pokemonDetail!.name.toUpperCase(),
                      style: TextStyle(
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
                                _getTypeColor(_pokemonDetail!.types.first.name),
                                _getTypeColor(
                                  _pokemonDetail!.types.first.name,
                                ).withValues(alpha: 0.7),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Hero(
                            tag: 'pokemon_${widget.pokemon.id}',
                            child: Image.network(
                              _pokemonDetail!.imageUrl,
                              fit: BoxFit.contain,
                              height: 200,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.catching_pokemon,
                                  size: 120,
                                  color: Colors.white.withValues(alpha: 0.5),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        widget.favoritesController.isFavorite(widget.pokemon)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.favoritesController.toggleFavorite(
                            widget.pokemon,
                          );
                        });
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
                        // Pokemon ID
                        Center(
                          child: Text(
                            '#${_pokemonDetail!.id.toString().padLeft(3, '0')}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: subtextColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Types
                        Center(
                          child: Wrap(
                            spacing: 8,
                            children: _pokemonDetail!.types
                                .map(
                                  (type) => Chip(
                                    label: Text(
                                      type.name.toUpperCase(),
                                      style: TextStyle(
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
                        SizedBox(height: 24),

                        // Physical Info
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildInfoCard(
                              'Height',
                              '${(_pokemonDetail!.height / 10).toStringAsFixed(1)} m',
                              Icons.height,
                              isDark,
                              cardColor,
                              textColor,
                              subtextColor,
                            ),
                            _buildInfoCard(
                              'Weight',
                              '${(_pokemonDetail!.weight / 10).toStringAsFixed(1)} kg',
                              Icons.monitor_weight,
                              isDark,
                              cardColor,
                              textColor,
                              subtextColor,
                            ),
                          ],
                        ),
                        SizedBox(height: 24),

                        // Abilities
                        Text(
                          'Abilities',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _pokemonDetail!.abilities
                              .map(
                                (ability) => Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    ability.name
                                        .replaceAll('-', ' ')
                                        .toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        SizedBox(height: 24),

                        // Stats
                        Text(
                          'Base Stats',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 12),
                        ..._pokemonDetail!.stats.map(
                          (stat) => _buildStatBar(
                            stat.name.replaceAll('-', ' ').toUpperCase(),
                            stat.baseStat,
                            isDark,
                            textColor,
                          ),
                        ),
                        SizedBox(height: 24),

                        // Evolution Chain
                        if (_evolutionChain != null &&
                            _evolutionChain!.evolutions.length > 1)
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
                              SizedBox(height: 12),
                              SizedBox(
                                height: 140,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _evolutionChain!.evolutions.length,
                                  itemBuilder: (context, index) {
                                    final evolution =
                                        _evolutionChain!.evolutions[index];
                                    final isLast =
                                        index ==
                                        _evolutionChain!.evolutions.length - 1;

                                    return Row(
                                      children: [
                                        Container(
                                          width: 100,
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: cardColor,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.network(
                                                evolution.imageUrl,
                                                width: 70,
                                                height: 70,
                                                fit: BoxFit.contain,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return Icon(
                                                        Icons.catching_pokemon,
                                                        size: 70,
                                                        color: Colors.grey,
                                                      );
                                                    },
                                              ),
                                              SizedBox(height: 4),
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
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
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
                        else if (_isLoadingEvolution)
                          Center(
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
            ),
    );
  }

  Widget _buildInfoCard(
    String label,
    String value,
    IconData icon,
    bool isDark,
    Color? cardColor,
    Color textColor,
    Color? subtextColor,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: Colors.blue),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 14, color: subtextColor)),
          SizedBox(height: 4),
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
          SizedBox(height: 6),
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
