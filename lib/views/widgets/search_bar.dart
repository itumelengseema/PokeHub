import 'package:flutter/material.dart';

class PokemonSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final String hintText;
  final TextEditingController? controller;

  const PokemonSearchBar({
    super.key,
    required this.onSearch,
    this.hintText = 'Search Pokémon...',
    this.controller,
  });

  @override
  State<PokemonSearchBar> createState() => _PokemonSearchBarState();
}

class _PokemonSearchBarState extends State<PokemonSearchBar> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = widget.controller ?? TextEditingController();
    _searchController.addListener(() {
      widget.onSearch(_searchController.text);
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _searchController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {}); // Rebuild to show/hide clear button
            },
            decoration: InputDecoration(
              hintText: widget.hintText,
              prefixIcon: Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
            ),
          ),
        ),
      ],
    );
  }
}
