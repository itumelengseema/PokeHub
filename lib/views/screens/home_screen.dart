import 'package:flutter/material.dart';
import 'package:pokedex_app/controllers/pokemon_controller.dart';
import 'package:pokedex_app/models/pokemon.dart';
import 'package:pokedex_app/views/widgets/pokemon_card.dart';
import 'package:pokedex_app/views/widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PokemonController controller = PokemonController();
  List<Pokemon> pokemonList = [];

  @override
  void initState() {
    super.initState();
    fetchPokemon();
  }

  void fetchPokemon() async {
    final data = await controller.getDummyPokemon();
    setState(() {
      pokemonList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.network(
                        'https://cdn.brandfetch.io/idyp519aAf/w/1024/h/1022/theme/dark/symbol.png?c=1bxid64Mup7aczewSAYMX&t=1721651819488',
                        height: 80,
                        width: 80,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Pokemon',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  PokemonSearchBar(),
                  SizedBox(height: 16),
                  PokemonCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
