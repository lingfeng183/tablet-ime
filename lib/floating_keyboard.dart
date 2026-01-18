import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tablet_ime/keyboard_state.dart';
import 'package:tablet_ime/keyboard_layout.dart';
import 'package:tablet_ime/pc_keyboard_layout.dart';

class FloatingKeyboard extends StatelessWidget {
  const FloatingKeyboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<KeyboardState>(
      builder: (context, state, child) {
        // 选择键盘布局
        final keyboardWidget = state.isFullPCLayout 
            ? const PCKeyboardLayout() 
            : const KeyboardLayout();
            
        if (!state.isFloating) {
          // Fixed mode - show normal keyboard
          return Scaffold(
            backgroundColor: const Color(0xFF1E1E1E),
            body: keyboardWidget,
          );
        }

        // Floating mode - show draggable keyboard
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Positioned(
                left: state.floatingPosition.dx,
                top: state.floatingPosition.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    final newPosition = Offset(
                      state.floatingPosition.dx + details.delta.dx,
                      state.floatingPosition.dy + details.delta.dy,
                    );
                    state.updateFloatingPosition(newPosition);
                  },
                  child: Container(
                    width: state.floatingWidth,
                    height: state.floatingHeight,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Title bar with close button
                        Container(
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2D2D2D),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.drag_indicator,
                                color: Colors.grey,
                                size: 20,
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    state.isFullPCLayout 
                                        ? 'PC完整键盘 - 拖动移动' 
                                        : 'Tablet IME - 拖动移动',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.close_fullscreen,
                                  color: Colors.white70,
                                  size: 18,
                                ),
                                onPressed: () {
                                  state.toggleFloating();
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ),
                        // Keyboard content
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                            child: keyboardWidget,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
