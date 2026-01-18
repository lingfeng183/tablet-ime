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
    // Phrases
    'nihao': ['你好', '尼豪', '泥好'],
    'women': ['我们', '我门'],
    'nimen': ['你们', '泥们'],
    'tamen': ['他们', '她们', '它们'],
    'shenme': ['什么', '神么'],
    'zenme': ['怎么', '怎末'],
    'weishenme': ['为什么'],
    'zhidao': ['知道', '之道'],
    'juede': ['觉得'],
    'shijian': ['时间', '时建'],
    'xianzai': ['现在', '先在'],
    'jintian': ['今天'],
    'mingtian': ['明天'],
    'zuotian': ['昨天'],
    'meiyou': ['没有'],
    'keyi': ['可以'],
    'yinggai': ['应该'],
    'keneng': ['可能'],
    'xihuan': ['喜欢'],
    'gaoxing': ['高兴'],
    
    // Single characters - common
    'zhong': ['中', '重', '钟', '忠', '终'],
    'guo': ['国', '过', '果', '锅', '郭'],
    'wen': ['文', '问', '闻', '稳', '温'],
    'shu': ['书', '输', '树', '数', '术'],
    'ni': ['你', '尼', '泥', '逆', '拟'],
    'wo': ['我', '握', '沃', '窝'],
    'ta': ['他', '她', '它', '塔', '踏'],
    'de': ['的', '得', '德', '地'],
    'shi': ['是', '时', '事', '十', '史'],
    'zhe': ['这', '者', '着', '遮'],
    'you': ['有', '又', '右', '友'],
    'bu': ['不', '步', '布', '部'],
    'zai': ['在', '再', '载', '灾'],
    'ren': ['人', '任', '仁', '认'],
    'le': ['了', '乐', '勒', '乐'],
    'shang': ['上', '商', '伤', '尚'],
    'xia': ['下', '夏', '侠', '吓'],
    'hui': ['会', '回', '汇', '惠'],
    'ke': ['可', '课', '克', '客'],
    'yi': ['一', '已', '意', '以', '易'],
    'hao': ['好', '号', '毫', '豪'],
    'dao': ['到', '道', '倒', '导'],
    'geng': ['更', '耕', '庚', '梗'],
    'lai': ['来', '莱', '赖', '徕'],
    
    // More common words
    'zuo': ['做', '作', '坐', '左'],
    'qu': ['去', '区', '取', '曲'],
    'kan': ['看', '刊', '砍'],
    'shuo': ['说', '朔'],
    'xiang': ['想', '向', '象', '相'],
    'neng': ['能', '耐'],
    'yao': ['要', '药', '腰'],
    'shei': ['谁', '水'],
    'nar': ['哪', '那'],
    'zher': ['这'],
    'na': ['那', '拿', '哪'],
    'ge': ['个', '各', '歌'],
    'li': ['里', '理', '力', '立'],
    'yong': ['用', '勇', '永'],
    'dian': ['点', '电', '店'],
    'tian': ['天', '田', '甜'],
    'nian': ['年', '念'],
    'yue': ['月', '乐', '约'],
    'ri': ['日'],
    'xing': ['行', '星', '性'],
    'qi': ['期', '起', '气', '七'],
    
    // Adverbs and particles
    'hen': ['很', '狠'],
    'dou': ['都', '斗'],
    'ye': ['也', '夜', '叶'],
    'hai': ['还', '海', '孩'],
    'jiu': ['就', '九', '旧'],
    'cai': ['才', '菜', '财'],
    'ma': ['吗', '妈', '马'],
    'ba': ['吧', '把', '爸'],
    'ne': ['呢', '呐'],
    'a': ['啊', '阿'],
    
    // Numbers
    'ling': ['零', '灵'],
    'er': ['二', '儿', '而'],
    'san': ['三'],
    'si': ['四', '死', '思'],
    'wu': ['五', '无', '舞'],
    'liu': ['六', '流'],
    'ba': ['八', '把', '吧'],
    'jiu': ['九', '就', '久'],
    'shi': ['十', '是', '时'],
    'bai': ['百', '白'],
    'qian': ['千', '钱', '前'],
    'wan': ['万', '完'],
  };
}
