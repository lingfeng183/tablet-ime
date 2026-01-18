import 'package:flutter/material.dart';

class KeyButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isSpecial;

  const KeyButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isSpecial = false,
  });

  @override
  State<KeyButton> createState() => _KeyButtonState();
}

class _KeyButtonState extends State<KeyButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height: 55,
        decoration: BoxDecoration(
          color: _isPressed
              ? Colors.blue.withOpacity(0.8)
              : (widget.isSpecial
                  ? const Color(0xFF3D3D3D)
                  : const Color(0xFF4D4D4D)),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isPressed
                ? Colors.blueAccent
                : (widget.isSpecial
                    ? const Color(0xFF555555)
                    : const Color(0xFF666666)),
            width: _isPressed ? 2 : 1,
          ),
          boxShadow: _isPressed
              ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        transform: _isPressed
            ? (Matrix4.identity()..scale(0.95))
            : Matrix4.identity(),
        child: Center(
          child: Text(
            widget.label,
            style: TextStyle(
              color: _isPressed ? Colors.white : Colors.white,
              fontSize: widget.label.length > 1 ? 14 : 20,
              fontWeight: _isPressed ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
