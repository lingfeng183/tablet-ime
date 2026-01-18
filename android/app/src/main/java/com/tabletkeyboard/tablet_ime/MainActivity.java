package com.tabletkeyboard.tablet_ime;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.tabletkeyboard/tablet_ime";
    private static TabletInputMethodService imeService;

    public static synchronized void setImeService(TabletInputMethodService service) {
        imeService = service;
    }

    private static synchronized TabletInputMethodService getImeService() {
        return imeService;
    }

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler((call, result) -> {
                TabletInputMethodService service = getImeService();
                if (service == null) {
                    result.error("IME_NOT_ACTIVE", "Input method service is not active", null);
                    return;
                }

                switch (call.method) {
                    case "commitText":
                        String text = call.argument("text");
                        if (text != null) {
                            service.commitText(text);
                            result.success(null);
                        } else {
                            result.error("INVALID_ARGUMENT", "Text argument is null", null);
                        }
                        break;
                    
                    case "sendKeyEvent":
                        Integer keyCode = call.argument("keyCode");
                        Boolean isDown = call.argument("isDown");
                        if (keyCode != null && isDown != null) {
                            service.sendKeyEvent(keyCode, isDown);
                            result.success(null);
                        } else {
                            result.error("INVALID_ARGUMENT", "Invalid keyCode or isDown", null);
                        }
                        break;
                    
                    case "deleteText":
                        service.deleteText();
                        result.success(null);
                        break;
                    
                    default:
                        result.notImplemented();
                        break;
                }
            });
    }
}
