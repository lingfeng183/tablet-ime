import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tablet_ime/keyboard_state.dart';
import 'package:tablet_ime/keyboard_service.dart';
import 'package:tablet_ime/key_button.dart';

class KeyboardLayout extends StatelessWidget {
  const KeyboardLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions to calculate appropriate keyboard height
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;
    final screenHeight = size.height;
    // Use 50% in landscape, 55% in portrait to ensure all keys are visible
    final keyboardHeight = isLandscape ? screenHeight * 0.5 : screenHeight * 0.55;
    
    return Container(
      height: keyboardHeight,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCandidateBar(context),
            const SizedBox(height: 4),
            _buildNumberKeys(context),
            const SizedBox(height: 4),
            _buildTopRow(context),
            const SizedBox(height: 4),
            _buildHomeRow(context),
            const SizedBox(height: 4),
            _buildBottomRow(context),
            const SizedBox(height: 4),
            _buildSpaceRow(context),
            const SizedBox(height: 4),
            _buildSpecialKeys(context),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildFunctionKeys(BuildContext context) {
    return Row(
      children: List.generate(12, (index) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: KeyButton(
              label: 'F${index + 1}',
              onPressed: () => _handleFunctionKey(context, index + 1),
              isSpecial: true,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNumberKeys(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: KeyButton(
              label: 'ESC',
              onPressed: () => _handleEsc(context),
              isSpecial: true,
            ),
          ),
        ),
        ...List.generate(10, (index) {
          final num = index == 9 ? '0' : (index + 1).toString();
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: KeyButton(
                label: num,
                onPressed: () => _handleNumberKey(context, num),
              ),
            ),
          );
        }),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: KeyButton(
              label: 'Back',
              onPressed: () => _handleBackspace(context),
              isSpecial: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopRow(BuildContext context) {
    final keys = ['Tab', 'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', 'Del'];
    return Row(
      children: keys.map((key) {
        final flex = key == 'Tab' || key == 'Del' ? 2 : 1;
        return Expanded(
          flex: flex,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: KeyButton(
              label: key,
              onPressed: () => _handleKey(context, key),
              isSpecial: key == 'Tab' || key == 'Del',
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHomeRow(BuildContext context) {
    final keys = ['Caps', 'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', 'Enter'];
    return Row(
      children: keys.map((key) {
        final flex = key == 'Caps' || key == 'Enter' ? 2 : 1;
        return Expanded(
          flex: flex,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: KeyButton(
              label: key,
              onPressed: () => _handleKey(context, key),
              isSpecial: key == 'Caps' || key == 'Enter',
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomRow(BuildContext context) {
    final keys = ['Shift', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', ',', '.', '/'];
    return Row(
      children: keys.map((key) {
        final flex = key == 'Shift' ? 3 : 1;
        return Expanded(
          flex: flex,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: KeyButton(
              label: key,
              onPressed: () => _handleKey(context, key),
              isSpecial: key == 'Shift',
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSpaceRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: KeyButton(
              label: 'Ctrl',
              onPressed: () => _handleCtrl(context),
              isSpecial: true,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: KeyButton(
              label: '🇨🇳/🇺🇸',
              onPressed: () => _handleLanguageSwitch(context),
              isSpecial: true,
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: KeyButton(
              label: 'Space',
              onPressed: () => _handleSpace(context),
              isSpecial: true,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: KeyButton(
              label: 'Alt',
              onPressed: () => _handleAlt(context),
              isSpecial: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialKeys(BuildContext context) {
    return Consumer<KeyboardState>(
      builder: (context, state, child) {
        return Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: KeyButton(
                  label: state.isFloating ? '固定' : '悬浮',
                  onPressed: () {
                    state.toggleFloating();
                  },
                  isSpecial: true,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: KeyButton(
                  label: '↑',
                  onPressed: () => _handleDirectionKey(context, 'ArrowUp'),
                  isSpecial: true,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: KeyButton(
                  label: '←',
                  onPressed: () => _handleDirectionKey(context, 'ArrowLeft'),
                  isSpecial: true,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: KeyButton(
                  label: '↓',
                  onPressed: () => _handleDirectionKey(context, 'ArrowDown'),
                  isSpecial: true,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: KeyButton(
                  label: '→',
                  onPressed: () => _handleDirectionKey(context, 'ArrowRight'),
                  isSpecial: true,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: KeyButton(
                  label: 'Home',
                  onPressed: () => _handleSystemKey(context, 'Home'),
                  isSpecial: true,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: KeyButton(
                  label: 'End',
                  onPressed: () => _handleSystemKey(context, 'End'),
                  isSpecial: true,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: KeyButton(
                  label: 'Ins',
                  onPressed: () => _handleSystemKey(context, 'Insert'),
                  isSpecial: true,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCandidateBar(BuildContext context) {
    return Consumer<KeyboardState>(
      builder: (context, state, child) {
        if (!state.isChinese || state.candidates.isEmpty) {
          return const SizedBox.shrink();
        }
        return Container(
          height: 50,
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
                  onTap: () => _handleCandidateSelect(context, index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${index + 1}.${state.candidates[index]}',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontSize: 18,
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

  void _handleFunctionKey(BuildContext context, int fKey) {
    final state = context.read<KeyboardState>();
    final service = context.read<KeyboardService>();
    final keyCodes = {
      1: 131,
      2: 132,
      3: 133,
      4: 134,
      5: 135,
      6: 136,
      7: 137,
      8: 138,
      9: 139,
      10: 140,
      11: 141,
      12: 142,
    };
    service.sendKeyEvent(keyCodes[fKey]!, true);
    service.sendKeyEvent(keyCodes[fKey]!, false);
  }

  void _handleNumberKey(BuildContext context, String num) {
    final state = context.read<KeyboardState>();
    if (state.isChinese) {
      state.updatePinyin(state.currentPinyin + num.toLowerCase());
    } else {
      context.read<KeyboardService>().commitText(num);
    }
  }

  void _handleKey(BuildContext context, String key) {
    final state = context.read<KeyboardState>();
    final service = context.read<KeyboardService>();

    switch (key) {
      case 'Tab':
        service.sendKeyEvent(61, true);
        service.sendKeyEvent(61, false);
        break;
      case 'Del':
        service.deleteText();
        state.clearPinyin();
        break;
      case 'Caps':
        break;
      case 'Enter':
        if (state.isChinese && state.candidates.isNotEmpty) {
          service.commitText(state.candidates[state.selectedCandidateIndex]);
          state.clearPinyin();
        } else {
          service.sendKeyEvent(66, true);
          service.sendKeyEvent(66, false);
        }
        break;
      case 'Shift':
        break;
      default:
        if (key.length == 1) {
          if (state.isChinese) {
            state.updatePinyin(state.currentPinyin + key.toLowerCase());
          } else {
            service.commitText(key);
          }
        }
    }
  }

  void _handleSpace(BuildContext context) {
    final state = context.read<KeyboardState>();
    final service = context.read<KeyboardService>();
    
    if (state.isChinese && state.candidates.isNotEmpty) {
      service.commitText(state.candidates[state.selectedCandidateIndex]);
      state.clearPinyin();
    } else {
      service.commitText(' ');
    }
  }

  void _handleBackspace(BuildContext context) {
    final service = context.read<KeyboardService>();
    service.deleteText();
  }

  void _handleLanguageSwitch(BuildContext context) {
    context.read<KeyboardState>().toggleLanguage();
  }

  void _handleCtrl(BuildContext context) {
    context.read<KeyboardService>().sendKeyEvent(113, true);
    context.read<KeyboardService>().sendKeyEvent(113, false);
  }

  void _handleAlt(BuildContext context) {
    context.read<KeyboardService>().sendKeyEvent(57, true);
    context.read<KeyboardService>().sendKeyEvent(57, false);
  }

  void _handleEsc(BuildContext context) {
    context.read<KeyboardService>().sendKeyEvent(111, true);
    context.read<KeyboardService>().sendKeyEvent(111, false);
  }

  void _handleDirectionKey(BuildContext context, String direction) {
    final keyCodes = {
      'ArrowUp': 19,
      'ArrowDown': 20,
      'ArrowLeft': 21,
      'ArrowRight': 22,
    };
    final service = context.read<KeyboardService>();
    service.sendKeyEvent(keyCodes[direction]!, true);
    service.sendKeyEvent(keyCodes[direction]!, false);
  }

  void _handleSystemKey(BuildContext context, String systemKey) {
    final keyCodes = {
      'Home': 3,
      'End': 124,
      'Insert': 124,
    };
    final service = context.read<KeyboardService>();
    service.sendKeyEvent(keyCodes[systemKey]!, true);
    service.sendKeyEvent(keyCodes[systemKey]!, false);
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
