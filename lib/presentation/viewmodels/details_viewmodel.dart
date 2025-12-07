import 'package:flutter/foundation.dart';
import 'package:pokedex_app/data/models/pokemon_model.dart';
import 'package:pokedex_app/data/models/pokemon_detail_model.dart';
import 'package:pokedex_app/data/repositories/pokemon_repository.dart';

enum DetailsViewState { initial, loading, loaded, error }

class DetailsViewModel extends ChangeNotifier {
  final PokemonRepository _pokemonRepository;
  final Pokemon pokemon;

  DetailsViewModel({
    required this.pokemon,
    PokemonRepository? pokemonRepository,
  }) : _pokemonRepository = pokemonRepository ?? PokemonRepository();

  // State
  DetailsViewState _state = DetailsViewState.initial;
  PokemonDetail? _pokemonDetail;
  EvolutionChain? _evolutionChain;
  String? _errorMessage;

  bool _isLoadingEvolution = false;
  String? _evolutionErrorMessage;

  // Getters
  DetailsViewState get state => _state;
  PokemonDetail? get pokemonDetail => _pokemonDetail;
  EvolutionChain? get evolutionChain => _evolutionChain;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == DetailsViewState.loading;
  bool get isLoadingEvolution => _isLoadingEvolution;
  String? get evolutionErrorMessage => _evolutionErrorMessage;

  // Load Pokemon details
  Future<void> loadPokemonDetail() async {
    if (_state == DetailsViewState.loading) return;

    _state = DetailsViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _pokemonDetail = await _pokemonRepository.fetchPokemonDetail(pokemon.url);
      _state = DetailsViewState.loaded;
      notifyListeners();

      // Load evolution chain if species URL exists
      if (_pokemonDetail?.speciesUrl != null) {
        await loadEvolutionChain();
      }
    } catch (e) {
      _errorMessage = e.toString();
      _state = DetailsViewState.error;
      notifyListeners();
    }
  }

  // Load evolution chain
  Future<void> loadEvolutionChain() async {
    if (_pokemonDetail?.speciesUrl == null || _isLoadingEvolution) return;

    _isLoadingEvolution = true;
    _evolutionErrorMessage = null;
    notifyListeners();

    try {
      _evolutionChain = await _pokemonRepository.fetchEvolutionChain(
        _pokemonDetail!.speciesUrl!,
      );
      _isLoadingEvolution = false;
      notifyListeners();
    } catch (e) {
      _evolutionErrorMessage = e.toString();
      _isLoadingEvolution = false;
      notifyListeners();
    }
  }

  // Retry loading
  Future<void> retry() async {
    await loadPokemonDetail();
  }

  // Get type color (UI helper)
  String getTypeColor(String type) {
    final typeColors = {
      'normal': '#A8A878',
      'fire': '#F08030',
      'water': '#6890F0',
      'electric': '#F8D030',
      'grass': '#78C850',
      'ice': '#98D8D8',
      'fighting': '#C03028',
      'poison': '#A040A0',
      'ground': '#E0C068',
      'flying': '#A890F0',
      'psychic': '#F85888',
      'bug': '#A8B820',
      'rock': '#B8A038',
      'ghost': '#705898',
      'dragon': '#7038F8',
      'dark': '#705848',
      'steel': '#B8B8D0',
      'fairy': '#EE99AC',
    };

    return typeColors[type.toLowerCase()] ?? '#777777';
  }

  // Get stat percentage (UI helper)
  double getStatPercentage(int baseStat) {
    return (baseStat / 255).clamp(0.0, 1.0);
  }
}
