class PokemonDetail {
  final int id;
  final String name;
  final int height;
  final int weight;
  final List<PokemonType> types;
  final List<PokemonAbility> abilities;
  final List<PokemonStat> stats;
  final String imageUrl;
  final String? speciesUrl;

  PokemonDetail({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.types,
    required this.abilities,
    required this.stats,
    required this.imageUrl,
    this.speciesUrl,
  });

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    return PokemonDetail(
      id: json['id'] as int,
      name: json['name'] as String,
      height: json['height'] as int,
      weight: json['weight'] as int,
      types: (json['types'] as List<dynamic>)
          .map((type) => PokemonType.fromJson(type))
          .toList(),
      abilities: (json['abilities'] as List<dynamic>)
          .map((ability) => PokemonAbility.fromJson(ability))
          .toList(),
      stats: (json['stats'] as List<dynamic>)
          .map((stat) => PokemonStat.fromJson(stat))
          .toList(),
      imageUrl:
          json['sprites']?['other']?['official-artwork']?['front_default']
              as String? ??
          json['sprites']?['front_default'] as String? ??
          '',
      speciesUrl: json['species']?['url'] as String?,
    );
  }
}

class EvolutionChain {
  final List<Evolution> evolutions;

  EvolutionChain({required this.evolutions});
}

class Evolution {
  final String name;
  final int id;
  final String imageUrl;

  Evolution({required this.name, required this.id, required this.imageUrl});
}

class PokemonType {
  final String name;

  PokemonType({required this.name});

  factory PokemonType.fromJson(Map<String, dynamic> json) {
    return PokemonType(name: json['type']['name'] as String);
  }
}

class PokemonAbility {
  final String name;

  PokemonAbility({required this.name});

  factory PokemonAbility.fromJson(Map<String, dynamic> json) {
    return PokemonAbility(name: json['ability']['name'] as String);
  }
}

class PokemonStat {
  final String name;
  final int baseStat;

  PokemonStat({required this.name, required this.baseStat});

  factory PokemonStat.fromJson(Map<String, dynamic> json) {
    return PokemonStat(
      name: json['stat']['name'] as String,
      baseStat: json['base_stat'] as int,
    );
  }
}
