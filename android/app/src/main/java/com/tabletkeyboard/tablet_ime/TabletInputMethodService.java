package com.tabletkeyboard.tablet_ime;

import android.inputmethodservice.InputMethodService;
import android.inputmethodservice.Keyboard;
import android.inputmethodservice.KeyboardView;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.InputConnection;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class TabletInputMethodService extends InputMethodService {
    private static final String CHANNEL = "com.tabletkeyboard/tablet_ime";
    private MethodChannel methodChannel;
    private InputConnection inputConnection;

    @Override
    public void onCreate() {
        super.onCreate();
    }

    @Override
    public View onCreateInputView() {
        FlutterActivity activity = new FlutterActivity() {
            @Override
            protected void configureFlutterEngine(FlutterEngine flutterEngine) {
                super.configureFlutterEngine(flutterEngine);
                methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);
                methodChannel.setMethodCallHandler((call, result) -> {
                    switch (call.method) {
                        case "sendText":
                            String text = call.argument("text");
                            if (inputConnection != null) {
                                inputConnection.commitText(text, 1);
                            }
                            result.success(null);
                            break;
                        case "deleteText":
                            if (inputConnection != null) {
                                inputConnection.deleteSurroundingText(1, 0);
                            }
                            result.success(null);
                            break;
                        case "sendKeyEvent":
                            int keyCode = call.argument("keyCode");
                            boolean isDown = call.argument("isDown");
                            if (inputConnection != null) {
                                inputConnection.sendKeyEvent(new KeyEvent(
                                    isDown ? KeyEvent.ACTION_DOWN : KeyEvent.ACTION_UP,
                                    keyCode
                                ));
                            }
                            result.success(null);
                            break;
                        case "commitText":
                            String commitText = call.argument("text");
                            if (inputConnection != null) {
                                inputConnection.commitText(commitText, 1);
                            }
                            result.success(null);
                            break;
                        default:
                            result.notImplemented();
                    }
                });
            }
        };

        return activity.onCreateView(null);
    }

    @Override
    public void onStartInput(View attribute, boolean restarting) {
        super.onStartInput(attribute, restarting);
        inputConnection = getCurrentInputConnection();
    }

    @Override
    public void onStartInputView(EditorInfo info, boolean restarting) {
        super.onStartInputView(info, restarting);
        inputConnection = getCurrentInputConnection();
    }
}
