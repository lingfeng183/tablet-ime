import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tablet_ime/keyboard_state.dart';
import 'package:tablet_ime/keyboard_service.dart';
import 'package:tablet_ime/key_button.dart';

class KeyboardLayout extends StatelessWidget {
  const KeyboardLayout({super.key});

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
                  label: 'PC全键',
                  onPressed: () {
                    state.togglePCLayout();
                  },
                  isSpecial: true,
                ),
              ),
            ),
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
        // Show candidates in real-time if in Chinese mode with pinyin
        if (!state.isChinese || (state.currentPinyin.isEmpty && state.candidates.isEmpty)) {
          return const SizedBox.shrink();
        }
        
        // Show pinyin composition with real-time candidates
        if (state.candidates.isEmpty) {
          // No matches found for current pinyin
          return Container(
            height: 48,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF2D2D2D),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withOpacity(0.5), width: 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.edit, color: Colors.orange, size: 18),
                const SizedBox(width: 8),
                Text(
                  '拼音: ${state.currentPinyin}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '无匹配',
                    style: TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        
        // Show candidates with pinyin composition at top
        return Container(
          height: 58,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF2D2D2D),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.withOpacity(0.4), width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pinyin composition line
              if (state.currentPinyin.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.edit, color: Colors.blue, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        state.currentPinyin,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              // Candidates line
              Expanded(
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(Icons.text_fields, color: Colors.green, size: 18),
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.candidates.length > 9 ? 9 : state.candidates.length,
                        itemBuilder: (context, index) {
                          final isSelected = index == state.selectedCandidateIndex;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: GestureDetector(
                              onTap: () {
                                // Directly select the candidate on click
                                _handleCandidateSelect(context, index);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.blue : Colors.transparent,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: isSelected ? Colors.blue : Colors.white24,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${index + 1}.',
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : Colors.white54,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      state.candidates[index],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  void _handleNumberKey(BuildContext context, String num) {
    final state = context.read<KeyboardState>();
    if (state.isChinese && state.candidates.isNotEmpty) {
      // In Chinese mode with candidates, number keys select candidates
      final index = int.parse(num) - 1; // Convert 1-9 to 0-8 index
      if (index >= 0 && index < state.candidates.length) {
        _handleCandidateSelect(context, index);
      }
    } else if (state.isChinese) {
      // In Chinese mode without candidates, add to pinyin
      state.updatePinyin(state.currentPinyin + num.toLowerCase());
    } else {
      // In English mode, just type the number
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
    
    if (state.isChinese) {
      if (state.currentPinyin.isNotEmpty && state.candidates.isEmpty) {
        // Has pinyin but no candidates yet - show candidates (Sogou behavior)
        state.showCandidates();
      } else if (state.candidates.isNotEmpty) {
        // Has candidates - select current one
        service.commitText(state.candidates[state.selectedCandidateIndex]);
        state.clearPinyin();
      } else {
        // No pinyin, just insert space
        service.commitText(' ');
      }
    } else {
      service.commitText(' ');
    }
  }

  void _handleBackspace(BuildContext context) {
    final state = context.read<KeyboardState>();
    final service = context.read<KeyboardService>();
    
    if (state.isChinese && state.currentPinyin.isNotEmpty) {
      // In Chinese mode with pinyin, delete from pinyin buffer first
      if (state.currentPinyin.length > 1) {
        state.updatePinyin(state.currentPinyin.substring(0, state.currentPinyin.length - 1));
      } else {
        state.clearPinyin();
      }
    } else {
      // No pinyin or in English mode, delete from text field
      service.deleteText();
    }
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
