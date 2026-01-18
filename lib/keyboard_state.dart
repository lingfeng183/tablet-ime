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
  set selectedCandidateIndex(int value) {
    _selectedCandidateIndex = value;
    notifyListeners();
  }
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
    // Don't generate candidates automatically - wait for Space key
    _candidates = [];
    _selectedCandidateIndex = 0;
    notifyListeners();
  }

  void showCandidates() {
    // Generate candidates when Space is pressed
    if (_currentPinyin.isNotEmpty) {
      _candidates = _generateCandidates(_currentPinyin);
      _selectedCandidateIndex = 0;
      notifyListeners();
    }
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
    // Multi-character pinyin
    'nihao': ['你好', '尼豪', '泥好'],
    'zhong': ['中', '重', '钟', '忠'],
    'guo': ['国', '过', '果', '锅'],
    'wen': ['文', '问', '闻', '稳'],
    'shu': ['书', '输', '树', '数'],
    'ni': ['你', '尼', '泥', '逆'],
    'wo': ['我', '握', '沃'],
    'ta': ['他', '她', '它', '塔'],
    'de': ['的', '得', '德'],
    'shi': ['是', '时', '事', '十'],
    'zhe': ['这', '者', '着'],
    'you': ['有', '又', '右'],
    'bu': ['不', '步', '布'],
    'zai': ['在', '再', '载'],
    'ren': ['人', '任', '仁'],
    'le': ['了', '乐', '勒'],
    'shang': ['上', '商', '伤'],
    'xia': ['下', '夏', '侠'],
    'hui': ['会', '回', '汇'],
    'ke': ['可', '课', '克'],
    'yi': ['一', '已', '意', '以'],
    'hao': ['好', '号', '毫'],
    'dao': ['到', '道', '倒'],
    'geng': ['更', '耕', '庚'],
    'lai': ['来', '莱', '赖'],
    // Add more common pinyin combinations as needed
  };
}
