import 'package:flutter/foundation.dart';
import 'package:pokedex_app/data/models/pokemon_model.dart';
import 'package:pokedex_app/data/repositories/pokemon_repository.dart';

enum HomeViewState { initial, loading, loaded, error, loadingMore }

class HomeViewModel extends ChangeNotifier {
  final PokemonRepository _pokemonRepository;

  HomeViewModel({PokemonRepository? pokemonRepository})
      : _pokemonRepository = pokemonRepository ?? PokemonRepository();

  // State
  HomeViewState _state = HomeViewState.initial;
  final List<Pokemon> _allPokemon = [];
  List<Pokemon> _filteredPokemon = [];
  String _searchQuery = '';
  String? _selectedType;
  String? _errorMessage;

  // Pagination
  int _currentOffset = 0;
  final int _limit = 50;
  bool _hasMoreData = true;
  bool _isPrefetching = false;

  // Getters
  HomeViewState get state => _state;
  List<Pokemon> get pokemon => _filteredPokemon;
  String get searchQuery => _searchQuery;
  String? get selectedType => _selectedType;
  String? get errorMessage => _errorMessage;
  bool get hasMoreData => _hasMoreData;
  bool get isLoading => _state == HomeViewState.loading;
  bool get isLoadingMore => _state == HomeViewState.loadingMore;

  // Load initial Pokemon
  Future<void> loadPokemon() async {
    if (_state == HomeViewState.loading) return;

    _state = HomeViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final newPokemon = await _pokemonRepository.fetchPokemonList(_currentOffset, _limit);

      if (newPokemon.isEmpty) {
        _hasMoreData = false;
      } else {
        _allPokemon.addAll(newPokemon);
        _currentOffset += newPokemon.length;
        _applyFilters();

        // Prefetch details in background
        _prefetchDetails(newPokemon);
      }

      _state = HomeViewState.loaded;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = HomeViewState.error;
      notifyListeners();
    }
  }

  // Load more Pokemon (pagination)
  Future<void> loadMorePokemon() async {
    if (_state == HomeViewState.loadingMore || !_hasMoreData) return;

    _state = HomeViewState.loadingMore;
    notifyListeners();

    try {
      final newPokemon = await _pokemonRepository.fetchPokemonList(_currentOffset, _limit);

      if (newPokemon.isEmpty) {
        _hasMoreData = false;
      } else {
        _allPokemon.addAll(newPokemon);
        _currentOffset += newPokemon.length;
        _applyFilters();

        // Prefetch details in background
        _prefetchDetails(newPokemon);
      }

      _state = HomeViewState.loaded;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = HomeViewState.error;
      notifyListeners();
    }
  }

  // Search Pokemon
  void searchPokemon(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  // Filter by type
  void filterByType(String? type) {
    _selectedType = type;
    _applyFilters();
    notifyListeners();
  }

  // Apply filters (search + type)
  void _applyFilters() {
    _filteredPokemon = _allPokemon.where((pokemon) {
      final matchesSearch = _searchQuery.isEmpty ||
          pokemon.name.toLowerCase().contains(_searchQuery);
      final matchesType = _selectedType == null || _selectedType!.isEmpty;
      return matchesSearch && matchesType;
    }).toList();
  }

  // Prefetch Pokemon details in background
  Future<void> _prefetchDetails(List<Pokemon> pokemonList) async {
    if (_isPrefetching) return;
    _isPrefetching = true;

    try {
      await _pokemonRepository.prefetchPokemonDetails(pokemonList);
    } catch (e) {
      // Silently fail - prefetch is not critical
    } finally {
      _isPrefetching = false;
    }
  }

  // Refresh
  Future<void> refresh() async {
    _currentOffset = 0;
    _allPokemon.clear();
    _filteredPokemon.clear();
    _hasMoreData = true;
    _searchQuery = '';
    _selectedType = null;
    _pokemonRepository.clearCache();
    await loadPokemon();
  }

  // Reset filters
  void resetFilters() {
    _searchQuery = '';
    _selectedType = null;
    _applyFilters();
    notifyListeners();
  }
}
