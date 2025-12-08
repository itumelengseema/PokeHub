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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'height': height,
      'weight': weight,
      'types': types.map((type) => type.toJson()).toList(),
      'abilities': abilities.map((ability) => ability.toJson()).toList(),
      'stats': stats.map((stat) => stat.toJson()).toList(),
      'imageUrl': imageUrl,
      'speciesUrl': speciesUrl,
    };
  }
}

class EvolutionChain {
  final List<Evolution> evolutions;

  EvolutionChain({required this.evolutions});

  factory EvolutionChain.fromJson(Map<String, dynamic> json) {
    return EvolutionChain(
      evolutions: (json['evolutions'] as List<dynamic>)
          .map((e) => Evolution.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'evolutions': evolutions.map((e) => e.toJson()).toList(),
    };
  }
}

class Evolution {
  final String name;
  final int id;
  final String imageUrl;

  Evolution({required this.name, required this.id, required this.imageUrl});

  factory Evolution.fromJson(Map<String, dynamic> json) {
    return Evolution(
      name: json['name'] as String,
      id: json['id'] as int,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'imageUrl': imageUrl,
    };
  }
}

class PokemonType {
  final String name;

  PokemonType({required this.name});

  factory PokemonType.fromJson(Map<String, dynamic> json) {
    return PokemonType(name: json['type']['name'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      'type': {'name': name},
    };
  }
}

class PokemonAbility {
  final String name;

  PokemonAbility({required this.name});

  factory PokemonAbility.fromJson(Map<String, dynamic> json) {
    return PokemonAbility(name: json['ability']['name'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      'ability': {'name': name},
    };
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

  Map<String, dynamic> toJson() {
    return {
      'stat': {'name': name},
      'base_stat': baseStat,
    };
  }
}
