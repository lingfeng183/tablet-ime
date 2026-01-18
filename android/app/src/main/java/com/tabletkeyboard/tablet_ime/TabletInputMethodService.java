package com.tabletkeyboard.tablet_ime;

import android.content.Context;
import android.inputmethodservice.InputMethodService;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputConnection;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import io.flutter.embedding.android.FlutterView;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.plugin.common.MethodChannel;

public class TabletInputMethodService extends InputMethodService {

    private static final String CHANNEL = "com.tabletkeyboard/tablet_ime";
    private static final String ENGINE_ID = "tablet_ime_engine";
    
    private InputConnection inputConnection;
    private FlutterEngine flutterEngine;
    private FlutterView flutterView;
    private MethodChannel methodChannel;

    @Override
    public void onCreate() {
        super.onCreate();
        MainActivity.setImeService(this);
        
        // Initialize Flutter engine
        flutterEngine = FlutterEngineCache.getInstance().get(ENGINE_ID);
        if (flutterEngine == null) {
            flutterEngine = new FlutterEngine(this);
            flutterEngine.getDartExecutor().executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault()
            );
            FlutterEngineCache.getInstance().put(ENGINE_ID, flutterEngine);
        }
        
        // Set up method channel
        methodChannel = new MethodChannel(
            flutterEngine.getDartExecutor().getBinaryMessenger(), 
            CHANNEL
        );
        methodChannel.setMethodCallHandler((call, result) -> {
            switch (call.method) {
                case "sendText":
                    String text = call.argument("text");
                    if (text != null) {
                        sendText(text);
                        result.success(null);
                    } else {
                        result.error("INVALID_ARGUMENT", "Text is null", null);
                    }
                    break;
                
                case "sendKeyEvent":
                    Integer keyCode = call.argument("keyCode");
                    Boolean isDown = call.argument("isDown");
                    if (keyCode != null && isDown != null) {
                        sendKeyEvent(keyCode, isDown);
                        result.success(null);
                    } else {
                        result.error("INVALID_ARGUMENT", "Invalid arguments", null);
                    }
                    break;
                
                case "deleteText":
                    deleteText();
                    result.success(null);
                    break;
                
                case "commitText":
                    String commitText = call.argument("text");
                    if (commitText != null) {
                        commitText(commitText);
                        result.success(null);
                    } else {
                        result.error("INVALID_ARGUMENT", "Text is null", null);
                    }
                    break;
                
                default:
                    result.notImplemented();
                    break;
            }
        });
    }

    @Override
    public View onCreateInputView() {
        // Create Flutter view for keyboard
        flutterView = new FlutterView(this);
        flutterView.attachToFlutterEngine(flutterEngine);
        
        // Wrap in a container with proper layout params
        FrameLayout container = new FrameLayout(this);
        FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.WRAP_CONTENT
        );
        container.addView(flutterView, params);
        
        return container;
    }

    @Override
    public void onStartInput(EditorInfo attribute, boolean restarting) {
        super.onStartInput(attribute, restarting);
        inputConnection = getCurrentInputConnection();
    }

    @Override
    public void onStartInputView(EditorInfo info, boolean restarting) {
        super.onStartInputView(info, restarting);
        inputConnection = getCurrentInputConnection();
    }

    @Override
    public void onDestroy() {
        if (flutterView != null) {
            flutterView.detachFromFlutterEngine();
        }
        super.onDestroy();
    }

    public void sendText(String text) {
        if (inputConnection != null) {
            inputConnection.commitText(text, 1);
        }
    }

    public void deleteText() {
        if (inputConnection != null) {
            inputConnection.deleteSurroundingText(1, 0);
        }
    }

    public void sendKeyEvent(int keyCode, boolean isDown) {
        if (inputConnection != null) {
            inputConnection.sendKeyEvent(new KeyEvent(
                isDown ? KeyEvent.ACTION_DOWN : KeyEvent.ACTION_UP,
                keyCode
            ));
        }
    }

    public void commitText(String text) {
        if (inputConnection != null) {
            inputConnection.commitText(text, 1);
        }
    }
}
