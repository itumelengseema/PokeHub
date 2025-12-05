import 'package:flutter/material.dart';
import 'package:pokedex_app/models/favorite_button_state.dart';


class FavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final Future<void> Function() onToggle;
  final Duration loadingDuration;

  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onToggle,
    this.loadingDuration = const Duration(milliseconds: 300),
  });

 
  const FavoriteButton.fast({
    super.key,
    required this.isFavorite,
    required this.onToggle,
  }) : loadingDuration = Duration.zero;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  FavoriteButtonState _state = FavoriteButtonState.idle;

  bool get _isLoading => _state == FavoriteButtonState.loading;

  Future<void> _handleToggle() async {
    if (_state != FavoriteButtonState.idle) return;

    setState(() {
      _state = FavoriteButtonState.loading;
    });

    try {
      
      await Future.wait([
        widget.onToggle(),
        Future.delayed(const Duration(milliseconds: 500)),
      ]);

      if (mounted) {
        setState(() {
          _state = FavoriteButtonState.success;
        });


        await Future.delayed(widget.loadingDuration);

        if (mounted) {
          setState(() {
            _state = FavoriteButtonState.idle;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _state = FavoriteButtonState.error;
        });


        await Future.delayed(widget.loadingDuration);

        if (mounted) {
          setState(() {
            _state = FavoriteButtonState.idle;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isLoading ? null : _handleToggle,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _isLoading ? Colors.red.shade50 : Colors.white,
          shape: BoxShape.circle,
          boxShadow: _isLoading
              ? [
                  BoxShadow(
                    color: Colors.red.withAlpha(76),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: _buildButtonContent(),
      ),
    );
  }

  Widget _buildButtonContent() {
    switch (_state) {
      case FavoriteButtonState.loading:
        return const SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(
            strokeWidth: 3.5,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          ),
        );

      case FavoriteButtonState.error:
        return const Icon(
          Icons.error_outline,
          color: Colors.orange,
          size: 24,
        );

      case FavoriteButtonState.idle:
      case FavoriteButtonState.success:
        return Icon(
          widget.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: widget.isFavorite ? Colors.red : Colors.grey,
          size: 24,
        );
    }
  }
}
