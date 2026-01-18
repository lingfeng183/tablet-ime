import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tablet_ime/keyboard_state.dart';
import 'package:tablet_ime/keyboard_service.dart';
import 'package:tablet_ime/key_button.dart';

/// PC完整键盘布局，包含所有编程所需的功能键和符号键
class PCKeyboardLayout extends StatelessWidget {
  const PCKeyboardLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Fill available space provided by Android IME service
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E), // Dark background to prevent transparency
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCandidateBar(context),
            const SizedBox(height: 3),
            _buildFunctionKeys(context),
            const SizedBox(height: 3),
            _buildNumberRow(context),
            const SizedBox(height: 3),
            _buildTopRow(context),
            const SizedBox(height: 3),
            _buildHomeRow(context),
            const SizedBox(height: 3),
            _buildBottomRow(context),
            const SizedBox(height: 3),
            _buildSpaceRow(context),
            const SizedBox(height: 3),
            _buildControlRow(context),
            const SizedBox(height: 3),
          ],
        ),
      ),
    );
  }

  // 候选词栏
  Widget _buildCandidateBar(BuildContext context) {
    return Consumer<KeyboardState>(
      builder: (context, state, child) {
        if (!state.isChinese || state.candidates.isEmpty) {
          return const SizedBox.shrink();
        }
        return Container(
          height: 45,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF2D2D2D),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.candidates.length,
            itemBuilder: (context, index) {
              final isSelected = index == state.selectedCandidateIndex;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GestureDetector(
                  onTap: () {
                    // Update selection index instead of directly selecting
                    state.selectedCandidateIndex = index;
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${index + 1}.${state.candidates[index]}',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // F1-F12功能键行
  Widget _buildFunctionKeys(BuildContext context) {
    return Row(
      children: [
        // Esc键
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: KeyButton(
              label: 'Esc',
              onPressed: () => _handleEsc(context),
              isSpecial: true,
            ),
          ),
        ),
        // F1-F12
        ...List.generate(12, (index) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: KeyButton(
                label: 'F${index + 1}',
                onPressed: () => _handleFunctionKey(context, index + 1),
                isSpecial: true,
              ),
            ),
          );
        }),
      ],
    );
  }

  // 数字行（包含符号）
  Widget _buildNumberRow(BuildContext context) {
    return Consumer<KeyboardState>(
      builder: (context, state, child) {
        final keys = state.shiftPressed
            ? ['~', '!', '@', '#', r'$', '%', '^', '&', '*', '(', ')', '_', '+', 'Back']
            : ['`', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', 'Back'];
        
        return Row(
          children: keys.map((key) {
            final flex = key == 'Back' ? 3 : 2;
            return Expanded(
              flex: flex,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: KeyButton(
                  label: key,
                  onPressed: () => _handleKey(context, key),
                  isSpecial: key == 'Back',
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // QWERTY行
  Widget _buildTopRow(BuildContext context) {
    return Consumer<KeyboardState>(
      builder: (context, state, child) {
        final letters = ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'];
        final symbols = state.shiftPressed ? ['{', '}', '|'] : ['[', ']', '\\'];
        
        return Row(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: KeyButton(
                  label: 'Tab',
                  onPressed: () => _handleKey(context, 'Tab'),
                  isSpecial: true,
                ),
              ),
            ),
            ...letters.map((letter) => Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: KeyButton(
                  label: state.shiftPressed ? letter : letter.toLowerCase(),
                  onPressed: () => _handleLetterKey(context, letter),
                ),
              ),
            )),
            ...symbols.map((symbol) => Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: KeyButton(
                  label: symbol,
                  onPressed: () => _handleKey(context, symbol),
                ),
              ),
            )),
          ],
        );
      },
    );
  }

  // ASDF行
  Widget _buildHomeRow(BuildContext context) {
    return Consumer<KeyboardState>(
      builder: (context, state, child) {
        final letters = ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'];
        final symbols = state.shiftPressed ? [':', '"'] : [';', "'"];
        
        return Row(
          children: [
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: KeyButton(
                  label: 'Caps',
                  onPressed: () => _handleKey(context, 'Caps'),
                  isSpecial: true,
                ),
              ),
            ),
            ...letters.map((letter) => Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: KeyButton(
                  label: state.shiftPressed ? letter : letter.toLowerCase(),
                  onPressed: () => _handleLetterKey(context, letter),
                ),
              ),
            )),
            ...symbols.map((symbol) => Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: KeyButton(
                  label: symbol,
                  onPressed: () => _handleKey(context, symbol),
                ),
              ),
            )),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: KeyButton(
                  label: 'Enter',
                  onPressed: () => _handleKey(context, 'Enter'),
                  isSpecial: true,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ZXCV行
  Widget _buildBottomRow(BuildContext context) {
    return Consumer<KeyboardState>(
      builder: (context, state, child) {
        final letters = ['Z', 'X', 'C', 'V', 'B', 'N', 'M'];
        final symbols = state.shiftPressed ? ['<', '>', '?'] : [',', '.', '/'];
        
        return Row(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: KeyButton(
                  label: state.shiftPressed ? 'Shift⬆' : 'Shift',
                  onPressed: () => _handleShift(context),
                  isSpecial: true,
                ),
              ),
            ),
            ...letters.map((letter) => Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: KeyButton(
                  label: state.shiftPressed ? letter : letter.toLowerCase(),
                  onPressed: () => _handleLetterKey(context, letter),
                ),
              ),
            )),
            ...symbols.map((symbol) => Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: KeyButton(
                  label: symbol,
                  onPressed: () => _handleKey(context, symbol),
                ),
              ),
            )),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: KeyButton(
                  label: state.shiftPressed ? 'Shift⬆' : 'Shift',
                  onPressed: () => _handleShift(context),
                  isSpecial: true,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // 空格行
  Widget _buildSpaceRow(BuildContext context) {
    return Consumer<KeyboardState>(
      builder: (context, state, child) {
        return Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: KeyButton(
                  label: state.ctrlPressed ? 'Ctrl✓' : 'Ctrl',
                  onPressed: () => _handleCtrl(context),
                  isSpecial: true,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: KeyButton(
                  label: 'Win',
                  onPressed: () => _handleKey(context, 'Win'),
                  isSpecial: true,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: KeyButton(
                  label: state.altPressed ? 'Alt✓' : 'Alt',
                  onPressed: () => _handleAlt(context),
                  isSpecial: true,
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: KeyButton(
                  label: 'Space',
                  onPressed: () => _handleKey(context, 'Space'),
                  isSpecial: false,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: KeyButton(
                  label: state.altPressed ? 'Alt✓' : 'Alt',
                  onPressed: () => _handleAlt(context),
                  isSpecial: true,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: KeyButton(
                  label: state.isChinese ? '中' : 'En',
                  onPressed: () => state.toggleLanguage(),
                  isSpecial: true,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: KeyButton(
                  label: '简化',
                  onPressed: () => state.togglePCLayout(),
                  isSpecial: true,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // 控制键行（方向键等）
  Widget _buildControlRow(BuildContext context) {
    return Consumer<KeyboardState>(
      builder: (context, state, child) {
        return Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: KeyButton(
                  label: state.isFloating ? '固定' : '悬浮',
                  onPressed: () => state.toggleFloating(),
                  isSpecial: true,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: KeyButton(
                  label: '↑',
                  onPressed: () => _handleDirectionKey(context, 'ArrowUp'),
                  isSpecial: true,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: KeyButton(
                  label: '←',
                  onPressed: () => _handleDirectionKey(context, 'ArrowLeft'),
                  isSpecial: true,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: KeyButton(
                  label: '↓',
                  onPressed: () => _handleDirectionKey(context, 'ArrowDown'),
                  isSpecial: true,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: KeyButton(
                  label: '→',
                  onPressed: () => _handleDirectionKey(context, 'ArrowRight'),
                  isSpecial: true,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: KeyButton(
                  label: 'Home',
                  onPressed: () => _handleSystemKey(context, 'Home'),
                  isSpecial: true,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: KeyButton(
                  label: 'End',
                  onPressed: () => _handleSystemKey(context, 'End'),
                  isSpecial: true,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: KeyButton(
                  label: 'PgUp',
                  onPressed: () => _handleSystemKey(context, 'PageUp'),
                  isSpecial: true,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: KeyButton(
                  label: 'PgDn',
                  onPressed: () => _handleSystemKey(context, 'PageDown'),
                  isSpecial: true,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: KeyButton(
                  label: 'Ins',
                  onPressed: () => _handleSystemKey(context, 'Insert'),
                  isSpecial: true,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: KeyButton(
                  label: 'Del',
                  onPressed: () => _handleKey(context, 'Del'),
                  isSpecial: true,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // 处理函数键
  void _handleFunctionKey(BuildContext context, int fKey) {
    final service = context.read<KeyboardService>();
    final keyCodes = {
      1: 131, 2: 132, 3: 133, 4: 134, 5: 135, 6: 136,
      7: 137, 8: 138, 9: 139, 10: 140, 11: 141, 12: 142,
    };
    service.sendKeyEvent(keyCodes[fKey]!, true);
    service.sendKeyEvent(keyCodes[fKey]!, false);
  }

  void _handleEsc(BuildContext context) {
    final service = context.read<KeyboardService>();
    service.sendKeyEvent(111, true);  // ESC
    service.sendKeyEvent(111, false);
  }

  void _handleShift(BuildContext context) {
    final state = context.read<KeyboardState>();
    state.setShiftPressed(!state.shiftPressed);
  }

  void _handleCtrl(BuildContext context) {
    final state = context.read<KeyboardState>();
    state.setCtrlPressed(!state.ctrlPressed);
  }

  void _handleAlt(BuildContext context) {
    final state = context.read<KeyboardState>();
    state.setAltPressed(!state.altPressed);
  }

  void _handleLetterKey(BuildContext context, String letter) {
    final state = context.read<KeyboardState>();
    final service = context.read<KeyboardService>();
    
    final char = state.shiftPressed ? letter : letter.toLowerCase();
    
    if (state.isChinese && !state.shiftPressed) {
      state.updatePinyin(state.currentPinyin + char.toLowerCase());
    } else {
      service.commitText(char);
    }
    
    // 按下字母后自动取消Shift
    if (state.shiftPressed) {
      state.setShiftPressed(false);
    }
  }

  void _handleKey(BuildContext context, String key) {
    final service = context.read<KeyboardService>();
    final state = context.read<KeyboardState>();

    switch (key) {
      case 'Tab':
        service.sendKeyEvent(61, true);
        service.sendKeyEvent(61, false);
        break;
      case 'Enter':
        if (state.isChinese && state.candidates.isNotEmpty) {
          _handleCandidateSelect(context, state.selectedCandidateIndex);
        } else {
          service.commitText('\n');
        }
        break;
      case 'Space':
        if (state.isChinese && state.candidates.isNotEmpty) {
          _handleCandidateSelect(context, state.selectedCandidateIndex);
        } else {
          service.commitText(' ');
        }
        break;
      case 'Back':
      case 'Del':
        if (state.isChinese && state.currentPinyin.isNotEmpty) {
          state.updatePinyin(
            state.currentPinyin.substring(0, state.currentPinyin.length - 1),
          );
        } else {
          service.deleteText();
        }
        break;
      case 'Caps':
        state.setShiftPressed(!state.shiftPressed);
        break;
      default:
        // Check if it's a number key in Chinese mode with candidates
        if (state.isChinese && state.candidates.isNotEmpty && 
            key.length == 1 && int.tryParse(key) != null) {
          final index = int.parse(key) - 1; // Convert 1-9 to 0-8 index
          if (index >= 0 && index < state.candidates.length) {
            _handleCandidateSelect(context, index);
            return;
          }
        }
        // Otherwise, just commit the text
        service.commitText(key);
        if (state.shiftPressed) {
          state.setShiftPressed(false);
        }
    }
  }

  void _handleDirectionKey(BuildContext context, String direction) {
    final service = context.read<KeyboardService>();
    final keyCodes = {
      'ArrowUp': 19,
      'ArrowDown': 20,
      'ArrowLeft': 21,
      'ArrowRight': 22,
    };
    service.sendKeyEvent(keyCodes[direction]!, true);
    service.sendKeyEvent(keyCodes[direction]!, false);
  }

  void _handleSystemKey(BuildContext context, String key) {
    final service = context.read<KeyboardService>();
    final keyCodes = {
      'Home': 122,
      'End': 123,
      'PageUp': 92,
      'PageDown': 93,
      'Insert': 124,
    };
    service.sendKeyEvent(keyCodes[key]!, true);
    service.sendKeyEvent(keyCodes[key]!, false);
  }

  void _handleCandidateSelect(BuildContext context, int index) {
    final state = context.read<KeyboardState>();
    final service = context.read<KeyboardService>();
    
    if (index >= 0 && index < state.candidates.length) {
      service.commitText(state.candidates[index]);
      state.clearPinyin();
    }
  }
}
