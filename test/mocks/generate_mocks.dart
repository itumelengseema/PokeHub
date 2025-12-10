import 'package:mockito/annotations.dart';
import 'package:pokedex_app/data/services/api/pokemon_api_service.dart';
import 'package:pokedex_app/data/services/local/cache_service.dart';
import 'package:pokedex_app/data/services/firebase/auth_service.dart';
import 'package:pokedex_app/data/services/firebase/favorites_service.dart';
import 'package:pokedex_app/data/repositories/pokemon_repository.dart';
import 'package:pokedex_app/data/repositories/auth_repository.dart';
import 'package:pokedex_app/data/repositories/favorites_repository.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  PokemonApiService,
  CacheService,
  AuthService,
  FavoritesService,
  PokemonRepository,
  AuthRepository,
  FavoritesRepository,
  http.Client,
])
void main() {}
