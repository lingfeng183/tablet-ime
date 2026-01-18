import 'package:flutter/services.dart';

class KeyboardService {
  final MethodChannel _channel = const MethodChannel('com.tabletkeyboard/tablet_ime');

  Future<void> commitText(String text) async {
    try {
      await _channel.invokeMethod('commitText', {'text': text});
    } catch (e) {
      print('Error committing text: $e');
    }
  }

  Future<void> sendKeyEvent(int keyCode, bool isDown) async {
    try {
      await _channel.invokeMethod('sendKeyEvent', {
        'keyCode': keyCode,
        'isDown': isDown,
      });
    } catch (e) {
      print('Error sending key event: $e');
    }
  }

  Future<void> deleteText() async {
    try {
      await _channel.invokeMethod('deleteText');
    } catch (e) {
      print('Error deleting text: $e');
    }
  }
}
