import 'package:flutter/material.dart';
import 'package:pokedex_app/widgets/responsive/responsive_builder.dart';

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
    final size = context.responsive;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: size.responsiveValue(
            mobile: double.infinity,
            tablet: 600.0,
            desktop: 500.0,
          ),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {}); // Rebuild to show/hide clear button
          },
          style: TextStyle(
            fontSize: size.responsiveValue(
              mobile: 16.0,
              tablet: 15.0,
              desktop: 14.0,
            ),
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontSize: size.responsiveValue(
                mobile: 16.0,
                tablet: 15.0,
                desktop: 14.0,
              ),
            ),
            prefixIcon: Icon(
              Icons.search,
              size: size.responsiveValue(
                mobile: 24.0,
                tablet: 22.0,
                desktop: 20.0,
              ),
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      size: size.responsiveValue(
                        mobile: 24.0,
                        tablet: 22.0,
                        desktop: 20.0,
                      ),
                    ),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                size.responsiveValue(
                  mobile: 12.0,
                  tablet: 10.0,
                  desktop: 10.0,
                ),
              ),
            ),
            filled: true,
            fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
            contentPadding: EdgeInsets.symmetric(
              horizontal: size.responsiveValue(
                mobile: 16.0,
                tablet: 14.0,
                desktop: 12.0,
              ),
              vertical: size.responsiveValue(
                mobile: 16.0,
                tablet: 12.0,
                desktop: 8.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
