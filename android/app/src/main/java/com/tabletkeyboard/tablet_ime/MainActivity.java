package com.tabletkeyboard.tablet_ime;

import android.os.Bundle;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.tabletkeyboard/tablet_ime";
    private static TabletInputMethodService imeService;

    public static void setImeService(TabletInputMethodService service) {
        imeService = service;
    }

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler((call, result) -> {
                if (imeService == null) {
                    result.error("IME_NOT_ACTIVE", "Input method service is not active", null);
                    return;
                }

                switch (call.method) {
                    case "sendText":
                        String text = call.argument("text");
                        if (text != null) {
                            imeService.sendText(text);
                            result.success(null);
                        } else {
                            result.error("INVALID_ARGUMENT", "Text argument is null", null);
                        }
                        break;
                    
                    case "sendKeyEvent":
                        Integer keyCode = call.argument("keyCode");
                        Boolean isDown = call.argument("isDown");
                        if (keyCode != null && isDown != null) {
                            imeService.sendKeyEvent(keyCode, isDown);
                            result.success(null);
                        } else {
                            result.error("INVALID_ARGUMENT", "Invalid keyCode or isDown", null);
                        }
                        break;
                    
                    case "deleteText":
                        imeService.deleteText();
                        result.success(null);
                        break;
                    
                    case "commitText":
                        String commitText = call.argument("text");
                        if (commitText != null) {
                            imeService.commitText(commitText);
                            result.success(null);
                        } else {
                            result.error("INVALID_ARGUMENT", "Text argument is null", null);
                        }
                        break;
                    
                    default:
                        result.notImplemented();
                        break;
                }
            });
    }
}
