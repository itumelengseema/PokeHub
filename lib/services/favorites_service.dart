import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pokedex_app/models/pokemon.dart';
import 'package:pokedex_app/services/i_favorites_service.dart';


enum FirestoreCollection {
  users,
  favorites;
}

enum FavoriteField {
  name,
  url,
  imageUrl,
  timestamp;
}

class FavoritesService implements IFavoritesService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FavoritesService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  CollectionReference? get _favoritesCollection {
    if (_userId == null) return null;
    return _firestore
        .collection(FirestoreCollection.users.name)
        .doc(_userId)
        .collection(FirestoreCollection.favorites.name);
  }

  @override
  Future<void> addFavorite(Pokemon pokemon) async {
    if (_favoritesCollection == null) return;

    await _favoritesCollection!.doc(pokemon.id).set({
      FavoriteField.name.name: pokemon.name,
      FavoriteField.url.name: pokemon.url,
      FavoriteField.imageUrl.name: pokemon.imageUrl,
      FavoriteField.timestamp.name: FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> removeFavorite(String pokemonId) async {
    if (_favoritesCollection == null) return;

    await _favoritesCollection!.doc(pokemonId).delete();
  }

  @override
  Future<List<Pokemon>> getFavorites() async {
    if (_favoritesCollection == null) return [];

    final snapshot = await _favoritesCollection!.get();
    return snapshot.docs.map((doc) => _pokemonFromFirestore(doc)).toList();
  }

  @override
  Stream<List<Pokemon>> favoritesStream() {
    if (_favoritesCollection == null) return Stream.value([]);

    return _favoritesCollection!.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => _pokemonFromFirestore(doc)).toList();
    });
  }

  @override
  Future<bool> isFavorite(String pokemonId) async {
    if (_favoritesCollection == null) return false;

    final doc = await _favoritesCollection!.doc(pokemonId).get();
    return doc.exists;
  }

  @override
  Future<void> clearAllFavorites() async {
    if (_favoritesCollection == null) return;

    final snapshot = await _favoritesCollection!.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  
  Pokemon _pokemonFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Pokemon(
      name: data[FavoriteField.name.name] as String,
      url: data[FavoriteField.url.name] as String,
      imageUrl: data[FavoriteField.imageUrl.name] as String?,
    );
  }
}
