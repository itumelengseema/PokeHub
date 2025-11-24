class Pokemon {
  final String name;
  final String url;
  final String? imageUrl;

  Pokemon({required this.name, required this.url, this.imageUrl});

  String get id => url.split('/').where((e) => e.isNotEmpty).last;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pokemon && runtimeType == other.runtimeType && url == other.url;

  @override
  int get hashCode => url.hashCode;
}

//   "count": 1328,
//   "next": "https://pokeapi.co/api/v2/pokemon/?offset=20&limit=20",
//   "previous": null,
//   "results": [
//     {
//       "name": "bulbasaur",
//       "url": "https://pokeapi.co/api/v2/pokemon/1/"
//     },
//     {
//       "name": "ivysaur",
//       "url": "https://pokeapi.co/api/v2/pokemon/2/"
//     },
//     {
//       "name": "venusaur",
//       "url": "https://pokeapi.co/api/v2/pokemon/3/"
//     },
//     {
//       "name": "charmander",
//       "url": "https://pokeapi.co/api/v2/pokemon/4/"
//     },
//     {
//       "name": "charmeleon",
//       "url": "https://pokeapi.co/api/v2/pokemon/5/"
//     },
//     {
//       "name": "charizard",
//       "url": "https://pokeapi.co/api/v2/pokemon/6/"
//     },
//     {
//       "name": "squirtle",
//       "url": "https://pokeapi.co/api/v2/pokemon/7/"
//     },
//     {
//       "name": "wartortle",
//       "url": "https://pokeapi.co/api/v2/pokemon/8/"
//     },
//     {
//       "name": "blastoise",
//       "url": "https://pokeapi.co/api/v2/pokemon/9/"
//     },
//     {
//       "name": "caterpie",
//       "url": "https://pokeapi.co/api/v2/pokemon/10/"
//     },
//     {
//       "name": "metapod",
//       "url": "https://pokeapi.co/api/v2/pokemon/11/"
//     },
//     {
//       "name": "butterfree",
//       "url": "https://pokeapi.co/api/v2/pokemon/12/"
//     },
//     {
//       "name": "weedle",
//       "url": "https://pokeapi.co/api/v2/pokemon/13/"
//     },
//     {
//       "name": "kakuna",
//       "url": "https://pokeapi.co/api/v2/pokemon/14/"
//     },
//     {
//       "name": "beedrill",
//       "url": "https://pokeapi.co/api/v2/pokemon/15/"
//     },
//     {
//       "name": "pidgey",
//       "url": "https://pokeapi.co/api/v2/pokemon/16/"
//     },
//     {
//       "name": "pidgeotto",
//       "url": "https://pokeapi.co/api/v2/pokemon/17/"
//     },
//     {
//       "name": "pidgeot",
//       "url": "https://pokeapi.co/api/v2/pokemon/18/"
//     },
//     {
//       "name": "rattata",
//       "url": "https://pokeapi.co/api/v2/pokemon/19/"
//     },
//     {
//       "name": "raticate",
//       "url": "https://pokeapi.co/api/v2/pokemon/20/"
//     }
//   ]
// }
