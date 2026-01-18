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
    private static final Object ENGINE_LOCK = new Object();
    
    private InputConnection inputConnection;
    private FlutterEngine flutterEngine;
    private FlutterView flutterView;
    private MethodChannel methodChannel;

    @Override
    public void onCreate() {
        super.onCreate();
        MainActivity.setImeService(this);
        
        // Initialize Flutter engine
        flutterEngine = getOrCreateFlutterEngine();
        
        // Set up method channel
        setupMethodChannel();
    }

    private FlutterEngine getOrCreateFlutterEngine() {
        synchronized (ENGINE_LOCK) {
            FlutterEngine engine = FlutterEngineCache.getInstance().get(ENGINE_ID);
            if (engine == null) {
                engine = new FlutterEngine(getApplicationContext());
                engine.getDartExecutor().executeDartEntrypoint(
                    DartExecutor.DartEntrypoint.createDefault()
                );
                FlutterEngineCache.getInstance().put(ENGINE_ID, engine);
            }
            return engine;
        }
    }

    private void setupMethodChannel() {
        methodChannel = new MethodChannel(
            flutterEngine.getDartExecutor().getBinaryMessenger(), 
            CHANNEL
        );
        methodChannel.setMethodCallHandler((call, result) -> {
            switch (call.method) {
                case "commitText":
                    String text = call.argument("text");
                    if (text != null) {
                        commitText(text);
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
                
                default:
                    result.notImplemented();
                    break;
            }
        });
    }

    @Override
    public View onCreateInputView() {
        // Clean up previous view if exists
        if (flutterView != null) {
            ViewGroup parent = (ViewGroup) flutterView.getParent();
            if (parent != null) {
                parent.removeView(flutterView);
            }
            flutterView.detachFromFlutterEngine();
            flutterView = null;
        }
        
        // Create Flutter view for keyboard
        flutterView = new FlutterView(this);
        flutterView.attachToFlutterEngine(flutterEngine);
        
        // Wrap in a container with constrained height (40% of screen height)
        FrameLayout container = new FrameLayout(this);
        
        // Get screen height using WindowManager
        android.view.WindowManager wm = (android.view.WindowManager) getSystemService(Context.WINDOW_SERVICE);
        int screenHeight;
        
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.R) {
            // Use WindowMetrics for API 30+
            android.view.WindowMetrics windowMetrics = wm.getCurrentWindowMetrics();
            android.graphics.Rect bounds = windowMetrics.getBounds();
            screenHeight = bounds.height();
        } else {
            // Use deprecated getSize for older APIs
            android.view.Display display = wm.getDefaultDisplay();
            android.graphics.Point size = new android.graphics.Point();
            display.getSize(size);
            screenHeight = size.y;
        }
        
        int keyboardHeight = (int) (screenHeight * 0.4); // 40% of screen height
        
        FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            keyboardHeight
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
        // Clean up method channel
        if (methodChannel != null) {
            methodChannel.setMethodCallHandler(null);
        }
        
        // Clean up flutter view
        if (flutterView != null) {
            ViewGroup parent = (ViewGroup) flutterView.getParent();
            if (parent != null) {
                parent.removeView(flutterView);
            }
            flutterView.detachFromFlutterEngine();
            flutterView = null;
        }
        
        MainActivity.setImeService(null);
        super.onDestroy();
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
