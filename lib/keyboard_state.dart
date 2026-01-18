import 'package:flutter/material.dart';

class KeyboardState extends ChangeNotifier {
  bool _isChinese = true;
  String _currentPinyin = '';
  List<String> _candidates = [];
  int _selectedCandidateIndex = 0;
  bool _isFloating = false;
  Offset _floatingPosition = const Offset(20, 100);
  double _floatingWidth = 600;
  double _floatingHeight = 300;
  bool _isFullPCLayout = true; // PC完整布局模式，默认开启
  bool _shiftPressed = false;
  bool _ctrlPressed = false;
  bool _altPressed = false;

  bool get isChinese => _isChinese;
  String get currentPinyin => _currentPinyin;
  List<String> get candidates => _candidates;
  int get selectedCandidateIndex => _selectedCandidateIndex;
  bool get isFloating => _isFloating;
  Offset get floatingPosition => _floatingPosition;
  double get floatingWidth => _floatingWidth;
  double get floatingHeight => _floatingHeight;
  bool get isFullPCLayout => _isFullPCLayout;
  bool get shiftPressed => _shiftPressed;
  bool get ctrlPressed => _ctrlPressed;
  bool get altPressed => _altPressed;

  void togglePCLayout() {
    _isFullPCLayout = !_isFullPCLayout;
    notifyListeners();
  }

  void setShiftPressed(bool pressed) {
    _shiftPressed = pressed;
    notifyListeners();
  }

  void setCtrlPressed(bool pressed) {
    _ctrlPressed = pressed;
    notifyListeners();
  }

  void setAltPressed(bool pressed) {
    _altPressed = pressed;
    notifyListeners();
  }

  void toggleFloating() {
    _isFloating = !_isFloating;
    notifyListeners();
  }

  void updateFloatingPosition(Offset position) {
    _floatingPosition = position;
    notifyListeners();
  }

  void updateFloatingSize(double width, double height) {
    _floatingWidth = width;
    _floatingHeight = height;
    notifyListeners();
  }

  void toggleLanguage() {
    _isChinese = !_isChinese;
    _currentPinyin = '';
    _candidates = [];
    _selectedCandidateIndex = 0;
    notifyListeners();
  }

  void updatePinyin(String pinyin) {
    _currentPinyin = pinyin;
    _candidates = _generateCandidates(pinyin);
    _selectedCandidateIndex = 0;
    notifyListeners();
  }

  List<String> _generateCandidates(String pinyin) {
    if (pinyin.isEmpty) return [];
    return _pinyinToChinese[pinyin] ?? [pinyin];
  }

  void selectCandidate(int index) {
    if (index >= 0 && index < _candidates.length) {
      _selectedCandidateIndex = index;
      notifyListeners();
    }
  }

  void clearPinyin() {
    _currentPinyin = '';
    _candidates = [];
    _selectedCandidateIndex = 0;
    notifyListeners();
  }

  static final Map<String, List<String>> _pinyinToChinese = {
    'nihao': ['你好', '尼豪', '泥好'],
    'zhong': ['中', '重', '钟', '忠'],
    'guo': ['国', '过', '果', '锅'],
    'wen': ['文', '问', '闻', '稳'],
    'shu': ['书', '输', '树', '数'],
    'p': ['p', 'P'],
    'q': ['q', 'Q'],
    'w': ['w', 'W'],
    'e': ['e', 'E'],
    'r': ['r', 'R'],
    't': ['t', 'T'],
    'y': ['y', 'Y'],
    'u': ['u', 'U'],
    'i': ['i', 'I'],
    'o': ['o', 'O'],
    'a': ['a', 'A', '啊'],
    's': ['s', 'S'],
    'd': ['d', 'D'],
    'f': ['f', 'F'],
    'g': ['g', 'G'],
    'h': ['h', 'H'],
    'j': ['j', 'J'],
    'k': ['k', 'K'],
    'l': ['l', 'L'],
    'z': ['z', 'Z'],
    'x': ['x', 'X'],
    'c': ['c', 'C'],
    'v': ['v', 'V'],
    'b': ['b', 'B'],
    'n': ['n', 'N'],
    'm': ['m', 'M'],
  };
}
